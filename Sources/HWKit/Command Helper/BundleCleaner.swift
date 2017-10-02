import HighwayCore
import FSKit

/// Removes build artifacts and calculateable information from the
/// highway bundle = the folder that contains your custom "highfile".
public final class BundleCleaner {
    public struct Result {
        public let deletedFiles: [AbsoluteUrl]
    }
    // MARK: - Init
    public init(bundle: HighwayBundle) {
        self.bundle = bundle
    }
    
    // MARK: - Properties
    public let bundle: HighwayBundle
    
    // MARK: - Command
    public func clean() throws -> Result {
    var deletedFiles = [AbsoluteUrl]()
        if let pinsFile = try bundle.deletePinsFileIfPresent() {
            deletedFiles.append(pinsFile)
        }
        
        if let buildDirectory = try bundle.deleteBuildDirectoryIfPresent() {
            deletedFiles.append(buildDirectory)
        }
        return Result(deletedFiles: deletedFiles)
    }
}
