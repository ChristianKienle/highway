import HighwayCore
import FileSystem
import Url
import Git

/// This class is doing a lot of things - probably too many things:
/// - Creates the highway home directory ($HOME/.highway)
/// - Checks if the highway working copy exists
///     If it does not exist it uses git to clone
///     the repo. 
public final class Bootstraper {
    // MARK: - Init
    public init(homeDirectory: Absolute, configuration: HomeBundle.Configuration, git: GitTool, fileSystem: FileSystem) {
        self.homeDirectory = homeDirectory
        self.configuration = configuration
        self.git = git
        self.fileSystem = fileSystem
    }
    
    // MARK: - Properties
    public let homeDirectory: Absolute
    public let configuration: HomeBundle.Configuration
    public let git: GitTool
    public let fileSystem: FileSystem
    
    public func requestHomeBundle() throws -> HomeBundle {
        if fileSystem.file(at: homeDirectory).isExistingFile == false {
            try fileSystem.createDirectory(at: homeDirectory)
        }
        let bundle = try HomeBundle(url: homeDirectory, fileSystem: fileSystem)
        if bundle.missingComponents().contains(.clone) {
            let localCloneUrl = bundle.localCloneUrl
            let remoteCloneUrl = configuration.remoteRepositoryUrl
            let options = Git.CloneOptions(remoteUrl: remoteCloneUrl, localPath: localCloneUrl, performMirror: false)
            try git.clone(with: options)
        }
        
        return bundle
    }
}
