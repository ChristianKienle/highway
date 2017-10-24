import Foundation
import Task
import Result

public final class MockSystem {
    // MARK: - Init
    public init() { }

    // MARK: - Mock Creations of Tasks
    public typealias TaskResult = Result<Task, TaskCreationError>
    public typealias CreationHandler = (String) -> TaskResult

    public func mockCreationOfTask(named task: String, with handler: @escaping CreationHandler) {
        creationsByName[task] = Creation(of: task, handler)
    }

    private var creationsByName = [String: Creation]()
    
    public var unknownTaskFallback: CreationHandler = { taskName in
        Result.failure(TaskCreationError.executableNotFound(commandName: taskName))
    }
    
    public typealias ExecutionResult = Result<Void, ExecutionError>
    private var executions = [Execution]()
    public typealias ExecutionHandler = (Task) -> (ExecutionResult)
    public func mockExecution(of task: Task, _ block: @escaping ExecutionHandler) {
        executions.append(Execution(task: task, executionHandler: block))
    }
    
    public typealias ExecutionFallback = (Task) -> ExecutionResult
    
    public var unhandledExecutionFallback: ExecutionFallback = { task in
        return .failure(.taskDidExitWithFailure(.failure))
    }
}

private struct Execution {
    let task: Task
    let executionHandler: MockSystem.ExecutionHandler
}

private struct Creation {
    init(of task: String, _ handler: @escaping MockSystem.CreationHandler) {
        self.taskName = task
        self.creationHandler = handler
    }
    let taskName: String
    let creationHandler: MockSystem.CreationHandler
}

extension MockSystem: System {
    public func launch(_ task: Task, wait: Bool) -> Result<Void, ExecutionError> {
        guard let execution = (executions.first { $0.task === task }) else {
            return unhandledExecutionFallback(task)
        }
        return execution.executionHandler(task)
    }
    
    public func task(named name: String) -> Result<Task, TaskCreationError> {
        let handler = creationsByName[name]?.creationHandler ?? unknownTaskFallback
        let result = handler(name)
        creationsByName.removeValue(forKey: name)
        return result
    }
    
    public func execute(_ task: Task) -> Result<Void, ExecutionError> {
        return launch(task, wait: true)
    }
}
