import Foundation
import ZFile
import Url
import SourceryAutoProtocols

/// Maps names command line tools/executables to file urls.
public protocol ExecutableProviderProtocol: AutoMockable {
    
    /// sourcery:inline:SystemExecutableProvider.AutoGenerateProtocol
    var searchedUrls: [FolderProtocol] { get set }
    var fileSystem: FileSystemProtocol { get }

    func executable(with executableName: String) throws -> FileProtocol
    /// sourcery:end
}

public final class SystemExecutableProvider: ExecutableProviderProtocol, AutoGenerateProtocol {
    // MARK: - Init
    public init(searchedUrls: [FolderProtocol], fileSystem: FileSystemProtocol) {
        self.searchedUrls = searchedUrls
        self.fileSystem = fileSystem
    }
    // MARK: - Convenience
    public init() throws {
        self.searchedUrls = try PathEnvironmentParser.local().urls
        self.fileSystem = FileSystem()
    }

    // MARK: - Properties
    public var searchedUrls = [FolderProtocol]()
    public let fileSystem: FileSystemProtocol
    
    // MARKL: - Error
    
    public enum Error: Swift.Error {
        case executableNotFoundFor(executableName: String)
    }
}

// MARK: - ExecutableProviderProtocol

extension SystemExecutableProvider  {
   
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
