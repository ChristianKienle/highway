import Foundation
import Url
import POSIX

/// Parser that extracts urls from a String-Array of paths.
/// Usually used to parse the contents of the PATH-environment
/// variable. Any component (PATH=comp1:comp2:...) equal to "."
/// is subsituted by $cwd. Furthermore: Any component which only
/// contains a "." is used as an input to Absolute.init:. (which
/// standardizes the path).
public struct PathEnvironmentParser {
    // MARK: - Convenience
    public static func local() -> PathEnvironmentParser {
        let env = ProcessInfo.processInfo.environment
        let path = env["PATH"] ?? ""
        return self.init(value: path, currentDirectoryUrl: abscwd())
    }
    
    // MARK: - Init
    public init(value: String, currentDirectoryUrl: Absolute) {
        let paths = value.components(separatedBy: ":")
        self.urls = paths.flatMap { path in
            guard path != "" else { return nil }
            guard path != "." else { return currentDirectoryUrl }
            
            let isRelative = path.hasPrefix("/") == false
            guard isRelative else { return Absolute(path) }
            return Absolute(path: path, relativeTo: currentDirectoryUrl)
        }
        self.currentDirectoryUrl = currentDirectoryUrl
    }
    
    // MARK: - Properties
    public let currentDirectoryUrl: Absolute
    public var urls: [Absolute]
}

