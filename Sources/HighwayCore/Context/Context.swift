import Foundation
import ZFile
import Task
import Terminal
import SourceryAutoProtocols


public protocol ContextProtocol: AutoMockable {
    
    /// sourcery:inline:Context.AutoGenerateProtocol
    var fileSystem: FileSystemProtocol { get }
    var executableProvider: ExecutableProviderProtocol { get }
    var executor: TaskExecutorProtocol { get }
    
    /// sourcery:end
}


open class Context: ContextProtocol, AutoGenerateProtocol {
    // MARK: - Convenience
    public init() throws {
        self.fileSystem = FileSystem()
        self.executableProvider = try SystemExecutableProvider()
        self.executor = SystemExecutor(ui: Terminal.shared)
    }
    
    // MARK: - Init
    public init(executableProvider: ExecutableProviderProtocol, executor: TaskExecutorProtocol, fileSystem: FileSystemProtocol) {
        self.executableProvider = executableProvider
        self.executor = executor
        self.fileSystem = fileSystem
    }
    
    // MARK: - Properties
    public let fileSystem: FileSystemProtocol
    public let executableProvider: ExecutableProviderProtocol
    
    public private(set) var executor: TaskExecutorProtocol
}
