import ZFile
import Url
import Task
import Arguments
import SourceryAutoProtocols

public struct GitTool: AutoGenerateProtocol {
    // MARK: - Init
    public init(system: SystemProtocol) {
        self.system = system
    }
    
    // MARK: - Properties
    private let system: SystemProtocol
    
    // MARK: - Helper
    private func _git(with arguments: Arguments, at url: FolderProtocol) throws -> Task {
        let task = try system.task(named: "git")
        task.arguments = arguments
        task.currentDirectoryUrl = url
        return task
    }
}

extension GitTool: GitToolProtocol {
    public func addAll(at url: FolderProtocol) throws {
        try system.execute(try _git(with: ["add", "."], at: url))
    }
    
    public func commit(at url: FolderProtocol, message: String) throws {
        try system.execute(try _git(with: ["commit", "-m", message], at: url))
    }
    
    public func pushToMaster(at url: FolderProtocol) throws {
        try system.execute(try _git(with: ["push", "origin", "master"], at: url))
    }
    
    public func pushTagsToMaster(at url: FolderProtocol) throws {
        try system.execute(try _git(with: ["push", "--tags"], at: url))
    }
    
    public func pull(at url: FolderProtocol) throws {
        try system.execute(try _git(with: ["pull"], at: url))
    }
    
    public func currentTag(at url: FolderProtocol) throws -> String {
        let task = try _git(with: ["describe", "--tags"], at: url)
        task.enableReadableOutputDataCapturing()
        try system.execute(task)
        
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
        let input: [String] = ["clone"] + (options.performMirror ? ["--mirror"] : []) + [options.remoteUrl, options.localPath.path]
        let arguments = Arguments(input)
        try system.execute(try _git(with: arguments, at: try Folder(path: "/")))
    }
}

