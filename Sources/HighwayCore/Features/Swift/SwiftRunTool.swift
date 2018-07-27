import Foundation
import ZFile
import Url
import Task
import Arguments
import POSIX

public enum SwiftRun { }

public extension SwiftRun {
    public final class Tool {
        public let context: Context
        public init(context: Context = .local()) {
            self.context = context
        }
        public func run(with options: Options) throws -> Result {
            let arguments = options.taskArguments
            
            let task = try Task(commandName: "swift", arguments: arguments, provider: context.executableProvider)
            task.currentDirectoryUrl = options.currentWorkingDirectory
            task.enableReadableOutputDataCapturing()
            
            try context.executor.execute(task: task)
            
            try task.throwIfNotSuccess("🛣🔥 \(SwiftRun.Tool.self) failed running task\n\(task).")
            let output = task.capturedOutputString
            return Result(output: output ?? "")
        }
    }
}

public extension SwiftRun {
    public struct Result {
        public let output: String
    }
    public struct Options {
        public var executable: String? = nil // swift run $executable
        public var arguments: Arguments = .empty
        public var packageUrl: FolderProtocol? = nil // --package-path
        public var currentWorkingDirectory: FolderProtocol = FileSystem().currentFolder
        public init() {}
        var taskArguments: Arguments {
            var result = Arguments()
            result.append("run")
            if let packageUrl = packageUrl {
                result.append("--package-path")
                result.append(packageUrl.path)
            }
            if let executable = executable {
                result.append(executable)
            }
            result += arguments
            return result
        }
    }
}
