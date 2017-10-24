import Foundation
import Task
import Result
import FileSystem

public final class MockLocalSystem: System {
    public func launch(_ task: Task, wait: Bool) -> Result<Void, ExecutionError> {
        return local.launch(task, wait: true)
    }

    public func execute(_ task: Task) -> Result<Void, ExecutionError> {
        return local.execute(task)
    }
    
    public func task(named name: String) -> Result<Task, TaskCreationError> {
        return local.task(named: name)
    }
    
    public init() {
        providerMock = ExecutableProviderMock()
        executorMock = ExecutorMock()
        fsMock = InMemoryFileSystem()
        local = LocalSystem(executor: executorMock, executableProvider: providerMock, fileSystem: fsMock)
    }
    public let providerMock:ExecutableProviderMock
    public let executorMock: ExecutorMock
    public let fsMock: InMemoryFileSystem
    private let local: LocalSystem
}
