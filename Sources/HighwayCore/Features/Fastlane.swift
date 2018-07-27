import Foundation
import ZFile
import Url
import Task
import Arguments
import POSIX

public final class Fastlane {
    // MARK: - Properties
    public let context: Context

    // MARK: - Init
    public init(context: Context) {
        self.context = context
    }
    
    // MARK: - Executing Actions
    public func action(named action: String,
                       additionalArguments: Arguments = .empty,
                       currentDirectoryUrl cwd: FolderProtocol = FileSystem().currentFolder
    ) throws {
        let arguments = Arguments(action) + additionalArguments
        let task = try Task(commandName: "fastlane", arguments: arguments, currentDirectoryUrl: cwd, provider: context.executableProvider)
        try context.executor.execute(task: task)
        
        guard task.state.successfullyFinished else {
            throw "fastlane failed."
        }
    }
    
    // MARK: Executing Actions - Convenience
    public func gym(_ args: String...) throws {
        try action(named: "gym", additionalArguments: Arguments(args))
    }
    
    public func scan(_ args: String...) throws {
        try action(named: "scan", additionalArguments: Arguments(args))
    }
}
