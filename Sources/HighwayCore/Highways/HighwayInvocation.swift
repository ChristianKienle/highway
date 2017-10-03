import Foundation

public protocol HighwayInvocationProvider {
    func highwayInvocation() -> Invocation
}

public struct CommandLineInvocationProvider: HighwayInvocationProvider {
    public init() {}
    
    public func highwayInvocation() -> Invocation {
        let rawArgs = Array(CommandLine.arguments.dropFirst())
        
        let args = Arguments(all: rawArgs)
        
        guard let name = args.all.first else {
            return .empty
        }
        return Invocation(highwayName: name, arguments: args)
    }
}

