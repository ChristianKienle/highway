import Foundation
import FSKit

public final class XCBuildSystem {
    public enum Result {
        case success
        case failure
    }
    
    public final class ExecutionPlan {
        public let xcodebuildTask: Task
        public let xcprettyTask: Task?
        init(xcodebuildTask: Task, xcprettyTask: Task?) {
            self.xcodebuildTask = xcodebuildTask
            self.xcprettyTask = xcprettyTask
        }
        var tasks: [Task] {
            let prettyTaskArray: [Task]
            if let xcprettyTask = xcprettyTask {
                prettyTaskArray = [xcprettyTask]
            } else {
                prettyTaskArray = []
            }
            return [xcodebuildTask] + prettyTaskArray
        }
    }
    private let executableFinder: ExecutableFinder
    private let fileSystem: FileSystem
    public init(executableFinder: ExecutableFinder, fileSystem: FileSystem) {
        self.executableFinder = executableFinder
        self.fileSystem = fileSystem
    }
    
    public enum OutputStyle {
        case prettyIfAvailable
        case raw
    }
    
    public func executionPlan(settings: Xcodebuild, outputStyle: OutputStyle) throws -> ExecutionPlan {
        let xcodebuildTask = try settings.task(executableFinder: executableFinder)

        let xcprettyTask: Task? = outputStyle == .raw ? nil : try? Task(commandName: "xcpretty", currentDirectoryURL: settings.projectDirectory, executableFinder: executableFinder)
        
        if let xcprettyTask = xcprettyTask {
            let xcodebuildOutputPipe = Pipe()
            xcodebuildTask.output = .pipe(xcodebuildOutputPipe)
            xcprettyTask.input = xcodebuildTask.output
        }
        return ExecutionPlan(xcodebuildTask: xcodebuildTask, xcprettyTask: xcprettyTask)
    }

    public func execute(plan: ExecutionPlan, executor: TaskExecutor) -> Result {
        let tasks = plan.tasks
        executor.execute(tasks: tasks)
        switch plan.xcodebuildTask.state {
        case .waiting, .executing:
            return .failure
        case .finished(let result):
            return result.terminationStatus == EXIT_SUCCESS ? .success : .failure
        }
        
    }
}
