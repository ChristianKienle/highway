import Foundation
import FileSystem
import Url

/// Git namespace
public enum Git {
    public typealias System = _GitProtocol
}

public protocol _GitProtocol {
    func addAll(at url: Absolute) throws
    func commit(at url: Absolute, message: String) throws
    func pushToMaster(at url: Absolute) throws
    func pushTagsToMaster(at url: Absolute) throws
    func currentTag(at url: Absolute) throws -> String
    func clone(with options: Git.CloneOptions) throws
}

public extension Git {
    public struct CloneOptions {
        // MARK: - Properties
        public let remoteUrl: String
        public let localPath: Absolute
        public let performMirror: Bool
        
        // MARK: - Init
        public init(remoteUrl: String, localPath: Absolute, performMirror: Bool = false) {
            self.remoteUrl = remoteUrl
            self.localPath = localPath
            self.performMirror = performMirror
        }
    }
}


