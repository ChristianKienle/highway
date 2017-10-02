import Foundation
import Security
import FSKit

public class Keychain {
    public let context: Context
    public init(context: Context = .local()) {
        self.context = context
    }
    public class PasswordQuery {
        public init(account: String, service: String) {
            self.account = account
            self.service = service
        }
        public let account: String
        public let service: String
        public var processArguments: [String] {
            return [
                "find-generic-password",
                "-a", account,
                "-s", service,
                "-w"                        // Display only the password on stdout
            ]
        }
    }
    
    public func password(matching query: PasswordQuery) throws -> String  {
        let task = try Task(commandName: "security", arguments:  query.processArguments, currentDirectoryURL: context.currentWorkingUrl, executableFinder: context.executableFinder)
        task.output = TaskIOChannel.pipeChannel()
        task.enableReadableOutputDataCapturing()

        context.executor.execute(task: task)
        guard task.state.successfullyFinished else {
            throw "Failed to get password from keychain. Non-0 exit code."
        }
        
        guard let password = task.readOutputString?.trimmingCharacters(in: .whitespacesAndNewlines), password.isEmpty == false else {
            throw "Failed to get password from keychain: No Output found."
        }
        
        return password
    }
}
