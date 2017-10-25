import Url
import Arguments

public protocol SwiftTool {
    func test(projectAt url: Absolute) throws
    func build(projectAt url: Absolute, options: SwiftOptions) throws -> Artifact
    func generateProject(with options: XcodeprojOptions) throws
    func update(projectAt url: Absolute) throws
}

public struct Artifact {
    public let binUrl: Absolute
    public let buildOutput: String
}

public struct XcodeprojOptions {
    public init(
        swiftProject: Absolute,
        outputDir: Absolute,
        xcconfig: String?
        ) {
        self.swiftProject = swiftProject
        self.outputDir = outputDir
        self.xcconfig = xcconfig
    }
    public let swiftProject: Absolute
    public let outputDir: Absolute
    public let xcconfig: String?

    var arguments: Arguments {
        let xcconfigArg = xcconfig.map { return ["--xcconfig-overrides", $0] } ?? []
        return Arguments(["generate-xcodeproj"] + xcconfigArg + ["--output", outputDir.path])
    }
}

public struct SwiftOptions {
    public struct Result {
        public var binUrl: Absolute
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
    public init(subject: Subject = .auto, configuration: Configuration = .debug, verbose: Bool = false, buildPath: Absolute? = nil, additionalArguments: Arguments = .empty) {
        self.subject = subject
        self.configuration = configuration
        self.verbose = verbose
        self.buildPath = buildPath
        self.additionalArguments = additionalArguments
    }
    public let subject: Subject
    public let configuration: Configuration
    public var verbose: Bool
    public var buildPath: Absolute?
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
