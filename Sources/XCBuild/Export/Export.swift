import Foundation
import Url
import ZFile
import SourceryAutoProtocols

public protocol ExportProtocol: AutoMockable {
    
    /// sourcery:inline:Export.AutoGenerateProtocol
    var folder: FolderProtocol { get }
    var ipa: FileProtocol { get }
    /// sourcery:end
}

public struct Export: ExportProtocol, AutoGenerateProtocol {
    // MARK: - Properties
    public let folder: FolderProtocol
    public let ipa: FileProtocol
    
    // MARK: - Init
    init(folder: FolderProtocol, fileSystem: FileSystemProtocol) throws {
        self.folder = folder
        let ipa = folder.makeFileSequence(recursive: false, includeHidden: false).first  { $0.extension == "ipa" }
        
        guard let result = ipa else {
            throw Error.noIpaFound(inFolder: folder)
        }
        
        self.ipa = result
    }
    
    enum Error: Swift.Error {
        case noIpaFound(inFolder: FolderProtocol)
    }
}
