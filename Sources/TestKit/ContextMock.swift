import HighwayCore
import FileSystem
import Task
import Url

public class ContextMock: Context {
    public let executorMock = ExecutorMock()
    public let executableProviderMock = ExecutableProviderMock()
    
    public init() {
        let fs = InMemoryFileSystem()
        super.init(executableProvider: executableProviderMock, executor: executorMock, fileSystem: fs)
    }
}


