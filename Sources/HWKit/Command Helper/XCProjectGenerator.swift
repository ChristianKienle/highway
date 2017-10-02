import HighwayCore

// MARK: - Types
public typealias GeneratedXCProject = SwiftPackageTool.XCProjectOptions

public class XCProjectGenerator {
    // MARK: - Init
    public init(context: Context, bundleConfiguration: HighwayBundle.Configuration) {
        self.context = context
        self.bundleConfiguration = bundleConfiguration
    }
    
    // MARK: - Properties
    public let context: Context
    public let bundleConfiguration: HighwayBundle.Configuration
    
    // MARK: - Command
    public func generate() throws -> GeneratedXCProject {
        let swift_package = SwiftPackageTool(context: context)
        let dst = context.currentWorkingUrl.appending(bundleConfiguration.directoryName)
        let options = SwiftPackageTool.XCProjectOptions(swiftProjectDirectory: dst, xcprojectDestinationDirectory: dst.parent, xcconfigFileName: "config.xcconfig")
        try swift_package.generateXcodeproj(with: options)
        return options
    }
}

extension SwiftPackageTool.XCProjectOptions {
    // TODO: Get the path from the swift package generate-commandline tool output.
    // Actual output:
    // generated: /private/tmp/blll.xcodeproj
    // <newline>
    public func openProjectCommand(with configuration: HighwayBundle.Configuration) -> String {
        let projectName = "\(configuration.packageName).xcodeproj"
        let projectPath = xcprojectDestinationDirectory.appending(projectName)
        return "open \(projectPath.path)"
    }
}
