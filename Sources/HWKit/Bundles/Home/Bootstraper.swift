import HighwayCore
import FSKit

/// This class is doing a lot of things - probably too many things:
/// - Creates the highway home directory ($HOME/.highway)
/// - Checks if the highway working copy exists
///     If it does not exist it uses git to clone
///     the repo. 
public final class Bootstraper {
    // MARK: - Init
    public init(homeDirectory: AbsoluteUrl, configuration: HomeBundle.Configuration, git: Git.System, context: Context) {
        self.homeDirectory = homeDirectory
        self.configuration = configuration
        self.git = git
        self.context = context
    }
    
    // MARK: - Properties
    public let homeDirectory: AbsoluteUrl
    public let configuration: HomeBundle.Configuration
    public let git: Git.System
    public let context: Context
    
    public func requestHomeBundle() throws -> HomeBundle {
        let fs = context.fileSystem
        if fs.file(at: homeDirectory).isExistingFile == false {
            try fs.createDirectory(at: homeDirectory)
        }
        let bundle = try HomeBundle(url: homeDirectory, fileSystem: fs)
        if bundle.missingComponents().contains(.clone) {
            let localCloneUrl = bundle.localCloneUrl
            let remoteCloneUrl = configuration.remoteRepositoryUrl
            let options = Git.CloneOptions(remoteUrl: remoteCloneUrl, localPath: localCloneUrl, performMirror: false)
            try git.clone(with: options)
        }
        
        return bundle
    }
}
