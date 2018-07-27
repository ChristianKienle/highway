import Foundation
import ZFile
import SourceryAutoProtocols
import Url

public protocol DeliverProtocol: AutoMockable {
    
    /// sourcery:inline:Deliver.Local.AutoGenerateProtocol

    func now(with options: Deliver.Options) throws -> Bool
    /// sourcery:end
}

public final class Deliver: AutoGenerateProtocol {
    
}

extension Deliver {
    public struct Options {
        public init(ipaUrl: FileProtocol, username: String, password: Password, platform: Platform = .iOS) {
            self.ipaUrl = ipaUrl
            self.username = username
            self.password = password
            self.platform = platform
        }
        public let ipaUrl: FileProtocol
        public let platform: Platform
        public let username: String // apple id username
        public let password: Password
    }
}

extension Deliver {
    public final class Local: DeliverProtocol, AutoGenerateProtocol {
        public func now(with options: Deliver.Options) throws -> Bool {
            let alOptions = Altool.Options(action: .upload, file: options.ipaUrl, type: options.platform, username: options.username, password: options.password, outputFormat: .normal)
            return try altool.execute(with: alOptions)
        }
        
        public init(altool: Altool) {
            self.altool = altool
       }
        private let altool: Altool
    }
}

public extension Deliver {
    /// Also used by Altool
    public enum Platform: String {
        case macOS = "osx"
        case iOS = "ios"
        case tvOS = "appletvos"
    }
}

public extension Deliver {
    /// Also used by Altool
    public enum Password {
        case plain(String) // value: plain password
//        @available(*, unavailable, message: "Does not work because Highway has no access to your Keychain. Use .environment instead.")
        case keychainItem(named: String)
        case environment(named: String)
    }
}
