import Foundation
import ZFile
import Result
import Terminal
import SourceryAutoProtocols

public final class LocalSystem: SystemProtocol, AutoGenerateProtocol {
    
    
    // MARK: - Properties
    private let executor: TaskExecutorProtocol
    private let executableProvider: ExecutableProviderProtocol
    private let fileSystem: FileSystemProtocol

    // MARK: - Init
    public init(executor: TaskExecutorProtocol, executableProvider: ExecutableProviderProtocol, fileSystem: FileSystemProtocol) {
        self.executor = executor
        self.executableProvider = executableProvider
        self.fileSystem = fileSystem
    }

    /// Local System
    public init(executableProvider: SystemExecutableProvider? = nil) throws {
        self.executor = SystemExecutor(ui: Terminal.shared)
        self.executableProvider = (executableProvider == nil) ? try SystemExecutableProvider() : executableProvider!
        self.fileSystem = FileSystem()
    }
}

extension LocalSystem {
    // MARK: - Working with the System
    public func task(named name: String) throws -> Task {
        
        return Task(executable: try executableProvider.executable(with: name))
    }

    public func execute(_ task: Task) throws -> Bool{
        return try launch(task, wait: true)
    }

    public func launch(_ task: Task, wait: Bool) throws -> Bool {
       
        try executor.launch(task: task, wait: wait)
        
        guard wait else { return true }

        let state = task.state
        switch state {
        case .waiting, .executing:
            throw ExecutionError.invalidStateAfterExecuting
        case .terminated(let termination):
            guard termination.isSuccess else {
                throw ExecutionError.taskDidExitWithFailure(termination)
            }
            return true
        }

    }
    
}
