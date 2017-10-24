import Foundation
import Terminal

public protocol TaskExecutor {
    var ui: UI { get }
    func execute(task: Task)
    func launch(task: Task, wait: Bool)
}

public extension TaskExecutor {
    func execute(task: Task) {
        launch(task: task, wait: true)
    }
}
