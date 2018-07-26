import Foundation
import Security
import Task
import Arguments
import SourceryAutoProtocols

public protocol KeychainProtocol: AutoMockable {
    
    /// sourcery:inline:Keychain.AutoGenerateProtocol
    var system: SystemProtocol { get }

    func password(matching query: Keychain.PasswordQuery) throws -> String
    /// sourcery:end
}

public class Keychain: KeychainProtocol, AutoGenerateProtocol {
    // MARK: - Init
    public init(system: SystemProtocol) {
        self.system = system
    }
    
    // MARK: - Properties
    public let system: SystemProtocol

    // MARK: - Working with the Keychain
    public func password(matching query: PasswordQuery) throws -> String  {
        let task = try system.task(named: "security")
        task.arguments = query.processArguments
        task.enableReadableOutputDataCapturing()
        try system.execute(task)

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
