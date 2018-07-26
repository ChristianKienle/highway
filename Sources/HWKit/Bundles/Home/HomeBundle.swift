import Foundation
import HighwayCore
import ZFile
import Url
import os

public final class HomeBundle {
    // MARK: - Init
    public init(url: FolderProtocol, fileSystem fs: FileSystemProtocol, configuration: Configuration = .standard) throws {


        self.url = url
        self.fileSystem = fs
        self.configuration = configuration
    }
    
    // MARK: - Properties
    public let url: FolderProtocol
    public let fileSystem: FileSystemProtocol
    public let configuration: Configuration
    public var localCloneUrl: FolderProtocol {
        do { return try url.subfolder(atPath: Component.clone.path.asString) } catch {
            os_log("🔥 %@", type: .error, "failing cot clone local, defaulting to temp directory")
            return FileSystem().temporaryFolder
        }
    }
    
    public func missingComponents() -> Set<Component> {
        let all = Component.all
        let missing = all.filter { component in

            do {
                _  = try url.subfolder(atPath: component.path.asString)
                return  true
            } catch {
                return  false
            }
            
        }
        return missing
    }
}

extension HomeBundle {
    public enum Component: Relative {
        case binDir = "bin"
        case highwayCLI = "bin/highway"
        case clone = "highway"
        
        static let all: Set<Component> = [.binDir, .highwayCLI, .clone]
        var path: Relative { return rawValue }
    }
}

extension HomeBundle {
    public struct Configuration {
        public static let standard: Configuration = {
            var config = Configuration()
            config.remoteRepositoryUrl = env("HIGHWAY_HOME_BUNDLE_REPOSITORY", defaultValue: "https://github.com/ChristianKienle/highway.git")
            return config
        }()
        public init() {}
        public var directoryName = ".highway"
        public var remoteRepositoryUrl = "https://github.com/ChristianKienle/highway.git"
    }
}
