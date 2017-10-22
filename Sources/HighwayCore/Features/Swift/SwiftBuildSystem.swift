import Foundation
import FileSystem
import Url
import Task
import Arguments
import POSIX

public final class SwiftBuildSystem {
    // MARK: - Properties
    public let context: Context
    public var executableProvider: ExecutableProvider { return context.executableProvider }
    public var fileSystem: FileSystem { return context.fileSystem }
    
    // MARK: - Init
    public init(context: Context = .local()) {
        self.context = context
    }
    
    // Working with Swift
    public func test() throws {
        let task = try Task(commandName: "swift", provider: executableProvider)
        task.arguments = ["test"]
        task.currentDirectoryUrl = abscwd()
        context.executor.execute(task: task)
        guard task.state.successfullyFinished else {
            throw "Test failed"
        }
    }
    
    private func _buildTask(with options: SwiftOptions) throws -> Task {
        return try options.task(fileSystem: fileSystem, executableProvider: executableProvider)
    }
    
    private func _showBinPathTask(with options: SwiftOptions) throws -> Task {
        return try options.showBinPathTask(fileSystem: fileSystem, executableProvider: executableProvider)
    }
    
    public func executionPlan(with options: SwiftOptions) throws -> ExecutionPlan {
        let buildTask = try _buildTask(with: options)
        let binPathTask = try _showBinPathTask(with: options)

        let buildOutput = Channel.pipe()
        let binPathOutput = Channel.pipe()
        
        buildTask.output = buildOutput
        binPathTask.output = binPathOutput
        
        return ExecutionPlan(buildTask: buildTask, buildOutput: buildOutput, showBinPathTask: binPathTask, showBinPathOutput: binPathOutput)
    }
    
    public func build() throws -> Artifact {
        let plan = try executionPlan(with: .defaultOptions())
        return try execute(plan: plan)
    }
    
    public func execute(plan: ExecutionPlan) throws -> Artifact {
        let buildTask = plan.buildTask
        plan.buildTask.enableReadableOutputDataCapturing()

        context.executor.execute(task: buildTask)
        guard let rawBuildLog = buildTask.capturedOutputString else {
            throw "failed to convert build log data to string"
        }

        try buildTask.throwIfNotSuccess("Failed to build. non-0 exit code. Build log: \(rawBuildLog)")
        let showPathTask = plan.showBinPathTask
        plan.showBinPathTask.enableReadableOutputDataCapturing()
        
        context.executor.execute(task: showPathTask)
        try showPathTask.throwIfNotSuccess("failed to determine path to executable. swift returned non-0 exit code.")
        
        guard let rawPath = showPathTask.trimmedOutput else {
            throw "failed to convert binary path data to string"
        }
        guard rawPath.isEmpty == false else {
            throw "bin path does not seem to be valid"
        }
        let url = Absolute(rawPath)
        try fileSystem.assertItem(at: url, is: .directory)
        return Artifact(binUrl: url, buildOutput: rawBuildLog)
    }
}

public extension SwiftBuildSystem {
    public struct Artifact {
        public var binPath: String { return binUrl.path }
        public let binUrl: Absolute
        public let buildOutput: String
    }
}

public extension SwiftBuildSystem {
    public final class ExecutionPlan {
        public let buildTask: Task
        public let buildOutput: Channel
        public let showBinPathTask: Task
        public let showBinPathOutput: Channel
        public init(buildTask: Task, buildOutput: Channel, showBinPathTask: Task, showBinPathOutput: Channel) {
            self.buildTask = buildTask
            self.buildOutput = buildOutput
            self.showBinPathTask = showBinPathTask
            self.showBinPathOutput = showBinPathOutput
        }
    }
}

extension SwiftOptions {
    //--build-path
    func task(fileSystem: FileSystem, executableProvider: ExecutableProvider) throws -> Task {
        let arguments = ["swift"] + _processArguments
        let task = try Task(commandName: "xcrun", provider: executableProvider)
        task.arguments = arguments
        task.currentDirectoryUrl = projectDirectory
        return task
    }
    func showBinPathTask(fileSystem: FileSystem, executableProvider: ExecutableProvider) throws -> Task {
        let arguments = ["swift"] + _processArgumentsWithoutSettingVerbosity + ["--show-bin-path"]
        let task = try Task(commandName: "xcrun", provider: executableProvider)
        task.arguments = arguments
        task.currentDirectoryUrl = projectDirectory
        return task
    }
}
