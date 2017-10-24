import Foundation
import Url
import Task
import Arguments

public final class GitAutotag {
    // MARK: - Properties
    public let system: System
    
    // MARK: - Init
    public init(system: System) throws {
        self.system = system
    }
    
    // MARK: - Tagging
    @discardableResult
    public func autotag(at url: Absolute, dryRun: Bool = true) throws -> String {
        let arguments = Arguments(dryRun ? ["-n"] : [])
        let task = try system.task(named: "git-autotag").dematerialize()
        task.arguments = arguments
        task.currentDirectoryUrl = url
        task.enableReadableOutputDataCapturing()
        try system.execute(task).dematerialize()
        guard let rawTag = task.trimmedOutput else {
            throw "Failed to get current tag."
        }
        let numberOfDots = rawTag.reduce(0) { (result, char) -> Int in
            return char == "." ? result + 1 : result
        }
        guard numberOfDots == 2 else {
            throw "'\(rawTag)' is not a valid version number: Must contain two '.'."
        }
        return rawTag
    }
}
