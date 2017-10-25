import HighwayCore
import Terminal
import Url
import Git

/// Updates the dependencies located in the highway home directory.
/// The home directory contains a mirrored working copy of the
/// highway repository. This copy is updated by this class.
/// The highway binary is not updated.
public final class HomeBundleUpdater {
    // MARK: - Init
    public init(bundle: HomeBundle, git: GitTool, ui: UI) {
        self.bundle = bundle
        self.git = git
        self.ui = ui
    }
    
    // MARK: - Properties
    let bundle: HomeBundle
    let git: GitTool
    let ui: UI
    
    // MARK: - Command
    public func update() throws {
        ui.message("Updating highway\(String.elli)")

        func __currentTag(at url: Absolute) throws -> String {
            return try git.currentTag(at: url)
        }
        
        let cloneUrl = bundle.localCloneUrl
        let currentTag = try __currentTag(at: cloneUrl)
        
        do {
            try git.fetch(at: cloneUrl)
        } catch {
            let error = "Failed to update highway: \(error.localizedDescription)"
            ui.error(error)
            throw error
        }
        
        let bumpInfo: String
        let newTag = try __currentTag(at: cloneUrl)
        if currentTag != newTag {
            bumpInfo = ": " + currentTag + " ➔ " + newTag
        } else {
            bumpInfo = "current version: \(currentTag)"
        }

        ui.success("OK")
        ui.success(bumpInfo)
    }
}

