import Foundation
import ZFile
import Arguments

extension Altool {
    public struct Options {
        // MARK: - Properties
        public let action: Action
        public let file: FileProtocol
        public let type: Platform
        public let username: String
        public let password: Password
        public let outputFormat: OutputFormat
        
        // MARK: - Init
        public init(action: Action, file: FileProtocol, type: Platform, username: String, password: Password, outputFormat: OutputFormat) {
            self.action = action
            self.file = file
            self.type = type
            self.username = username
            self.password = password
            self.outputFormat = outputFormat
        }
        
        // MARK: - Convenience
        var arguments: Arguments {
            let fileArguments = Arguments(["--file", file.path])
            return  Arguments(argumentsArray: [action.arguments,
                                               fileArguments,
                                               type.arguments,
                                               ["--username", username],
                                               password.arguments,
                                               outputFormat.arguments
                ])
        }
    }
}

// MARK: - Helper Model Objects

extension Altool.Options {
    /// rawValue represents action's cli-argument
    public enum Action: String {
        case validate = "--validate-app"
        case upload = "--upload-app"
        
        // MARK: - Properties
        var arguments: Arguments { return [rawValue] }
    }
}

extension Altool.Options {
    public enum OutputFormat: String {
        case normal
        case xml
        
        // MARK: - Properties
        var arguments: Arguments { return ["--output-format", rawValue] }
    }
}

extension Altool.Options {
    public typealias Platform = Deliver.Platform
}

extension Deliver.Platform {
    fileprivate var arguments: Arguments { return ["--type", rawValue] }
}

extension Altool.Options {
    public typealias Password = Deliver.Password
}

extension Deliver.Password {
    // MARK: - Properties
    private var passwordArgument: String {
        switch self {
        case .plain(let password):
            return password
        case .keychainItem(let item):
            return "@keychain:" + item
        case .environment(let env):
            return "@env:" + env
        }
    }
    fileprivate var arguments: Arguments {
        return  ["--password", passwordArgument]
    }

}
