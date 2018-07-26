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

public protocol ExportArchiveOptionsProtocol: AutoMockable {
    
    /// sourcery:inline:ExportArchiveOptions.AutoGenerateProtocol
    var archivePath: FolderProtocol { get }
    var exportPath: String { get }
    var exportOptionsPlist: PlistFactory<ExportOptions> { get }
   
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
    
    // Option: -exportOptionsPlist
    // Type: path
    // Notes: Must exist and be a valid plist file
    public let exportOptionsPlist: PlistFactory<ExportOptions>
    
    // MARK: - Init
    public init(archivePath: FolderProtocol, exportPath: String, exportOptionsPlist: PlistFactory<ExportOptions>) {
        self.archivePath = archivePath
        self.exportPath = exportPath
        self.exportOptionsPlist = exportOptionsPlist
    }
   
}
