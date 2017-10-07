import Foundation
import FileSystem
import Task
import Terminal

open class Context {
    // MARK: - Convenience
    public class func local() -> Context {
        let fileSystem = LocalFileSystem()
        let provider = SystemExecutableProvider.local()
        let executor = SystemExecutor(ui: Terminal.shared)
        return Context(executableProvider: provider, executor: executor, fileSystem: fileSystem)
    }
    
    // MARK: - Init
    public init(executableProvider: ExecutableProvider, executor: TaskExecutor, fileSystem: FileSystem) {
        self.executableProvider = executableProvider
        self.executor = executor
        self.fileSystem = fileSystem
    }
    
    // MARK: - Properties
    public let fileSystem: FileSystem
    public let executableProvider: ExecutableProvider
    public private(set) var executor: TaskExecutor
}
