import Foundation
import HighwayCore
import FSKit

public class GitMock {
    public init() {}
    public var throwsEnabeld = false
    public var currentTag: String? = "0.0.1"
    public fileprivate(set) var requestedClones = [Git.CloneOptions]()
}

extension GitMock: Git.System {
    public func addAll(at url: AbsoluteUrl) throws {
        try _throwIfEnabled()
    }
    
    public func commit(at url: AbsoluteUrl, message: String) throws {
        try _throwIfEnabled()

    }
    
    public func pushToMaster(at url: AbsoluteUrl) throws {
        try _throwIfEnabled()

    }
    
    public func pushTagsToMaster(at url: AbsoluteUrl) throws {
        try _throwIfEnabled()

    }
    
    public func currentTag(at url: AbsoluteUrl) throws -> String {
        guard let tag = currentTag else {
            try _throwIfEnabled()
            throw "should never happen"
        }
        return tag
    }
    
    public func clone(with options: Git.CloneOptions) throws {
        requestedClones.append(options)
        try _throwIfEnabled()
    }
    
    // MARK: - Helper
    private func _throwIfEnabled() throws {
        if throwsEnabeld { throw "Git failed" }
    }
    
}
