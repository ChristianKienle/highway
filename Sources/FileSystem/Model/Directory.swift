import Foundation
import Url

public class Directory {
    // MARK: - Properties
    let url: Absolute
    let fileSystem: FileSystem
    public var isExistingDirectory: Bool {
        guard let type = try? fileSystem.itemMetadata(at: url).type else {
            return false
        }
        return type == .directory
    }

    // MARK: - Init
    init(url: Absolute, in fileSystem: FileSystem) {
        self.url = url
        self.fileSystem = fileSystem
    }
    
    // MARK: - Working with the directory
    public func directory(at url: Relative) -> Directory {
        return fileSystem.directory(at: _absoluteUrl(for: url))
    }
    
    public func file(at url: Relative) -> File {
        return fileSystem.file(at: _absoluteUrl(for: url))
    }
    
    public func file(named name: String) -> File {
        return file(at: Relative(name))
    }
    
    public func directory(named name: String) -> Directory {
        return directory(at: Relative(name))
    }
    
    private func _absoluteUrl(`for` path: Relative) -> Absolute {
        return Absolute(path: path.asString, relativeTo: url)
    }
}
