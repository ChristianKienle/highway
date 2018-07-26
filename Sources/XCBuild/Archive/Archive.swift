import Foundation
import Url
import ZFile
import SourceryAutoProtocols


public protocol ArchiveProtocol: AutoMockable {
    
    /// sourcery:inline:Archive.AutoGenerateProtocol
    var archiveFolder: FolderProtocol { get }
    var appFolder: FolderProtocol { get }
    var plist: ArchivePlistProtocol { get }
    /// sourcery:end
    
}

public struct Archive: ArchiveProtocol, AutoGenerateProtocol {

    public let archiveFolder: FolderProtocol
    public let appFolder: FolderProtocol
    public let plist: ArchivePlistProtocol
    
    
    // MARK: - Init
    
    init(archiveFolder: FolderProtocol, fileSystem: FileSystemProtocol) throws {
        self.archiveFolder = archiveFolder
        
        let infoPlistData = try archiveFolder.file(named: "Info.plist").read()
        
        plist = try PropertyListDecoder().decode(ArchivePlist.self, from: infoPlistData)
    
        appFolder = try archiveFolder.subfolder(named: "Products")
    }
}
