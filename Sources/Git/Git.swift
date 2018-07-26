import Foundation
import ZFile
import Url
import SourceryAutoProtocols

/// Git namespace

public protocol GitToolProtocol: AutoMockable {
    
    /// sourcery:inline:GitTool.AutoGenerateProtocol

    func addAll(at url: FolderProtocol) throws 
    func commit(at url: FolderProtocol, message: String) throws 
    func pushToMaster(at url: FolderProtocol) throws 
    func pushTagsToMaster(at url: FolderProtocol) throws 
    func pull(at url: FolderProtocol) throws 
    func currentTag(at url: FolderProtocol) throws -> String
    func clone(with options: CloneOptions) throws 
    /// sourcery:end
}

public struct CloneOptions: AutoMockable {
    // MARK: - Properties
    public let remoteUrl: String
    public let localPath: FolderProtocol
    public let performMirror: Bool
    
    // MARK: - Init
    public init(remoteUrl: String, localPath: FolderProtocol, performMirror: Bool = false) {
        self.remoteUrl = remoteUrl
        self.localPath = localPath
        self.performMirror = performMirror
    }
}

