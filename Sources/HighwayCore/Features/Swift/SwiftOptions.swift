import Foundation
import ZFile
import Url
import Arguments
import POSIX

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
        var _processArguments: Arguments {
            switch self {
            case .product(let product):
                return Arguments(["--product", product])
            case .target(let target):
                return Arguments(["--target", target])
            case .auto: return []
            }
        }
    }
    
    public static func defaultOptions() -> SwiftOptions { return SwiftOptions() }
    public init(subject: Subject = .auto, projectDirectory: FolderProtocol = FileSystem().currentFolder, configuration: Configuration = .debug, verbose: Bool = false, buildPath: FolderProtocol? = nil, additionalArguments: Arguments = .empty) {
        self.subject = subject
        self.projectDirectory = projectDirectory
        self.configuration = configuration
        self.verbose = verbose
        self.buildPath = buildPath
        self.additionalArguments = additionalArguments
    }
    public let subject: Subject
    public let projectDirectory: FolderProtocol
    public let configuration: Configuration
    public var verbose: Bool
    public var buildPath: FolderProtocol?
    public mutating func appending(arguments: Arguments) {
        additionalArguments += arguments
    }
    public var additionalArguments: Arguments
    var _processArguments: Arguments {
        return _processArgumentsWithoutSettingVerbosity
            + (verbose ? ["-v"] : [])
        
    }
    private var _buildPathArguments: Arguments {
        guard let buildPath = self.buildPath else { return [] }
        return Arguments(["--build-path", buildPath.path])
    }
    var _processArgumentsWithoutSettingVerbosity: Arguments {
        return Arguments(["build", "--configuration", configuration.rawValue])
            + subject._processArguments
            + _buildPathArguments
            + additionalArguments
    }
}
