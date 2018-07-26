import Foundation
import Url
import ZFile

public final class PlistFactory<ObjectType: Codable> {
    // MARK: - Properties
    public let generatedPlist: FileProtocol
    public let object: ObjectType
    
    internal init(generatedPlist: FileProtocol, object: ObjectType) {
        self.generatedPlist = generatedPlist
        self.object = object
    }
    
    public class func plist(byWriting object: ObjectType, to fileSystem: FileSystemProtocol) throws -> PlistFactory<ObjectType> {
        let contents = try PropertyListEncoder().encode(object)
        let tempDir = try fileSystem.temporaryFolder.createSubfolderIfNeeded(withName: "\(Date().timeIntervalSince1970)")
        let url = try tempDir.createFile(named: "generated.plist")
        let object = try PropertyListDecoder().decode(ObjectType.self, from: contents)
        try url.write(data: contents)
        
        return self.init(generatedPlist: url, object: object)
    }
    
    public class func plist(byReading url: FileProtocol, `in` fileSystem: FileSystemProtocol) throws -> PlistFactory<ObjectType> {
        let contents = try url.read()
        let object = try PropertyListDecoder().decode(ObjectType.self, from: contents)
        return self.init(generatedPlist: url, object: object)
    }
    
   
}
