import Foundation
import HighwayCore
import FSKit

public final class HomeBundle {
    // MARK: - Init
    public init(url: AbsoluteUrl, fileSystem fs: FileSystem, configuration: Configuration = .standard) throws {
        do {
            guard try fs.itemMetadata(at: url).type == .directory else {
                throw "Highway home directory does not exist at \(url.path)."
            }
        } catch {
            throw "Highway home directory could not be examined. FS Error at \(url.path)."
        }

        self.url = url
        self.fileSystem = fs
        self.configuration = configuration
    }
    
    // MARK: - Properties
    public let url: AbsoluteUrl
    public let fileSystem: FileSystem
    public let configuration: Configuration
    public var localCloneUrl: AbsoluteUrl {
        return url.appending(Component.clone.path)
    }
    
    public func missingComponents() -> Set<Component> {
        let all = Component.all
        let missing = all.filter { component in
            let componentUrl = url.appending(component.path)
            let expectation = component.fsRequirement
            let isMissing: Bool
            do {
                let componentValid = try self.fileSystem.itemMetadata(at: componentUrl).type == expectation
                isMissing = !componentValid
            } catch {
                isMissing = true
            }
            
            return isMissing
        }
        return missing
    }
}

extension HomeBundle {
    public enum Component: RelativePath {
        case binDir = "bin"
        case highwayCLI = "bin/highway"
        case clone = "highway"
        var fsRequirement: Metadata.ItemType {
            switch self {
            case .binDir, .clone:
                return .directory
            case .highwayCLI:
                return .file
            }
        }
        static let all: Set<Component> = [.binDir, .highwayCLI, .clone]
        var path: RelativePath { return rawValue }
    }
}

extension HomeBundle {
    public struct Configuration {
        public static let standard = Configuration()
        public init() {}
        public var directoryName = ".highway"
        public var remoteRepositoryUrl = "https://github.com/ChristianKienle/highway.git"
    }
}
