import Foundation

public class LocalFileSystem: FileSystem {
    // MARK: - Init
    public init() {}
    
    // MARK: - Properties
    private let _fm = FileManager()

    // MARK: - FileSystem
    public func homeDirectoryUrl() throws -> AbsoluteUrl {
        return AbsoluteUrl(NSHomeDirectory())
    }
    
    public func temporaryDirectoryUrl() throws -> AbsoluteUrl {
        return AbsoluteUrl(NSTemporaryDirectory())
    }
    
    public func deleteItem(at url: AbsoluteUrl) throws {
        try _withItem(at: url) {
            try _fm.removeItem(atAbsolute: url)
        }
    }
    
    public func createDirectory(at url: AbsoluteUrl) throws {
        try _withItem(at: url) {
            try _fm.createDirectory(atAbsolute: url, withIntermediateDirectories: true)
        }
    }

    public func writeData(_ data: Data, to url: AbsoluteUrl) throws {
        try _withItem(at: url) {
            try data.write(toAbsolute: url)
        }
    }
    
    public func data(at url: AbsoluteUrl) throws -> Data {
        return try _withItem(at: url) {
            return try Data(contentsOfAbsolute: url)
        }
    }
    
    public func itemMetadata(at url: AbsoluteUrl) throws -> Metadata {
        var isDir = ObjCBool(false)
        guard _fm.fileExists(atPath: url.path, isDirectory: &isDir) else {
            throw FSError.doesNotExist
        }
        let type: Metadata.ItemType = isDir.boolValue ? .directory : .file
        return Metadata(type: type)
    }
    
    // MARK: - Private Helper
    typealias ItemHandler<R> = () throws -> (R)
    // Executes handler. If handler throws any error this method automatically transforms the error
    // to a FSError and rethrows that one.
    private func _withItem<R>(at url: AbsoluteUrl, handler: ItemHandler<R>) throws -> R {
        let notFoundCodes: Set<CocoaError.Code> = [.fileNoSuchFile, .fileReadNoSuchFile]
        do {
            return try handler()
        } catch let error as CocoaError where notFoundCodes.contains(error.code) {
            throw FSError.doesNotExist
        }
        catch {
            throw FSError.other(error)
        }
    }
}
