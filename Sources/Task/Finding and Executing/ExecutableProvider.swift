import Foundation
import ZFile
import SourceryAutoProtocols

/// Maps names command line tools/executables to file urls.
/// The protcol is implemented in a different frameworok.
public protocol ExecutableProvider: AutoMockable {
    func executable(with name: String) throws -> FileProtocol
}

