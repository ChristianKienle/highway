import Foundation
import Arguments
import Terminal

public final class SystemExecutor: TaskExecutor {
    public var ui: UI
    
    // MARK: - Init
    public init(ui: UI) {
        self.ui = ui
    }
   
    // MARK: - Working with the Executor
    public func execute(task: Task, then: ExecutionMode) {
        let process = task.toProcess
        ui.verbose(task.description)
        task.state = .executing
        process.launch()
        if then == .waitUntilExit {
            process.waitUntilExit()
        }
        if task.successfullyFinished == false {
            ui.error(task.state.description)
        } else {
            ui.verbose(task.state.description)
        }

    }
    
    public func execute(tasks: [Task]) {
        let processes = tasks.map { $0.toProcess }
        zip(tasks, processes).forEach { (task, process) in
            task.state = .executing
            ui.verbose(task.description)
            process.launch()
        }
        processes.last?.waitUntilExit()
        tasks.forEach {
            if $0.successfullyFinished == false {
                self.ui.error($0.state.description)
            } else {
                self.ui.verbose($0.state.description)
            }
        }
    }
}

private extension Process {
    func takeIOFrom(_ task: Task) {
        standardInput = task.input.asProcessChannel
        standardOutput = task.output.asProcessChannel
    }
}

// internal because it is tested
internal extension Task {
    internal var toProcess: Process {
        let result = Process()
        result.arguments = arguments.all
        result.launchPath = executableUrl.path
        if let currentDirectoryPath = currentDirectoryUrl?.path {
            result.currentDirectoryPath = currentDirectoryPath
        }
        var _environment: [String:String] = ProcessInfo.processInfo.environment
        self.environment.forEach {
            _environment[$0.key] = $0.value
        }
        result.environment = _environment
        result.terminationHandler = { terminatedProcess in
            self.state = .terminated(Termination(describing: terminatedProcess))
        }
        result.takeIOFrom(self)
        return result
    }
}
