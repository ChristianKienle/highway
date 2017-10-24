import HighwayCore
import Task
import Terminal
public typealias TaskExecution = ((_ task: Task) -> (Void))
public typealias SingleExecutionHandler = ((Task) -> (Void))

/// Mocked Executor
public final class ExecutorMock {
    public var ui: UI = MockUI()

    // MARK: Types
    
    //  MARK: Properties
    public var executions: TaskExecution
    private var executableTasks = [ExecutableTask]()
    
    //  MARK: Creating
    public init(executions: @escaping TaskExecution = { _ in }) {
        self.executions = executions
    }
    
    // MARK: Mocking Logic
    public func mockExecution(of task: Task, _ block: @escaping SingleExecutionHandler) {
        executableTasks.append(ExecutableTask(task: task, actions: block))
    }
    
    private func _executableTask(`for` task: Task) -> ExecutableTask? {
        return executableTasks.first { $0.task === task }
    }
}

private struct ExecutableTask {
    let task: Task
    let actions: SingleExecutionHandler
}

extension ExecutorMock: TaskExecutor {
    public func launch(task: Task, wait: Bool) {
        guard let executableTask = _executableTask(for: task) else {
            executions(task)
            return
        }
        executableTask.actions(executableTask.task)
    }
    
    public func execute(task: Task) {
        launch(task: task, wait: true)
    }
}

