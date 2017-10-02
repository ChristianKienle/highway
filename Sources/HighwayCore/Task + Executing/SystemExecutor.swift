import Foundation

extension Zip2Sequence where Sequence1.Iterator.Element == Task, Sequence2.Iterator.Element == Process {
    var taskProcessPairs: [(task: Task, process: Process)] {
        return map { (task: $0.0, process: $0.1) }
    }
}

final class SystemExecutor: TaskExecutor {
    public init() {
    }
    
    /* internal for testing */
    func _process(with task: Task) -> Process {
        let process = Process()
        process.arguments = task.arguments
        process.launchPath = task.executableURL.path
        process.currentDirectoryPath = task.currentDirectoryUrl.path
        var environment: [String:String] = ProcessInfo.processInfo.environment
        task.environment.forEach {
            environment[$0.key] = $0.value
        }
        process.environment = environment
        process.terminationHandler = { p in
            let result = Task.Result(terminationReason: p.terminationReason, terminationStatus: p.terminationStatus)
            task.state = .finished(result)
        }
        process.standardInput = task.input.asProcessChannel
        process.standardOutput = task.output.asProcessChannel
        process.standardError = task.error.asProcessChannel
        return process
    }
    
    func execute(task: Task) {
        let process = _process(with: task)
        task.state = .executing
        process.launch()
        process.waitUntilExit()
    }
    
    func execute(tasks: [Task]) {
        let processes:[Process] = tasks.map { task in
            return self._process(with: task)
        }
        let taskProcessPairs = zip(tasks, processes).taskProcessPairs
        for taskProcessPair in taskProcessPairs {
            
            taskProcessPair.task.state = .executing
            taskProcessPair.process.launch()
        }        
        processes.last?.waitUntilExit()
    }
}


