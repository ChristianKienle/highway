import HighwayCore
import FSKit

public class ContextMock: Context {
    public let executorMock = ExecutorMock()
    public init() {
        let fs = InMemoryFileSystem()
        let finder = ExecutableFinder(searchURLs: [], fileSystem: fs)
        super.init(executableFinder: finder, executor: executorMock)
    }
}
