import HighwayCore
import FSKit

public final class HomeBundleCreator {
    // MARK: - Init
    public init(homeDirectory: AbsoluteUrl, configuration: HomeBundle.Configuration, context: Context) {
        self.homeDirectory = homeDirectory
        self.configuration = configuration
        self.context = context
    }
    
    // MARK: - Properties
    public let homeDirectory: AbsoluteUrl
    public let configuration: HomeBundle.Configuration
    public let context: Context
    
    public func requestHomeBundle() throws -> HomeBundle {
        let fs = context.fileSystem
        if fs.file(at: homeDirectory).isExistingFile == false {
            try fs.createDirectory(at: homeDirectory)
        }
        let bundle = try HomeBundle(url: homeDirectory, fileSystem: fs)
        if bundle.missingComponents().contains(.clone) {
            let git = try GitTool(context: context)
            let localCloneUrl = bundle.localCloneUrl
            let remoteCloneUrl = configuration.remoteRepositoryUrl
            let options = GitTool.CloneOptions(remoteUrl: remoteCloneUrl, localPath: localCloneUrl, performMirror: false)
            let plan = try git.cloneExecutionPlan(with: options)
            try git.execute(cloneExecutionPlan: plan)
        }
        
        return bundle
    }
}
