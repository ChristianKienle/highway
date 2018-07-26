import HighwayCore
import ZFile
import Url

// MARK: - Types
public typealias GeneratedXCProject = SwiftPackageTool.XCProjectOptions

public class XCProjectGenerator {
    // MARK: - Init
    public init(context: Context, bundle: HighwayBundle) {
        self.context = context
        self.bundle = bundle
    }
    
    // MARK: - Properties
    public let context: Context
    public let bundle: HighwayBundle
    
    // MARK: - Command
    public func generate() throws -> FolderProtocol {
        let swift_package = SwiftPackageTool(context: context)
        let xcconfigName = bundle.configuration.xcconfigName
        let projectUrl = try bundle.xcodeprojectUrl()
        let options = SwiftPackageTool.XCProjectOptions(swiftProjectDirectory: bundle.url,
                                                        xcprojectDestinationDirectory: projectUrl,
                                                        xcconfigFileName: xcconfigName)
        try swift_package.generateXcodeproj(with: options)
        return projectUrl
    }
}
