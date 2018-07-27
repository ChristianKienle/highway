import Foundation
import Url
import ZFile
import SourceryAutoProtocols

/**
 Represents an invocation of xcodebuild with "-exportArchive". From the xcodebuild manpage:

 - Remark:
 Specifies that an archive should be exported. Requires:
     - `-archivePath`
     - `-exportPath` (and)
     - `-exportOptionsPlist`
 
 Cannot be passed together with an action.

 Sample:
 ````
 xcodebuild -exportArchive \
            -archivePath $path_to.xcarchive \
            -exportPath /some/temp/dir
            -exportOptionsPlist path/to/plist.plist
 ````
*/

public protocol ExportArchiveOptionsProtocol: Codable, AutoMockable {
    
    /// sourcery:inline:ExportArchiveOptions.AutoGenerateProtocol
    var archivePath: FolderProtocol { get }
    var exportPath: String { get }
   
    /// sourcery:end
}

public struct ExportArchiveOptions: ExportArchiveOptionsProtocol, AutoGenerateProtocol {
    
    // MARK: - Properties
    
    // Option: -archivePath
    // Type: path
    // Notes: Directory at archivePath already exist. Should be equal to
    //        the directory archivePath from the archive options.
    public let archivePath: FolderProtocol
    
    // Option: -exportPath
    // Type: path
    // Notes: Directory at exportPath must not exist already.
    public let exportPath: String //
    
    public enum CodingKeys: String, CodingKey {
        case archivePath = "ArchivePath"
        case exportPath = "ExportPath"
    }
    
    // MARK: - Init
    public init(archivePath: FolderProtocol, exportPath: String) {
        self.archivePath = archivePath
        self.exportPath = exportPath
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let ap = try container.decode(String.self, forKey: CodingKeys.archivePath)
        archivePath = try Folder(path: ap)
        
        exportPath = try container.decode(String.self, forKey: CodingKeys.exportPath)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(archivePath.path, forKey: CodingKeys.archivePath)
        try container.encode(exportPath, forKey: CodingKeys.exportPath)
    }
   
}
