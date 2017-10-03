import HighwayCore
import Terminal
import FSKit

/// Updates the dependencies located in the highway home directory.
/// The home directory contains a mirrored working copy of the
/// highway repository. This copy is updated by this class.
/// The highway binary is not updated.
public final class HomeBundleUpdater {
    // MARK: - Init
    public init(homeBundle: HomeBundle, context: Context = .local()) {
        self.homeBundle = homeBundle
        self.context = context
    }
    
    // MARK: - Properties
    let homeBundle: HomeBundle
    let context: Context
        
    // MARK: - Command
    public func update() throws {
        Terminal.shared.log("Updating highway\(String.elli)")

        func __currentTag(at url: AbsoluteUrl) throws -> String {
            let git = try GitTool(context: self.context)
            return try git.currentTag(at: url)
        }
        
        let cloneUrl = homeBundle.localCloneUrl
        let currentTag = try __currentTag(at: cloneUrl)
        let bumpInfo: String
        let task = try Task(commandName: "git", arguments: ["fetch", "--quiet"], currentDirectoryURL: homeBundle.localCloneUrl, executableFinder: context.executableFinder)
        task.output = .pipeChannel()
        task.enableReadableOutputDataCapturing()
        context.executor.execute(task: task)
        
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

