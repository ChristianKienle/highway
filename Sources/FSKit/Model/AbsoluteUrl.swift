import Foundation

/// This type ensured two things:
/// 1. It always represents an absolute file url
/// 2. It always works with standardized urls
public struct Absolute {
    // MARK: - Globals
    public static let root = Absolute("/")
    
    // MARK: - Init
    public init(_ absPath: String) {
        precondition(absPath.isAbsolutePath)
        self.init(URL(fileURLWithPath: absPath))
    }
    
    public init(path: String, relativeTo base: Absolute) {
        self = base.appending(path)
    }
    
    public init(_ fileURL: URL) {
        precondition(fileURL.isFileURL)
        _url = fileURL.standardizedFileURL
        assert(_url.pathComponents.first == "/")
    }
    
    // MARK: - Properties
    private var _url: URL
    public var path: String {
        return url.path
    }
    public var asRelativePath: String {
        return String(path.dropFirst())
    }
    
    public fileprivate(set) var url: URL {
        set {
            _url = newValue.standardizedFileURL
        }
        get {
            return _url
        }
    }
    
    public var urlsFromRootToSelf: (root: Absolute, remainingUrls: [Absolute]) {
        var current = self
        var urls = [Absolute]()
        while current.isRoot == false {
            urls.append(current)
            current = current.parent
        }
        let result = Array(urls.reversed())
        return (root: .root, remainingUrls: result)
    }
}

extension Absolute: Hashable {
    public var hashValue: Int {
        return url.hashValue
    }
}

extension Absolute: Equatable {
    public static func ==(lhs: Absolute, rhs: Absolute) -> Bool {
        return lhs.url == rhs.url
    }
}

extension Absolute : CustomStringConvertible {
    public var description: String {
        return "\(url.path)"
    }
}

extension Absolute : CustomDebugStringConvertible {
    public var debugDescription: String {
        return "\(url.path)"
    }
}

extension Absolute {
    public var isRoot: Bool {
        return url.pathComponents == ["/"]
    }
    
    public var parent: Absolute {
        guard isRoot == false else {
            return self
        }
        let parentURL = url.deletingLastPathComponent().standardizedFileURL
        return Absolute(parentURL)
    }
  
    public var lastPathComponent: String { return url.lastPathComponent }
    public func appending(_ subpath: String) -> Absolute {
        return Absolute(url.appendingPathComponent(subpath).standardizedFileURL)
    }
    public func appending(_ relativePath: Relative) -> Absolute {
        return appending(relativePath.asString)
    }
}

// MARK: - FileManager Support for Absolute, so that we do not have to expose a URL.
public extension FileManager {
    public func removeItem(atAbsolute url: Absolute) throws {
        try removeItem(at: url.url)
    }
    public func createDirectory(atAbsolute url: Absolute, withIntermediateDirectories createIntermediates: Bool) throws {
        try createDirectory(at: url.url, withIntermediateDirectories: createIntermediates, attributes: nil)
    }
}

public extension Data {
    public func write(toAbsolute url: Absolute) throws {
        try write(to: url.url)
    }
    public init(contentsOfAbsolute url: Absolute) throws {
        try self.init(contentsOf: url.url)
    }
}
public extension String {
    public var isAbsolutePath: Bool { return hasPrefix("/") }
}

