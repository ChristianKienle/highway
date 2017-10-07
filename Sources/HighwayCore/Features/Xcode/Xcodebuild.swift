import Foundation
import FileSystem
import Url
import Task
import Arguments
import POSIX

public struct Xcodebuild {
    public init(
        projectDirectory: Absolute? = nil, // Default: currentWorkingDirectory
        target: String? = nil,
        project: String? = nil,
        configuration: String? = nil,
        architecture: String? = nil,
        sdk: String? = nil,
        showBuildSettings: Bool = false,
        buildSettings:[String : String] = [:],
        customArguments: Arguments = [],
        buildAction: String? = nil
        ) {
        self.projectDirectory = projectDirectory ?? abscwd()
        self.target = target
        self.project = project
        self.configuration = configuration
        self.architecture = architecture
        self.sdk = sdk
        self.showBuildSettings = showBuildSettings
        self.buildSettings = buildSettings
        self.customArguments = customArguments
        self.buildAction = buildAction
    }
    
    public let projectDirectory: Absolute // Default: currentWorkingDirectory
    public let target: String?
    public let project: String?
    public let configuration: String?
    public let architecture: String?
    public let sdk: String?
    public let showBuildSettings: Bool
    public let buildSettings:[String : String]
    public let customArguments: Arguments
    public let buildAction: String?
    
    public func task(executableFinder: ExecutableProvider) throws -> Task {
        return try Task(commandName: "xcrun", arguments: arguments, currentDirectoryUrl: projectDirectory, provider: executableFinder)
    }

    var arguments: Arguments {
        var res = Arguments("xcodebuild")
        if let target = target {
            res += ["-target", target]
        }
        if let project = project {
            res += ["-project", project]
        }
        if let configuration = configuration {
            res += ["-configuration", configuration]
        }
        if let architecture = architecture {
            res += ["-arch", architecture]
        }
        if let sdk = sdk {
            res += ["-sdk", sdk]
        }
        if showBuildSettings {
            res += ["-showBuildSettings"]
        }
        let settingsArray: [String] = buildSettings.map { "\($0.key)=\($0.value)" }
        res += settingsArray
        res += customArguments
        if let buildAction = buildAction {
            res += [buildAction]
        }
        return res
    }
}
