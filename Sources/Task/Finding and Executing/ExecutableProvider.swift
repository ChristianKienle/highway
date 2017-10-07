import Foundation
import Url

/// Maps names command line tools/executables to file urls.
/// The protcol is implemented in a different frameworok.
public protocol ExecutableProvider {
    func urlForExecuable(_ executableName: String) -> Absolute?
}

