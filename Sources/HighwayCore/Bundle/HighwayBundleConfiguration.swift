import Foundation
import FSKit

/*
 .
 ├── .gitignore
 ├── .build/
 ├── Package.swift
 ├── Package.resolved
 ├── config.xcconfig
 ├── highway-go.xcodeproj
 └── main.swift
 */

public final class HighwayBundle {
    // MARK: - Init
    public init(url: AbsoluteUrl, fileSystem: FileSystem, configuration: Configuration = .standard) throws {
        try fileSystem.assertItem(at: url, is: .directory)
        
        self.url = url
        self.fileSystem = fileSystem
        self.configuration = configuration
    }
    
    public convenience init(parentUrl: AbsoluteUrl = getabscwd(), fileSystem: FileSystem, configuration: Configuration = .standard) throws {
        let url = parentUrl.appending(configuration.directoryName)
        try self.init(url: url, fileSystem: fileSystem, configuration: configuration)
    }
    
    // MARK: - Properties
    public let url: AbsoluteUrl
    public let fileSystem: FileSystem
    public let configuration: Configuration
    
    // MARK: - Working with the Bundle
    public func write(xcconfigData data: Data) throws {
        try fileSystem.writeData(data, to: xcconfigFileUrl)
    }
    
    public func write(gitignore data: Data) throws {
        try fileSystem.writeData(data, to: url.appending(configuration.gitignoreName))
    }
    
    public var xcconfigFileUrl: AbsoluteUrl {
        return url.appending(configuration.xcconfigName)
    }
    
    public var mainSwiftFileUrl: AbsoluteUrl {
        return url.appending("main.swift")
    }
    
    public func write(mainSwiftData data: Data) throws {
        try fileSystem.writeData(data, to: mainSwiftFileUrl)
    }
    
    public var packageFileUrl: AbsoluteUrl {
        return url.appending("Package.swift")
    }
    
    public func write(packageDescription data: Data) throws {
        try fileSystem.writeData(data, to: packageFileUrl)
    }
    
    private var pinsFileUrl: AbsoluteUrl {
        return url.appending(configuration.pinsFileName)
    }
    
    public func deletePinsFileIfPresent() throws -> AbsoluteUrl? {
        return try fileSystem.withExistingFile(at: pinsFileUrl, defaultValue: nil) { (fs, file) -> AbsoluteUrl in
            try fs.deleteItem(at: pinsFileUrl)
            return pinsFileUrl
        }
    }
    
    public var buildDirectory: AbsoluteUrl {
        return url.appending(configuration.buildDirectoryName)
    }
    
    public func deleteBuildDirectoryIfPresent() throws -> AbsoluteUrl? {
        return try fileSystem.withExistingDirectory(at: buildDirectory, defaultValue: nil) { (fs, dir)  in
            try fs.deleteItem(at: buildDirectory)
            return buildDirectory
        }
    }

    public struct CleanResult {
        public let deletedFiles: [AbsoluteUrl]
    }
    /// Removes build artifacts and calculateable information from the
    /// highway bundle = the folder that contains your custom "highfile".
    public func clean() throws -> CleanResult {
        var deletedFiles = [AbsoluteUrl]()
        if let pinsFile = try deletePinsFileIfPresent() {
            deletedFiles.append(pinsFile)
        }
        
        if let buildDirectory = try deleteBuildDirectoryIfPresent() {
            deletedFiles.append(buildDirectory)
        }
        return CleanResult(deletedFiles: deletedFiles)
    }

}

extension HighwayBundle {
    public struct Configuration {
        // MARK: - Getting the default Configuration
        public static let standard = Configuration()
        
        // MARK: - Properties
        public var packageName = "_highway"
        public var targetName = "_highway"
        public var directoryName = "_highway"
        public var buildDirectoryName = ".build" // there is a bug in PM: generating the xcode project causes .build to be used every time...
        public var pinsFileName = "Package.resolved"
        // MARK: - Properties / Convenience
        public var xcconfigName = "config.xcconfig"
        public var gitignoreName = ".gitignore"
        
        // MARK: - Private Stuff
        public let dependencyFromVersion = "0.0.0"
    }
}

