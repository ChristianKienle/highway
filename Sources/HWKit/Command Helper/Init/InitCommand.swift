import Foundation
import HighwayCore
import FSKit

public final class InitCommand {
    // MARK: - Init
    public init(context: Context, destinationUrl: AbsoluteUrl, bundleConfiguration: HighwayBundle.Configuration, homeBundle: HomeBundle) {
        self.context = context
        self.destinationUrl = destinationUrl
        self.bundleConfiguration = bundleConfiguration
        self.homeBundle = homeBundle
    }
    
    // MARK: - Properties
    public let context: Context
    private var fileSystem: FileSystem { return context.fileSystem }
    public let destinationUrl: AbsoluteUrl // directory, where the initialization should take place
    public let bundleConfiguration: HighwayBundle.Configuration
    public let homeBundle: HomeBundle
    private var bundleDestinationUrl: AbsoluteUrl {
        return destinationUrl.appending(bundleConfiguration.directoryName)
    }
    
    // MARK: - Command
    public func execute() throws {        
        // Check if ./highway-go already exists
        
        guard fileSystem.directory(at: bundleDestinationUrl).isExistingDirectory == false else {
            throw "Initialization Failed: Directory/File named '\(bundleConfiguration.directoryName)' already exists."
        }
        // If not, create it
        try fileSystem.createDirectory(at: bundleDestinationUrl)
        
        // And now create the actual bundle
        let bundle = try HighwayBundle(url: bundleDestinationUrl, fileSystem: fileSystem, configuration: bundleConfiguration)
        let creator = HighwayBundleCreator(bundle: bundle, homeBundle: homeBundle)
        try creator.create()
        
        // Enable edit mode
//        let swift_package = SwiftPackageTool(context: context)
//        try swift_package.package(arguments: ["edit", "highway", "--path", homeBundle.localCoreCloneUrl.path], currentDirectoryUrl: bundle.url)
    }
}

