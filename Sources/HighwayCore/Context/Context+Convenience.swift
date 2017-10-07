import Foundation
import FileSystem
import Url

public extension Context {
    public func containsExecutableFor(command: String) -> Bool {
        return executableProvider.urlForExecuable(command) != nil
    }
}
