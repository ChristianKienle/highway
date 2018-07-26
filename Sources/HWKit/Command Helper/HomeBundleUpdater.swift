import HighwayCore
import Terminal
import ZFile
import Url
import Task
import Git

/// Updates the dependencies located in the highway home directory.
/// The home directory contains a mirrored working copy of the
/// highway repository. This copy is updated by this class.
/// The highway binary is not updated.
public final class HomeBundleUpdater {
    // MARK: - Init
    public init(homeBundle: HomeBundle, context: Context = .local(), git: GitTool) {
        self.homeBundle = homeBundle
        self.context = context
        self.git = git
    }
    
    // MARK: - Properties
    let homeBundle: HomeBundle
    let context: Context
    let git: GitTool
    
    // MARK: - Command
    public func update() throws {
        Terminal.shared.log("Updating highway\(String.elli)")

        func __currentTag(at url: FolderProtocol) throws -> String {
            return try git.currentTag(at: url)
        }
        
        let cloneUrl = homeBundle.localCloneUrl
        let currentTag = try __currentTag(at: cloneUrl)
        let bumpInfo: String
        let task = try Task(commandName: "git", arguments: ["fetch", "--quiet"], currentDirectoryUrl: homeBundle.localCloneUrl, provider: context.executableProvider)
        task.enableReadableOutputDataCapturing()
        
        try context.executor.execute(task: task)
        
        guard task.state.successfullyFinished else {
            let error = "Failed to update highway: \(task.state.debugDescription)"
            Terminal.shared.log(error)
            throw error
        }

        let newTag = try __currentTag(at: cloneUrl)
        if currentTag != newTag {
            bumpInfo = ": " + currentTag + " ➔ " + newTag
        } else {
            bumpInfo = ""
        }

        Terminal.shared.log("OK. \n" + bumpInfo)
    }
}

