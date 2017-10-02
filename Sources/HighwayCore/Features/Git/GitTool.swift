import FSKit

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
    private func _git(with arguments: [String], at url: AbsoluteUrl) throws -> Task {
        return try Task(commandName: "git", arguments: arguments, currentDirectoryURL: url, executableFinder: context.executableFinder)
    }
    
    // MARK: - Working with the Tool
    func taskThatAddsEverything(at url: AbsoluteUrl) throws -> Task {
        return try _git(with: ["add", "."], at: url)
    }
    
    public func addEverything(at url: AbsoluteUrl) throws {
        let task = try taskThatAddsEverything(at: url)
        context.executor.execute(task: task)
        guard task.state.successfullyFinished else {
            throw "git add failed."
        }
    }
    
    func taskThatCommits(with message: String, at url: AbsoluteUrl) throws -> Task {
        return try _git(with: ["commit", "-m", message], at: url)
    }
    
    public func commit(with message: String, at url: AbsoluteUrl) throws {
        let task = try taskThatCommits(with: message, at: url)
        context.executor.execute(task: task)
        guard task.state.successfullyFinished else {
            throw "git commit failed."
        }
    }
    
    public func push(at url: AbsoluteUrl) throws {
        let task = try _git(with: ["push", "origin", "master"], at: url)
        context.executor.execute(task: task)
        guard task.state.successfullyFinished else {
            throw "git push failed."
        }
    }
    
    public func pushTags(at url: AbsoluteUrl) throws {
        let task = try _git(with: ["push", "--tags"], at: url)
        context.executor.execute(task: task)
        guard task.state.successfullyFinished else {
            throw "git push --tags failed."
        }
    }
    
    public func currentTagOfRepository(at url: AbsoluteUrl) throws -> String {
        let task = try _git(with: ["describe", "--tags"], at: url)
        task.output = .pipeChannel()
        task.enableReadableOutputDataCapturing()
        context.executor.execute(task: task)
        guard task.state.successfullyFinished else {
            throw "Failed to get current tag."
        }
        guard let outputData = task.readOutputData else {
            throw "Failed to get current tag."
        }
        guard let rawTag = String(data: outputData, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines) else {
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
    
    public func cloneExecutionPlan(with options: CloneOptions) throws -> CloneExecutionPlan {
        let arguments: [String] = ["clone"] + (options.performMirror ? ["--mirror"] : []) + [options.remoteUrl, options.localPath.path]
        let task = try Task(commandName: "git", arguments: arguments, currentDirectoryURL: .root, executableFinder: context.executableFinder)
        let plan = CloneExecutionPlan(options: options, task: task)
        return plan
    }
    
    public func execute(cloneExecutionPlan plan: CloneExecutionPlan) throws {
        context.executor.execute(task: plan.task)
        guard plan.task.state.successfullyFinished else {
            let options = plan.options
            throw "Failed to clone repository at \(options.remoteUrl) to \(options.localPath). git returned a non 0 exit code."
        }
    }
    
}

fileprivate extension Task {
    static func git(currentDirectoryURL: AbsoluteUrl, executableFinder: ExecutableFinder) throws -> Task {
        return try Task(commandName: "git", currentDirectoryURL: currentDirectoryURL, executableFinder: executableFinder)
    }
}

public extension GitTool {
    public struct CloneOptions {
        public let remoteUrl: String
        public let localPath: AbsoluteUrl
        public let performMirror: Bool
        public init(remoteUrl: String, localPath: AbsoluteUrl, performMirror: Bool = false) {
            self.remoteUrl = remoteUrl
            self.localPath = localPath
            self.performMirror = performMirror
        }
    }
}

public extension GitTool {
    public final class CloneExecutionPlan {
        public let options: CloneOptions
        public let task: Task
        public init(options: CloneOptions, task: Task) {
            self.options = options
            self.task = task
        }
    }
}
