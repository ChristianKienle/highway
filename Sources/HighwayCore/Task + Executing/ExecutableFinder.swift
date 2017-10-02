import Foundation
import FSKit

public final class ExecutableFinder {
    // MARK: - Init
    public init(searchURLs: [AbsoluteUrl], fileSystem: FileSystem) {
        self.searchURLs = searchURLs
        self.fileSystem = fileSystem
    }

    // MARK: - Properties
    public var searchURLs: [AbsoluteUrl]
    public let fileSystem: FileSystem
    
    // MARK: - Finding
    public func urlForExecuable(named name: String) -> AbsoluteUrl? {
        for searchURL in searchURLs {
            if let result = _urlForExecuable(named: name, searchURL: searchURL) {
                return result
            }
        }
        return nil
    }
    
    private func _urlForExecuable(named name: String, searchURL: AbsoluteUrl) -> AbsoluteUrl? {
        let executableURL = AbsoluteUrl(path: name, relativeTo: searchURL)
        let found = fileSystem.file(at: executableURL).isExistingFile
        return found ? executableURL : nil
    }
}

public struct PathEnvironmentValueParser {
    public static func local() -> PathEnvironmentValueParser {
        let env = ProcessInfo.processInfo.environment
        let path = env["PATH"] ?? ""
        return self.init(pathEnvironmentValue: path, currentWorkingDirectory: getabscwd())
    }
    public init(pathEnvironmentValue: String, currentWorkingDirectory: AbsoluteUrl) {
        let paths = pathEnvironmentValue.components(separatedBy: ":")
        self.searchFileURLs = paths.flatMap { path in
            guard path != "" else { return nil }
            guard path != "." else { return currentWorkingDirectory }
            
            let isRelative = path.hasPrefix("/") == false
            guard isRelative else { return AbsoluteUrl(path) }
            return AbsoluteUrl(path: path, relativeTo: currentWorkingDirectory)
        }
        self.currentWorkingDirectory = currentWorkingDirectory
    }
    public let currentWorkingDirectory: AbsoluteUrl
    public var searchFileURLs: [AbsoluteUrl]
}
