import Foundation

public class Directory {
    // MARK: - Properties
    let url: AbsoluteUrl
    let fileSystem: FileSystem
    public var isExistingDirectory: Bool {
        guard let type = try? fileSystem.itemMetadata(at: url).type else {
            return false
        }
        return type == .directory
    }

    // MARK: - Init
    init(url: AbsoluteUrl, in fileSystem: FileSystem) {
        self.url = url
        self.fileSystem = fileSystem
    }
    
    // MARK: - Working with the directory
    public func directory(at url: RelativePath) -> Directory {
        return fileSystem.directory(at: _absoluteUrl(for: url))
    }
    
    public func file(at url: RelativePath) -> File {
        return fileSystem.file(at: _absoluteUrl(for: url))
    }
    
    public func file(named name: String) -> File {
        return file(at: RelativePath(name))
    }
    
    public func directory(named name: String) -> Directory {
        return directory(at: RelativePath(name))
    }
    
    private func _absoluteUrl(`for` path: RelativePath) -> AbsoluteUrl {
        return AbsoluteUrl(path: path.asString, relativeTo: url)
    }
}
