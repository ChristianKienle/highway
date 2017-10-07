import Foundation
import FileSystem
import Url
import POSIX

/**
.
└── your app/
    ├── _highway/
    │   ├── .gitignore
    │   ├── .build/
    │   ├── Package.resolved
    │   ├── Package.swift
    │   ├── config.xcconfig
    │   └── main.swift
    ├── _highway.xcodeproj/
    └── your app.xcodeproj/
 */

public final class HighwayBundle {
    // MARK: - Init
    public init(url: Absolute, fileSystem: FileSystem, configuration: Configuration = .standard) throws {
        try fileSystem.assertItem(at: url, is: .directory)

        self.url = url
        self.fileSystem = fileSystem
        self.configuration = configuration
    }

    public convenience init(fileSystem: FileSystem, parentUrl: Absolute = abscwd(), configuration: Configuration = .standard) throws {
        let url = parentUrl.appending(configuration.directoryName)
        try self.init(url: url, fileSystem: fileSystem, configuration: configuration)
    }

    // MARK: - Properties
    public let url: Absolute
    public let fileSystem: FileSystem
    public let configuration: Configuration
    public var xcodeprojectParent: Absolute {
        return url.parent
    }
    public var xcodeprojectUrl: Absolute {
        return url.parent.appending(configuration.xcodeprojectName)
    }
    // MARK: - Working with the Bundle
    public func write(xcconfigData data: Data) throws {
        try fileSystem.writeData(data, to: xcconfigFileUrl)
    }

    public func write(gitignore data: Data) throws {
        try fileSystem.writeData(data, to: url.appending(configuration.gitignoreName))
    }

    public var gitignoreFileUrl: Absolute {
        return url.appending(configuration.gitignoreName)
    }

    public var xcconfigFileUrl: Absolute {
        return url.appending(configuration.xcconfigName)
    }

    public var mainSwiftFileUrl: Absolute {
        return url.appending(configuration.mainSwiftFileName)
    }

    public func write(mainSwiftData data: Data) throws {
        try fileSystem.writeData(data, to: mainSwiftFileUrl)
    }

    public var packageFileUrl: Absolute {
        return url.appending(configuration.packageSwiftFileName)
    }

    public func write(packageDescription data: Data) throws {
        try fileSystem.writeData(data, to: packageFileUrl)
    }

    private var pinsFileUrl: Absolute {
        return url.appending(configuration.pinsFileName)
    }

    public func deletePinsFileIfPresent() throws -> Absolute? {
        return try fileSystem.withExistingFile(at: pinsFileUrl, defaultValue: nil) { (fs, file) -> Absolute in
            try fs.deleteItem(at: pinsFileUrl)
            return pinsFileUrl
        }
    }

    public var buildDirectory: Absolute {
        return url.appending(configuration.buildDirectoryName)
    }

    public func deleteBuildDirectoryIfPresent() throws -> Absolute? {
        return try fileSystem.withExistingDirectory(at: buildDirectory, defaultValue: nil) { (fs, dir)  in
            try fs.deleteItem(at: buildDirectory)
            return buildDirectory
        }
    }

    public struct CleanResult {
        public let deletedFiles: [Absolute]
    }
    /// Removes build artifacts and calculateable information from the
    /// highway bundle = the folder that contains your custom "highfile".
    public func clean() throws -> CleanResult {
        var deletedFiles = [Absolute]()
        if let pinsFile = try deletePinsFileIfPresent() {
            deletedFiles.append(pinsFile)
        }

        if let buildDirectory = try deleteBuildDirectoryIfPresent() {
            deletedFiles.append(buildDirectory)
        }
        return CleanResult(deletedFiles: deletedFiles)
    }

    public func executableUrl(swiftBinUrl: Absolute) -> Absolute {
        return swiftBinUrl.appending(configuration.targetName)
    }
}

extension HighwayBundle {
    public struct Configuration {
        // MARK: - Getting the default Configuration
        public static let standard = Configuration._standard()
        static func _standard() -> Configuration {
            var c = Configuration()
            c.branch = env("HIGHWAY_BUNDLE_BRANCH", defaultValue: "master")
            return c
        }
        // MARK: - Properties
        public var mainSwiftFileName = "main.swift"
        public var packageSwiftFileName = "Package.swift"
        public var xcodeprojectName = "_highway.xcodeproj"
        public var packageName = "_highway"
        public var targetName = "_highway"
        public var directoryName = "_highway"
        public var buildDirectoryName = ".build" // there is a bug in PM: generating the xcode project causes .build to be used every time...
        public var pinsFileName = "Package.resolved"
        // MARK: - Properties / Convenience
        public var xcconfigName = "config.xcconfig"
        public var gitignoreName = ".gitignore"

        // MARK: - Private Stuff
        public var branch = "master"
    }
}
