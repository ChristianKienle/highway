import Foundation

public struct HighwayInvocation: Equatable {
    public static func ==(l: HighwayInvocation, r: HighwayInvocation) -> Bool {
        return l.name == r.name && l.arguments == r.arguments
    }
    
    public init(name: String, arguments: [String] = []) {
        self.name = name
        self.arguments = arguments
    }
    public static let empty = HighwayInvocation(name: "", arguments: [])
    public let name: String
    public let arguments: [String]
    public var allArguments: [String] { return [name] + arguments }
    
}
public protocol HighwayInvocationProvider {
    func highwayInvocation() -> HighwayInvocation
}

public struct CommandLineInvocationProvider: HighwayInvocationProvider {
    public init() { }
    public func highwayInvocation() -> HighwayInvocation {
        let args = Array(CommandLine.arguments.dropFirst())
        guard let name = args.first else {
            return .empty
        }
        let arguments = Array(args.dropFirst())
        return HighwayInvocation(name: name, arguments: arguments)
        
    }
}

