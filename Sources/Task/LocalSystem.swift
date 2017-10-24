import Foundation
import FileSystem
import Result
import Terminal

public final class LocalSystem {
    // MARK: - Properties
    private let executor: TaskExecutor
    var executableProvider: ExecutableProvider
    private let fileSystem: FileSystem
    
    // MARK: - Init
    public init(executor: TaskExecutor, executableProvider: ExecutableProvider, fileSystem: FileSystem) {
        self.executor = executor
        self.executableProvider = executableProvider
        self.fileSystem = fileSystem
    }
    
    /// Local System
    public class func local() -> LocalSystem {
        return LocalSystem(executor: SystemExecutor(ui: Terminal.shared),
                           executableProvider: SystemExecutableProvider.local(),
                           fileSystem: LocalFileSystem())
    }
}

extension LocalSystem: System {
    // MARK: - Working with the System
    public func task(named name: String) -> Result<Task, TaskCreationError> {
        guard let url = executableProvider.urlForExecuable(name) else {
            return .failure(.executableNotFound(commandName: name))
        }
        return .success(Task(executableUrl: url))
    }
    
    public func execute(_ task: Task) -> Result<Void, ExecutionError> {
        return launch(task, wait: true)
    }
    
    public func launch(_ task: Task, wait: Bool) -> Result<Void, ExecutionError> {
        guard task.currentDirectoryExistsIfSet(in: fileSystem) else {
            return .failure(.currentDirectoryDoesNotExist)
        }
        executor.launch(task: task, wait: wait)
        guard wait else { return .success(()) }
        
        let state = task.state
        switch state {
        case .waiting, .executing:
            return .failure(.invalidStateAfterExecuting)
        case .terminated(let termination):
            guard termination.isSuccess else {
                return .failure(.taskDidExitWithFailure(termination))
            }
            return .success(())
        }

    }
}

private extension Task {
    func currentDirectoryExistsIfSet(`in` fileSystem: FileSystem) -> Bool {
        guard let currentDirectoryUrl = currentDirectoryUrl else {
            return true
        }
        return fileSystem.directory(at: currentDirectoryUrl).isExistingDirectory
    }
}
