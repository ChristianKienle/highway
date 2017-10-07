import Foundation
import Url
import FileSystem

public struct Archive {
    // MARK: - Properties
    public let url: Absolute
    public var archivePlist: [String: Any]
    public var appUrl: Absolute
    
    // MARK: - Init
    init(url: Absolute, fileSystem: FileSystem) throws {
        self.url = url
        let rootDir = fileSystem.directory(at: url)
        guard rootDir.isExistingDirectory else {
            throw "File at \(rootDir) is not a directory and thus no valid xcarchive."
        }
        let infoPlistData = try rootDir.file(named: "Info.plist").data()
        let rawPlist = try PropertyListSerialization.propertyList(from: infoPlistData, options: [], format: nil) as? [String : Any]
        guard let archivePlist = rawPlist else {
            throw "invalid"
        }
        self.archivePlist = archivePlist
        guard let applicationProperties = archivePlist["ApplicationProperties"] as? [String:Any] else {
            throw ""
        }
        guard let applicationPath = applicationProperties["ApplicationPath"] as? String else {
            throw ""
        }
        appUrl = url.appending("Products").appending(applicationPath)
        try fileSystem.assertItem(at: appUrl, is: .directory)
    }
}
