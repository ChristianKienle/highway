import Foundation

public protocol TaskExecutor {
    func execute(tasks: [Task])
    func execute(task: Task)
}

public extension TaskExecutor {
    func execute(task: Task) {
        execute(tasks: [task])
    }
}
