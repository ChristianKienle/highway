import Foundation
import Arguments

public protocol InvocationProvider {
    func invocation() -> Invocation
}

public struct CommandLineInvocationProvider: InvocationProvider {
    public init(args: [String] = CommandLine.arguments) {
        self.args = args
    }
    private let args: [String]
    public func invocation() -> Invocation {
        let rawArgs = Array(args.dropFirst())

        guard let firstArg = rawArgs.first else {
            return Invocation()
        }
        let verbose: Bool
        let remainingArgs: [String]
        if firstArg == "--verbose" {
            verbose = true
            remainingArgs = Array(rawArgs.dropFirst())
        } else {
            verbose = false
            remainingArgs = rawArgs
        }

        guard let highwayName = remainingArgs.first else {
            return Invocation(verbose: verbose)
        }
        return Invocation(highway: highwayName, arguments: Arguments(Array(remainingArgs.dropFirst())), verbose: verbose)
    }
}

