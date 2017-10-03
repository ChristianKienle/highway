import Foundation
import FSKit

/// Git namespace
public enum Git {
    public typealias System = _GitProtocol
}

public protocol _GitProtocol {
    func addAll(at url: AbsoluteUrl) throws
    func commit(at url: AbsoluteUrl, message: String) throws
    func pushToMaster(at url: AbsoluteUrl) throws
    func pushTagsToMaster(at url: AbsoluteUrl) throws
    func currentTag(at url: AbsoluteUrl) throws -> String
    func clone(with options: Git.CloneOptions) throws
}

public extension Git {
    public struct CloneOptions {
        // MARK: - Properties
        public let remoteUrl: String
        public let localPath: AbsoluteUrl
        public let performMirror: Bool
        
        // MARK: - Init
        public init(remoteUrl: String, localPath: AbsoluteUrl, performMirror: Bool = false) {
            self.remoteUrl = remoteUrl
            self.localPath = localPath
            self.performMirror = performMirror
        }
    }
}


