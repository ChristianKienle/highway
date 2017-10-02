import Foundation

public final class Fastlane {
    // MARK: - Properties
    public let context: Context

    // MARK: - Init
    public init(context: Context = .local()) {
        self.context = context
    }
    
    // MARK: - Executing Actions
    public func action(named action: String, additionalArguments: [String] = []) throws {
        let arguments = [action] + additionalArguments
        let currentDirectory = context.currentWorkingUrl
        let task = try Task(commandName: "fastlane", arguments: arguments, currentDirectoryURL: currentDirectory, executableFinder: context.executableFinder)
        context.executor.execute(task: task)
        guard task.state.successfullyFinished else {
            throw "fastlane failed."
        }
    }
    
    // MARK: Executing Actions - Convenience
    public func gym(_ args: String...) throws {
        try action(named: "gym", additionalArguments: args)
    }
    
    public func scan(_ args: String...) throws {
        try action(named: "scan", additionalArguments: args)
    }
}
