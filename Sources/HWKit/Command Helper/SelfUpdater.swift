import Foundation
import HighwayCore
import FileSystem
import Task
import Arguments
import Git

/// Updates the highway executable and the highway home directory.
/// The highway home directory is located at ~/.highway. The bootstrap
/// script finds it automatically.
public final class SelfUpdater {
    public init(homeBundle: HomeBundle, git: GitTool, context: Context = .local()) {
        self.homeBundle = homeBundle
        self.context = context
        self.git = git
    }
    
    // MARK: - Properties
    public let homeBundle: HomeBundle
    public let context: Context
    public let git: GitTool
    
    public func update() throws {
        let tempUrl = try self.homeBundle.fileSystem.uniqueTemporaryDirectoryUrl()
        let cloneOptions = Git.CloneOptions(remoteUrl: homeBundle.localCloneUrl.path, localPath: tempUrl, performMirror: false)
        try git.clone(with: cloneOptions)
        let bootstrapScriptUrl = tempUrl.appending("scripts").appending("bootstrap.sh")
        let args = Arguments(["-c", "(/bin/sleep 2; \(bootstrapScriptUrl.path))&"])
        let bash = try Task(commandName: "bash", arguments: args, currentDirectoryUrl: tempUrl, provider: context.executableProvider)
        let sem = DispatchSemaphore(value: 0)
        DispatchQueue.global().asyncAfter(deadline: .now() + 5) {
            exit(EXIT_SUCCESS)
        }
        context.executor.execute(task: bash)
        sem.wait()
    }
}
