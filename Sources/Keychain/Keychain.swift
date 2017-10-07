import Foundation
import Security
import Task
import Arguments

public class Keychain {
    // MARK: - Init
    public init(system: System) {
        self.system = system
    }
    
    // MARK: - Properties
    public let system: System

    // MARK: - Working with the Keychain
    public func password(matching query: PasswordQuery) throws -> String  {
        let task = try system.task(named: "security").dematerialize()
        task.arguments = query.processArguments
        task.enableReadableOutputDataCapturing()
        try system.execute(task).assertSuccess()

        guard let password = task.trimmedOutput, password.isEmpty == false else {
            throw "Failed to get password from keychain: No Output found."
        }
        
        return password
    }
}

public extension Keychain {
    public class PasswordQuery {
        public init(account: String, service: String) {
            self.account = account
            self.service = service
        }
        public let account: String
        public let service: String
        public var processArguments: Arguments {
            return Arguments("find-generic-password")
                + "-a" + account
                + "-s" + service
                + "-w" // Display only the password on stdout
        }
    }
}
