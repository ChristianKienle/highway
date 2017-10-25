import Foundation
import HighwayCore
import FileSystem
import Url
import Git

public class GitMock {
    public init() {}
    public var throwsEnabeld = false
    public var currentTag: String? = "0.0.1"
    public fileprivate(set) var requestedClones = [CloneOptions]()
}

extension GitMock: GitTool {
    public func fetch(at url: Absolute) throws {
        try _throwIfEnabled()
    }
    
    public func pull(at url: Absolute) throws {
        try _throwIfEnabled()
    }
    
    public func addAll(at url: Absolute) throws {
        try _throwIfEnabled()
    }
    
    public func commit(at url: Absolute, message: String) throws {
        try _throwIfEnabled()
    }
    
    public func pushToMaster(at url: Absolute) throws {
        try _throwIfEnabled()
    }
    
    public func pushTagsToMaster(at url: Absolute) throws {
        try _throwIfEnabled()
    }
    
    public func currentTag(at url: Absolute) throws -> String {
        guard let tag = currentTag else {
            try _throwIfEnabled()
            throw "should never happen"
        }
        return tag
    }
    
    public func clone(with options: CloneOptions) throws {
        requestedClones.append(options)
        try _throwIfEnabled()
    }
    
    // MARK: - Helper
    private func _throwIfEnabled() throws {
        if throwsEnabeld { throw "Git failed" }
    }
}
