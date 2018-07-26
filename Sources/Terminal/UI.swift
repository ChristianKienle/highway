import Foundation
import SourceryAutoProtocols

public protocol UIProtocol: AutoMockable {
    func message(_ text: String)
    func success(_ text: String)

    /// Prints text only if --verbose is set.
    func verbose(_ text: String)
    func error(_ text: String)
    
    /// Prints printable
    func print(_ printable: Printable)
    
    /// Prints printable only if --verbose is set.
    func verbosePrint(_ printable: Printable)
}
