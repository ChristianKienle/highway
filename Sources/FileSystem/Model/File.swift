import Foundation
import Url

// All throwing methods HAVE to throw FileSystemError if they throw anything at all.
public class File {
    // MARK: - Init
    init(url: Absolute, fileSystem: FileSystem) {
        self.url = url
        self.fileSystem = fileSystem
    }
    
    // MARK: - Properties
    let url: Absolute
    let fileSystem: FileSystem
    public var isExistingFile: Bool {
        guard let type = try? fileSystem.itemMetadata(at: url).type else {
            return false
        }
        return type == .file
    }
    // MARK: - Working with the File
    public func data() throws -> Data {
        return try fileSystem.data(at: url)
    }
    
    public func setData(_ data: Data) throws {
        try fileSystem.writeData(data, to: url)
    }
    
    public func string() throws -> String {
        let data = try self.data()
        guard let result = String(data: data, encoding: .utf8) else {
            throw FSError.other("Cannot convert contents of file \(url.description) to string.")
        }
        return result
    }
}
