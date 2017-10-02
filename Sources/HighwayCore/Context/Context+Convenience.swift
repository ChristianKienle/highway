import Foundation
import FSKit

public extension Context {
    public func containsExecutableFor(command: String) -> Bool {
        return executableFinder.urlForExecuable(named: command) != nil
    }
    public func addSearchPaths(_ paths: String...) {
        executableFinder.searchURLs += paths.map { AbsoluteUrl($0) }
    }
}
