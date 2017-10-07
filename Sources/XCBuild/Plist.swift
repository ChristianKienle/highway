import Foundation
import Url
import FileSystem

public final class Plist<ObjectType: Codable> {
    // MARK: - Init
    internal init(url: Absolute, object: ObjectType) {
        self.url = url
        self.object = object
    }
    
    public class func plist(byWriting object: ObjectType, to fileSystem: FileSystem) throws -> Plist<ObjectType> {
        let contents = try PropertyListEncoder().encode(object)
        let tempDir = try fileSystem.uniqueTemporaryDirectoryUrl()
        let url = tempDir.appending("generated.plist")
        let object = try PropertyListDecoder().decode(ObjectType.self, from: contents)
        try fileSystem.writeData(contents, to: url)
        return self.init(url: url, object: object)
    }
    
    public class func plist(byReading url: Absolute, `in` fileSystem: FileSystem) throws -> Plist<ObjectType> {
        let contents = try fileSystem.dataContentsOfFile(at: url)
        let object = try PropertyListDecoder().decode(ObjectType.self, from: contents)
        return self.init(url: url, object: object)
    }
    
    // MARK: - Properties
    public let url: Absolute
    public let object: ObjectType
}
