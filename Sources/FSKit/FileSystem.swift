import Foundation

// All throwing methods HAVE to throw FSError if they throw anything at all.
public protocol FileSystem: class {
    // MARK: - Getting global Urls
    func homeDirectoryUrl() throws -> AbsoluteUrl
    func temporaryDirectoryUrl() throws -> AbsoluteUrl

    // MARK: - Primitives for reading, writing and creating directories
    func createDirectory(at url: AbsoluteUrl) throws
    func writeData(_ data: Data, to url: AbsoluteUrl) throws
    func writeString(_ string: String, to url: AbsoluteUrl) throws
    func data(at url: AbsoluteUrl) throws -> Data
    func deleteItem(at url: AbsoluteUrl) throws
    func itemMetadata(at url: AbsoluteUrl) throws -> Metadata

    // MARK: - Convenience
    func directory(at url: AbsoluteUrl) -> Directory
    func file(at url: AbsoluteUrl) -> File
    func stringContentsOfFile(at url: AbsoluteUrl) throws -> String
    func dataContentsOfFile(at url: AbsoluteUrl) throws -> Data
    func assertItem(at url: AbsoluteUrl, `is` itemType: Metadata.ItemType) throws
    func uniqueTemporaryDirectoryUrl() throws -> AbsoluteUrl
}

public struct Metadata {
    public enum ItemType {
        case directory, file
    }
    public init(type: ItemType) {
        self.type = type
    }
    public var type: ItemType
}

// MARK: - FileSystem Defaults
extension FileSystem {
    // Primitives
    public func writeString(_ string: String, to url: AbsoluteUrl) throws {
        guard let data = string.data(using: .utf8) else {
            throw FSError.other("Failed to convert data to utf8 string.")
        }
        try writeData(data, to: url)
    }
    // Convenience
    public func file(at url: AbsoluteUrl) -> File {
        return File(url: url, fileSystem: self)
    }
    public func directory(at url: AbsoluteUrl) -> Directory {
        return Directory(url: url, in: self)
    }
    public func stringContentsOfFile(at url: AbsoluteUrl) throws -> String {
        return try file(at: url).string()
    }
    public func dataContentsOfFile(at url: AbsoluteUrl) throws -> Data {
        return try file(at: url).data()
    }
    public func assertItem(at url: AbsoluteUrl, is itemType: Metadata.ItemType) throws {
        let meta = try itemMetadata(at: url)
        let actualType = meta.type
        let actualVsExpected = (actualType, itemType)
        switch actualVsExpected {
        case let(actual, expected) where actual == expected: return
        default: throw FSError.typeMismatch
        }
    }
    public func uniqueTemporaryDirectoryUrl() throws -> AbsoluteUrl {
        let tmp = try temporaryDirectoryUrl()
        let unique = tmp.appending(UUID().uuidString)
        try createDirectory(at: unique)
        return unique
    }
}

public extension FileSystem {
    public typealias ExistingItemHandler<R, I> = (FileSystem, I) throws -> R

    public func withExistingFile<R>(at url: AbsoluteUrl, defaultValue: R, _ body: ExistingItemHandler<R, File>) throws -> R {
        do {
            try assertItem(at: url, is: .file)
            let file = self.file(at: url)
            return try body(self, file)
        } catch {
            return defaultValue
        }
    }
    public func withExistingDirectory<R>(at url: AbsoluteUrl, defaultValue: R, _ body: ExistingItemHandler<R, Directory>) throws -> R {
        do {
            try assertItem(at: url, is: .directory)
            let directory = self.directory(at: url)
            return try body(self, directory)
        } catch {
            return defaultValue
        }
    }
}
