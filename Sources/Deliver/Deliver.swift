import Foundation
import Url

public protocol _Deliver {
    func now(with options: Deliver.Options) throws
}

public final class Deliver { }

extension Deliver {
    public struct Options {
        public init(ipaUrl: Absolute, username: String, password: Password, platform: Platform = .iOS) {
            self.ipaUrl = ipaUrl
            self.username = username
            self.password = password
            self.platform = platform
        }
        public let ipaUrl: Absolute
        public let platform: Platform
        public let username: String // apple id username
        public let password: Password
    }
}

extension Deliver {
    public final class Local: _Deliver {
        public func now(with options: Deliver.Options) throws {
            let alOptions = Altool.Options(action: .upload, file: options.ipaUrl, type: options.platform, username: options.username, password: options.password, outputFormat: .normal)
            try altool.execute(with: alOptions).assertSuccess()
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
        case keychainItem(named: String)
        case environment(named: String)
    }
}
