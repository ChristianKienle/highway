import FileSystem
import Url
import Task
import Arguments

public final class GitTool {
    // MARK: - Init
    public init(context: Context = .local()) throws {
        guard context.containsExecutableFor(command: "git") else {
            throw "git not found."
        }
        self.context = context
    }
    // MARK: - Properties
    private let context: Context
    
    // MARK: - Helper
    private func _git(with arguments: Arguments, at url: Absolute) throws -> Task {
        let task = try Task(commandName: "git", provider: context.executableProvider)
        task.arguments = arguments
        task.currentDirectoryUrl = url
        return task
    }
}

extension GitTool: Git.System {
    public func addAll(at url: Absolute) throws {
        let task = try _git(with: ["add", "."], at: url)
        context.executor.execute(task: task)
        try task.throwIfNotSuccess()
    }
    
    public func commit(at url: Absolute, message: String) throws {
        let task = try _git(with: ["commit", "-m", message], at: url)
        context.executor.execute(task: task)
        try task.throwIfNotSuccess()
    }
    
    public func pushToMaster(at url: Absolute) throws {
        let task = try _git(with: ["push", "origin", "master"], at: url)
        context.executor.execute(task: task)
        try task.throwIfNotSuccess()
    }
    
    public func pushTagsToMaster(at url: Absolute) throws {
        let task = try _git(with: ["push", "--tags"], at: url)
        context.executor.execute(task: task)
        try task.throwIfNotSuccess()
    }
    
    public func currentTag(at url: Absolute) throws -> String {
        let task = try _git(with: ["describe", "--tags"], at: url)
        task.enableReadableOutputDataCapturing()
        context.executor.execute(task: task)
        try task.throwIfNotSuccess()
        
        guard let rawTag = task.capturedOutputString?.trimmingCharacters(in: .whitespacesAndNewlines) else {
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
    
    public func clone(with options: Git.CloneOptions) throws {
        let arguments = Arguments(["clone"] + (options.performMirror ? ["--mirror"] : []) + [options.remoteUrl, options.localPath.path])
        let task = try Task(commandName: "git", provider: context.executableProvider)
        task.currentDirectoryUrl = .root
        task.arguments = arguments
        context.executor.execute(task: task)
        try task.throwIfNotSuccess()
    }
}

fileprivate extension Task {
    static func git(currentDirectoryUrl: Absolute, provider: ExecutableProvider) throws -> Task {
        let task = try Task(commandName: "git", provider: provider)
        task.currentDirectoryUrl = currentDirectoryUrl
        return task
    }
}
