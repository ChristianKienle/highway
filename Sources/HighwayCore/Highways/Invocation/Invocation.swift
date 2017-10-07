import Foundation
import Arguments

public final class Invocation {
    // MARK: - Init
    public init(highway: String = "", arguments: Arguments = .empty, verbose: Bool = false) {
        self.highway = highway
        self.arguments = arguments
        self.verbose = verbose
    }
    
    // MARK: - Properties
    public let highway: String
    public let arguments: Arguments
    public let verbose: Bool
    public var representsEmptyInvocation: Bool { return highway == "" }
}

extension Invocation: Equatable {
    public static func ==(l: Invocation, r: Invocation) -> Bool {
        return l.highway == r.highway && l.arguments == r.arguments && l.verbose == r.verbose
    }
}
