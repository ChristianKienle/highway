import Foundation
import ZFile
import Url
import POSIX
import SourceryAutoProtocols


public protocol HighwayBundleProtocol: AutoMockable {
    
    /// sourcery:inline:HighwayBundle.AutoGenerateProtocol
    var url: FolderProtocol { get }
    var fileSystem: FileSystemProtocol { get }
    var configuration: Configuration { get }
    var xcodeprojectParent: FolderProtocol { get }

    func xcodeprojectUrl() throws -> FolderProtocol
    func xcconfigFile() throws -> FileProtocol
    func gitignore() throws -> FileProtocol
    func mainSwiftFile() throws -> FileProtocol
    func package() throws -> FileProtocol
    func pinsFileUrl() throws -> FileProtocol
    func buildDirectory() throws -> FolderProtocol
    func clean() throws -> Bool
    func executableUrl(swiftBinUrl: FolderProtocol) throws -> FileProtocol
    /// sourcery:end
}

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
public final class HighwayBundle: HighwayBundleProtocol, AutoGenerateProtocol {
    // MARK: - Init
    public init(url: FolderProtocol, fileSystem: FileSystemProtocol, configuration: Configuration = .standard) throws {

        self.url = url
        self.fileSystem = fileSystem
        self.configuration = configuration
        
        self.xcodeprojectParent = try url.parentFolder()
        
    }

    public convenience init(fileSystem: FileSystemProtocol, parentUrl: FolderProtocol, configuration: Configuration = .standard) throws {
        let url = try parentUrl.subfolder(named: configuration.directoryName)
        
        try self.init(url: url, fileSystem: fileSystem, configuration: configuration)
    }

    // MARK: - Properties
    public let url: FolderProtocol
    public let fileSystem: FileSystemProtocol
    public let configuration: Configuration
    
    public let xcodeprojectParent: FolderProtocol
    
    public func xcodeprojectUrl() throws -> FolderProtocol {
        return try xcodeprojectParent.subfolder(named: configuration.xcodeprojectName)
    }
    // MARK: - Folders to write to
    public func xcconfigFile() throws -> FileProtocol {
        return try xcodeprojectParent.createFileIfNeeded(named: configuration.xcconfigName)
    }
    
    public func gitignore() throws -> FileProtocol {
        return try xcodeprojectParent.createFileIfNeeded(named: configuration.gitignoreName)
    }

    public func mainSwiftFile() throws -> FileProtocol {
        return try xcodeprojectParent.createFileIfNeeded(named: configuration.mainSwiftFileName)
    }
  
    public func package() throws -> FileProtocol {
        return try xcodeprojectParent.createFileIfNeeded(named: configuration.packageSwiftFileName)
    }
    
    public func pinsFileUrl() throws -> FileProtocol {
        return try xcodeprojectParent.createFileIfNeeded(named: configuration.pinsFileName)
    }

    // MARK: - Folders
    
    public func buildDirectory() throws -> FolderProtocol {
        return try xcodeprojectParent.createSubfolderIfNeeded(withName: configuration.buildDirectoryName)
    }

  
    /// Removes build artifacts and calculateable information from the
    /// highway bundle = the folder that contains your custom "highfile".
    @discardableResult
    public func clean() throws -> Bool {
        let isPinDeleted: Bool = (try? pinsFileUrl().delete()).isNil

        let isBuildDeleted: Bool = (try? buildDirectory().delete()).isNil
        
        return isPinDeleted && isBuildDeleted
    }

    public func executableUrl(swiftBinUrl: FolderProtocol) throws -> FileProtocol {
        return try swiftBinUrl.file(named: configuration.targetName)
    }
}

extension Optional {
    
    var isNil: Bool { return self == nil }
}
