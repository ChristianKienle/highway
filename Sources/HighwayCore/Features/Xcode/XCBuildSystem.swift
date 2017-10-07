import Foundation
import FileSystem
import Task

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
    private let executableProvider: ExecutableProvider
    private let fileSystem: FileSystem
    public init(executableProvider: ExecutableProvider, fileSystem: FileSystem) {
        self.executableProvider = executableProvider
        self.fileSystem = fileSystem
    }
    
    public enum OutputStyle {
        case prettyIfAvailable
        case raw
    }
    
    public func executionPlan(settings: Xcodebuild, outputStyle: OutputStyle) throws -> ExecutionPlan {
        let xcodebuildTask = try settings.task(executableFinder: executableProvider)

        let xcprettyTask: Task? = outputStyle == .raw ? nil : try? Task(commandName: "xcpretty", currentDirectoryUrl: settings.projectDirectory, provider: executableProvider)
        
        if let xcprettyTask = xcprettyTask {
            xcodebuildTask.output = .pipe()
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
        case .terminated(let termination):
            return termination.isSuccess ? .success : .failure
        }
    }
}
