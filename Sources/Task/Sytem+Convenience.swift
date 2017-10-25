import Foundation
import Result
import Arguments

public extension System {
    public func xcrun(_ tool: String, arguments: Arguments) throws -> Task {
        let task = try self.task(named: "xcrun").dematerialize()
        task.arguments = Arguments(tool) + arguments
        return task
    }
}
