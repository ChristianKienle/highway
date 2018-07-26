import Foundation
import Terminal
import SourceryAutoProtocols

public protocol TaskExecutorProtocol: AutoMockable {
    var ui: UIProtocol { get }
    func execute(task: Task) throws
    func launch(task: Task, wait: Bool) throws
}

public extension TaskExecutorProtocol {
    func execute(task: Task) throws {
        try launch(task: task, wait: true)
    }
}
