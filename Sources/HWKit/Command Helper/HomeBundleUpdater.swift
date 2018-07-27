import HighwayCore
import Terminal
import ZFile
import Url
import Task
import Git
import SourceryAutoProtocols

public protocol HomeBundleUpdaterProtocol: AutoMockable {
    
    /// sourcery:inline:HomeBundleUpdater.AutoGenerateProtocol
    var homeBundle: HomeBundleProtocol { get }
    var context: ContextProtocol { get }
    var git: GitToolProtocol { get }

    func update() throws 
    /// sourcery:end
}

/// Updates the dependencies located in the highway home directory.
/// The home directory contains a mirrored working copy of the
/// highway repository. This copy is updated by this class.
/// The highway binary is not updated.
public final class HomeBundleUpdater: AutoMockable, AutoGenerateProtocol {
    // MARK: - Init
    public init(homeBundle: HomeBundle, context: ContextProtocol? = nil, git: GitTool) throws {
        self.homeBundle = homeBundle
        self.context = (context == nil) ? try Context() : context!
        self.git = git
    }
    
    // MARK: - Properties
    let homeBundle: HomeBundleProtocol
    let context: ContextProtocol
    let git: GitToolProtocol
    
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

