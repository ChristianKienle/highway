import Foundation
import FSKit

public struct SwiftOptions {
    public struct Result {
        public let binPath: String
        public var binURL: URL { return URL(fileURLWithPath: binPath) }
        public let buildOutput: String
    }
    
    public enum Configuration: String {
        case debug, release
    }
    public enum Subject {
        case product(String /* product name */)
        case target(String /* target name */)
        case auto // no further product/target specified - let swift build to the magic
        var _processArguments: [String] {
            switch self {
            case .product(let product):
                return ["--product", product]
            case .target(let target):
                return ["--target", target]
            case .auto: return []
            }
        }
    }
    
    public static func defaultOptions() -> SwiftOptions { return SwiftOptions() }
    public init(subject: Subject = .auto, projectDirectory: AbsoluteUrl = getabscwd(), configuration: Configuration = .debug, verbose: Bool = false, buildPath: AbsoluteUrl? = nil, additionalArguments: [String] = []) {
        self.subject = subject
        self.projectDirectory = projectDirectory
        self.configuration = configuration
        self.verbose = verbose
        self.buildPath = buildPath
        self.additionalArguments = additionalArguments
    }
    public let subject: Subject
    public let projectDirectory: AbsoluteUrl
    public let configuration: Configuration
    public var verbose: Bool
    public var buildPath: AbsoluteUrl?
    public mutating func appending(arguments: [String]) {
        additionalArguments += arguments
    }
    public var additionalArguments: [String]
    var _processArguments: [String] {
        return _processArgumentsWithoutSettingVerbosity
            + (verbose ? ["-v"] : [])
        
    }
    private var _buildPathArguments: [String] {
        guard let buildPath = self.buildPath else { return [] }
        return ["--build-path", buildPath.path]
    }
    var _processArgumentsWithoutSettingVerbosity: [String] {
        return [
            "build",
            "--configuration", configuration.rawValue
            ]
            + subject._processArguments
            + _buildPathArguments
            + additionalArguments
    }
}
