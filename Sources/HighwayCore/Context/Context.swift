import Foundation
import ZFile
import Task
import Terminal

open class Context {
    // MARK: - Convenience
    public class func local() -> Context {
        let fileSystem = FileSystem()
        let provider = SystemExecutableProvider.local()
        let executor = SystemExecutor(ui: Terminal.shared)
        return Context(executableProvider: provider, executor: executor, fileSystem: fileSystem)
    }
    
    // MARK: - Init
    public init(executableProvider: ExecutableProvider, executor: TaskExecutorProtocol, fileSystem: FileSystemProtocol) {
        self.executableProvider = executableProvider
        self.executor = executor
        self.fileSystem = fileSystem
    }
    
    // MARK: - Properties
    public let fileSystem: FileSystemProtocol
    public let executableProvider: ExecutableProvider
    public private(set) var executor: TaskExecutorProtocol
}
