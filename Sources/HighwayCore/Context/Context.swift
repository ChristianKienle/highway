import Foundation
import FSKit

open class Context {
    // MARK: - Convenience
    public class func local() -> Context {
        let searchUrls = PathEnvironmentValueParser.local().searchFileURLs
        let fileSystem = LocalFileSystem()
        let executableFinder = ExecutableFinder(searchURLs: searchUrls, fileSystem: fileSystem)
        let executor = SystemExecutor()
        return Context(currentWorkingUrl: getabscwd(), executableFinder: executableFinder, executor: executor)
    }
    
    // MARK: - Init
    public init(currentWorkingUrl: AbsoluteUrl, executableFinder: ExecutableFinder, executor: TaskExecutor) {
        self.currentWorkingUrl = currentWorkingUrl
        self.executableFinder = executableFinder
        self.executor = executor
    }
    
    // MARK: - Properties
    public var fileSystem: FileSystem { return executableFinder.fileSystem }
    public let executableFinder: ExecutableFinder
    public var currentWorkingUrl: AbsoluteUrl
    public private(set) var executor: TaskExecutor
}


