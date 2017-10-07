import Foundation
import Terminal

public protocol TaskExecutor {
    var ui: UI { get }
    func execute(task: Task, then: ExecutionMode)
}

public extension TaskExecutor {
    func execute(task: Task) {
        execute(task: task, then: .waitUntilExit)
    }
    
    func execute(tasks: [Task]) {
        tasks._tasks().forEach {
            let task = $0.task
            ui.verbose(task.description)
            execute(task: task, then: $0.isLast == true ? .waitUntilExit : .continue)
        }
        tasks.forEach {
            if $0.successfullyFinished == false {
                self.ui.error($0.state.description)
            } else {
                self.ui.verbose($0.state.description)
            }
        }
    }
}

extension Array where Element == Task {
    public func _tasks() -> [(task: Task, isLast: Bool)] {
        return zip(indices, self).map { (index, task) in
            return (task: task, isLast: indices.last == index)
        }
    }
}