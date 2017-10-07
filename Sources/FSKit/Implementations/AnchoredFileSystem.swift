import Foundation

public final class AnchoredFileSystem {
    // MARK: - Init
    public init(underlyingFileSystem: FileSystem, achnoredAt root: Absolute) {
        self.underlyingFileSystem = underlyingFileSystem
        self.root = root
    }
    
    // MARL: Properties
    public let underlyingFileSystem: FileSystem
    public let root: Absolute
}

extension AnchoredFileSystem: FileSystem {
    public func assertItem(at url: Absolute, is itemType: Metadata.ItemType) throws {
        let meta = try itemMetadata(at: url)
        guard meta.type == itemType else {
            throw FSError.typeMismatch
        }
    }
    public func itemMetadata(at url: Absolute) throws -> Metadata {
        return try underlyingFileSystem.itemMetadata(at: _completeUrl(url))
    }
    
    public func homeDirectoryUrl() throws -> Absolute {
        return try underlyingFileSystem.homeDirectoryUrl()
    }
    
    public func temporaryDirectoryUrl() throws -> Absolute {
        return try underlyingFileSystem.temporaryDirectoryUrl()
    }
    
    public func createDirectory(at url: Absolute) throws {
        try underlyingFileSystem.createDirectory(at: _completeUrl(url))
    }
    
    public func writeData(_ data: Data, to url: Absolute) throws {
        try underlyingFileSystem.writeData(data, to: _completeUrl(url))
    }
    
    public func data(at url: Absolute) throws -> Data {
        return try underlyingFileSystem.data(at: _completeUrl(url))
    }
    
    public func deleteItem(at url: Absolute) throws {
        try underlyingFileSystem.deleteItem(at: _completeUrl(url))
    }
    public func writeString(_ string: String, to url: Absolute) throws {
        guard let data = string.data(using: .utf8) else {
            throw FSError.other("Failed to convert data to utf8 string.")
        }
        try writeData(data, to: url)
    }

    // MARK: - Convenience
    public func file(at url: Absolute) -> File {
        return File(url: url, fileSystem: self)
    }
    public func directory(at url: Absolute) -> Directory {
        return Directory(url: url, in: self)
    }
    public func stringContentsOfFile(at url: Absolute) throws -> String {
        return try file(at: _completeUrl(url)).string()
    }
    public func dataContentsOfFile(at url: Absolute) throws -> Data {
        return try file(at: _completeUrl(url)).data()
    }
    
    private func _completeUrl(_ proposedUrl: Absolute) -> Absolute {
        if proposedUrl == Absolute.root {
            return root
        } else {
            let relativePath = proposedUrl.asRelativePath
            return Absolute(path: relativePath, relativeTo: root)
        }
    }
}

