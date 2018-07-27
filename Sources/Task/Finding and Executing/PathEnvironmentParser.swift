import Foundation
import ZFile
import POSIX
import Url

/// Parser that extracts urls from a String-Array of paths.
/// Usually used to parse the contents of the PATH-environment
/// variable. Any component (PATH=comp1:comp2:...) equal to "."
/// is subsituted by $cwd. Furthermore: Any component which only
/// contains a "." is used as an input to Absolute.init:. (which
/// standardizes the path).
public struct PathEnvironmentParser {
    // MARK: - Convenience
    public static func local() throws -> PathEnvironmentParser {
        let env = ProcessInfo.processInfo.environment
        let path = env["PATH"] ?? ""
        return try self.init(value: path, currentDirectoryUrl: FileSystem().currentFolder)
    }
    
    // MARK: - Init
    public init(value: String, currentDirectoryUrl: FolderProtocol) throws {
        let paths = value.components(separatedBy: ":")
        self.urls = try paths.compactMap { path in
            guard path != "" else { return nil }
            guard path != "." else { return currentDirectoryUrl }
            
            let isRelative = path.hasPrefix("/") == false
            guard isRelative else { return try Folder(path: path) }
            return try currentDirectoryUrl.subfolder(atPath: path)
        }
        self.currentDirectoryUrl = currentDirectoryUrl
    }
    
    // MARK: - Properties
    public let currentDirectoryUrl: FolderProtocol
    public var urls: [FolderProtocol]
}

