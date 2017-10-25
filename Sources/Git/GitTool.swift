import FileSystem
import Url
import Task
import Arguments

public final class _GitTool {
    // MARK: - Init
    public init(system: System) {
        self.system = system
    }
    
    // MARK: - Properties
    private let system: System
    
    // MARK: - Helper
    private func _git(with arguments: Arguments, at url: Absolute) throws -> Task {
        let task = try system.task(named: "git").dematerialize()
        task.arguments = arguments
        task.currentDirectoryUrl = url
        return task
    }
}

private extension System {
    func executeAndThrowOnFailure(_ task: Task) throws {
        try execute(task).dematerialize()
    }
}

extension _GitTool: GitTool {
    public func fetch(at url: Absolute) throws {
        try system.executeAndThrowOnFailure(try _git(with: ["fetch", "--quiet"], at: url))
    }
    
    public func addAll(at url: Absolute) throws {
        try system.executeAndThrowOnFailure(try _git(with: ["add", "."], at: url))
    }
    
    public func commit(at url: Absolute, message: String) throws {
        try system.executeAndThrowOnFailure(try _git(with: ["commit", "-m", message], at: url))
    }
    
    public func pushToMaster(at url: Absolute) throws {
        try system.executeAndThrowOnFailure(try _git(with: ["push", "origin", "master"], at: url))
    }
    
    public func pushTagsToMaster(at url: Absolute) throws {
        try system.executeAndThrowOnFailure(try _git(with: ["push", "--tags"], at: url))
    }
    
    public func pull(at url: Absolute) throws {
        try system.executeAndThrowOnFailure(try _git(with: ["pull"], at: url))
    }
    
    public func currentTag(at url: Absolute) throws -> String {
        let task = try _git(with: ["describe", "--tags"], at: url)
        task.enableReadableOutputDataCapturing()
        try system.execute(task).dematerialize()
        
        guard let rawTag = task.trimmedOutput else {
            throw "Failed to get current tag."
        }
        guard rawTag.isEmpty == false else {
            throw "Failed to get current tag."
        }
        guard  rawTag.hasPrefix("v") else {
            throw "'\(rawTag)' is not a valid version number: Must start with 'v'."
        }
        let numberOfDots = rawTag.reduce(0) { (result, char) -> Int in
            return char == "." ? result + 1 : result
        }
        guard numberOfDots == 2 else {
            throw "'\(rawTag)' is not a valid version number: Must contain two '.'."
        }
        return rawTag
    }
    
    public func clone(with options: CloneOptions) throws {
        let arguments = Arguments(["clone"] + (options.performMirror ? ["--mirror"] : []) + [options.remoteUrl, options.localPath.path])
        try system.executeAndThrowOnFailure(try _git(with: arguments, at: .root))
    }
}

