import Foundation
import HighwayCore

public final class HighwayBundleCreator {
    // MARK: - Creating
    public init(bundle: HighwayBundle, homeBundle: HomeBundle) {
        self.bundle = bundle
        self.homeBundle = homeBundle
    }
    
    // MARK: - Properties
    public let bundle: HighwayBundle
    public let homeBundle: HomeBundle
    
    // MARK: - Creating Bundles
    public func create() throws {
        try _writeXCConfig()
        try _updatePackageDescription()
        try _createMainSwiftFile()
    }
    
    private func _writeXCConfig() throws {
        let configData = xcconfigTemplate.data(using: .utf8)!
        try bundle.write(xcconfigData: configData)
    }
    private func _writeGitIgnore() throws {
        let data = gitignoreTemplate.data(using: .utf8)!
        try bundle.write(gitignore: data)
    }

    private func _createMainSwiftFile() throws {
        let mainSwiftFileData = mainSwiftTemplate.data(using: .utf8)!
        try bundle.write(mainSwiftData: mainSwiftFileData)
    }
    
    private func _updatePackageDescription() throws {
        let dependencyUrl = homeBundle.configuration.remoteRepositoryUrl
        let fromVersion = bundle.configuration.dependencyFromVersion
        let packageName = bundle.configuration.packageName
        let targetName = bundle.configuration.targetName
        
        let contents = packageDescriptionTemplate(packageName: packageName, targetName: targetName, dependencyFromVersion: fromVersion, dependencyUrl: dependencyUrl)
        let data = contents.data(using: .utf8)!
        try bundle.write(packageDescription: data)
    }
}
