import Foundation
import Url
import FileSystem

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
public struct ExportArchiveOptions {
    // MARK: - Init
    public init() {}
    
    // MARK: - Properties
    
    // Option: -archivePath
    // Type: path
    // Notes: Directory at archivePath already exist. Should be equal to
    //        the directory archivePath from the archive options.
    public var archivePath: Absolute?
    
    // Option: -exportPath
    // Type: path
    // Notes: Directory at exportPath must not exist already.
    public var exportPath: Absolute? //
    
    // Option: -exportOptionsPlist
    // Type: path
    // Notes: Must exist and be a valid plist file
    public var exportOptionsPlist: Plist<ExportOptions>?
}
