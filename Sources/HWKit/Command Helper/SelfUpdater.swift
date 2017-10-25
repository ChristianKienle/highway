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
    public init(homeBundle: HomeBundle, git: GitTool, system: System = LocalSystem.local()) {
        self.homeBundle = homeBundle
        self.system = system
        self.git = git
    }
    
    // MARK: - Properties
    public let homeBundle: HomeBundle
    public let system: System
    public let git: GitTool
    
    public func update() throws {
        // Update the local highway working copy
        try git.pull(at: homeBundle.localCloneUrl)
        
        // Then get a temp. copy of highway...
        let tempUrl = try self.homeBundle.fileSystem.uniqueTemporaryDirectoryUrl()
        let cloneOptions = Git.CloneOptions(remoteUrl: homeBundle.localCloneUrl.path, localPath: tempUrl, performMirror: false)
        try git.clone(with: cloneOptions)
        
        // ... and execute the bootstrap script
        let bootstrapScriptUrl = tempUrl.appending("scripts").appending("bootstrap.sh")
        let args = Arguments(["-c", "(/bin/sleep 2; \(bootstrapScriptUrl.path))&"])
        let bash = try system.task(named: "bash").dematerialize()
        bash.arguments = args
        bash.currentDirectoryUrl = tempUrl
        let sem = DispatchSemaphore(value: 0)
        DispatchQueue.global().asyncAfter(deadline: .now() + 5) {
            exit(EXIT_SUCCESS)
        }
        try system.execute(bash).dematerialize()
        sem.wait()
    }
}
