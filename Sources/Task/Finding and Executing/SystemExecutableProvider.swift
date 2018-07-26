import Foundation
import ZFile
import Url

public final class SystemExecutableProvider {
    // MARK: - Init
    public init(searchedUrls: [Absolute], fileSystem: FileSystemProtocol) {
        self.searchedUrls = searchedUrls
        self.fileSystem = fileSystem
    }
    // MARK: - Convenience
    public static func local() -> SystemExecutableProvider {
        let urls = PathEnvironmentParser.local().urls
        let fs = FileSystem()
        return SystemExecutableProvider(searchedUrls: urls, fileSystem: fs)
    }

    // MARK: - Properties
    public var searchedUrls = [Absolute]()
    public let fileSystem: FileSystemProtocol
    
    // MARKL: - Error
    
    public enum Error: Swift.Error {
        case executableNotFoundFor(executableName: String)
    }
}

extension SystemExecutableProvider: ExecutableProvider {
   
    public func executable(with executableName: String) throws -> FileProtocol {
        for url in searchedUrls {
            let potentialUrl = Absolute(url.path).appending(executableName)
            do {
                let file = try File(path: potentialUrl.path)
                return file
            } catch {}
            
        }
        throw Error.executableNotFoundFor(executableName: executableName)
    }
    
}
