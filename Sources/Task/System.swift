import Foundation
import Result

/// A `System` is able to do two things:
/// 1. Create new *executable* Tasks. A System can do that because it
///    is initialized with an executable provider.
/// 2. Execute Tasks. It can do that because it has an executor.
/// Everytime you would write a class that needs to create and execute Tasks
/// you no longer have to initialize it with both but rather use the System
/// class for that. It is just a little bit of convenience.
public protocol System {
    func task(named name: String) -> Result<Task, TaskCreationError>
    func execute(_ task: Task) -> Result<Void, ExecutionError>
    func launch(_ task: Task, wait: Bool) -> Result<Void, ExecutionError>
}

public extension System {
    func execute(_ task: Task) -> Result<Void, ExecutionError> {
        return launch(task, wait: true)
    }
}

// MARK: - Errors
public enum TaskCreationError: Swift.Error {
    case executableNotFound(commandName: String)
}

public enum ExecutionError: Swift.Error {
    case currentDirectoryDoesNotExist
    case invalidStateAfterExecuting
    case taskDidExitWithFailure(Termination)
}

// MARK: - Equatable for ExecutionError
extension ExecutionError: Equatable {
    public static func ==(lhs: ExecutionError, rhs: ExecutionError) -> Bool {
        let errors = (lhs, rhs)
        switch errors {
        case (.currentDirectoryDoesNotExist, .currentDirectoryDoesNotExist),
             (.invalidStateAfterExecuting, .invalidStateAfterExecuting):
            return true
        case (.taskDidExitWithFailure(let lf), .taskDidExitWithFailure(let rf)):
            return lf == rf
        default: return false
        }
    }
}
