import HighwayCore
import SwiftTool

public extension SwiftTool {
    public func compile(bundle: HighwayBundle) throws -> Artifact {
        let options = SwiftOptions(subject: .auto, configuration: .debug, verbose: true, buildPath: bundle.buildDirectory, additionalArguments: [])
        return try build(projectAt: bundle.url, options: options)
    }
}

