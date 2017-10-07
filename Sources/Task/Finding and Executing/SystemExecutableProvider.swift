import Foundation
import FileSystem
import Url

public final class SystemExecutableProvider {
    // MARK: - Init
    public init(searchedUrls: [Absolute], fileSystem: FileSystem) {
        self.searchedUrls = searchedUrls
        self.fileSystem = fileSystem
    }
    // MARK: - Convenience
    public static func local() -> SystemExecutableProvider {
        let urls = PathEnvironmentParser.local().urls
        let fs = LocalFileSystem()
        return SystemExecutableProvider(searchedUrls: urls, fileSystem: fs)
    }
    
    // MARK: - Properties
    public var searchedUrls = [Absolute]()
    public let fileSystem: FileSystem
}

extension SystemExecutableProvider: ExecutableProvider {
    public func urlForExecuable(_ executableName: String) -> Absolute? {
        for url in searchedUrls {
            let potentialUrl = Absolute(url.path).appending(executableName)
            let executableFound = fileSystem.file(at: potentialUrl).isExistingFile
            guard executableFound else { continue }
            return Absolute(potentialUrl.path)
        }
        return nil
    }
}
