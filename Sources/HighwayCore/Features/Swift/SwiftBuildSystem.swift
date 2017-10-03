import Foundation
import FSKit

public final class SwiftBuildSystem {
    // MARK: - Properties
    public let context: Context
    public var executableFinder: ExecutableFinder { return context.executableFinder }
    public var fileSystem: FileSystem { return executableFinder.fileSystem }
    
    // MARK: - Init
    public init(context: Context = .local()) {
        self.context = context
    }
    
    // Working with Swift
    public func test() throws {
        let task = try Task(commandName: "swift", arguments: ["test"], currentDirectoryURL: getabscwd(), executableFinder: executableFinder)
        context.executor.execute(task: task)
        guard task.state.successfullyFinished else {
            throw "Test failed"
        }
    }
    private func _buildTask(with options: SwiftOptions) throws -> Task {
        return try options.task(fileSystem: fileSystem, executableFinder: executableFinder)
    }
    private func _showBinPathTask(with options: SwiftOptions) throws -> Task {
        return try options.showBinPathTask(fileSystem: fileSystem, executableFinder: executableFinder)
    }
    
    public func executionPlan(with options: SwiftOptions) throws -> ExecutionPlan {
        let buildTask = try _buildTask(with: options)
        let binPathTask = try _showBinPathTask(with: options)

        let buildOutput = TaskIOChannel.pipeChannel()
        let binPathOutput = TaskIOChannel.pipeChannel()
        
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
        var buildLogData = Data()
        plan.buildOutput.readabilityHandler = { handle in
            handle.withAvailableData { newData in
                buildLogData += newData
            }
        }
        
        context.executor.execute(task: buildTask)
        
        guard let rawBuildLog = String(data: buildLogData, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            throw "failed to convert build log data to string"
        }

        try buildTask.throwIfNotSuccess("Failed to build. non-0 exit code. Build log: \(rawBuildLog)")
        
        let showPathTask = plan.showBinPathTask
        var pathData = Data()
        plan.showBinPathOutput.readabilityHandler = { handle in
            handle.withAvailableData { newData in
                pathData += newData
            }
        }
        context.executor.execute(task: showPathTask)
        try showPathTask.throwIfNotSuccess("failed to determine path to executable. swift returned non-0 exit code.")

        guard let rawPath = String(data: pathData, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            throw "failed to convert binary path data to string"
        }
        guard rawPath.isEmpty == false else {
            throw "bin path does not seem to be valid"
        }
        let url = AbsoluteUrl(rawPath)
        try fileSystem.assertItem(at: url, is: .directory)
        return Artifact(binUrl: url, buildOutput: rawBuildLog)
    }
}

public extension SwiftBuildSystem {
    public struct Artifact {
        public var binPath: String { return binUrl.path }
        public let binUrl: AbsoluteUrl
        public let buildOutput: String
    }
}

public extension SwiftBuildSystem {
    public final class ExecutionPlan {
        public let buildTask: Task
        public let buildOutput: TaskIOChannel
        public let showBinPathTask: Task
        public let showBinPathOutput: TaskIOChannel
        public init(buildTask: Task, buildOutput: TaskIOChannel, showBinPathTask: Task, showBinPathOutput: TaskIOChannel) {
            self.buildTask = buildTask
            self.buildOutput = buildOutput
            self.showBinPathTask = showBinPathTask
            self.showBinPathOutput = showBinPathOutput
        }
    }
}

extension SwiftOptions {
    //--build-path
    func task(fileSystem: FileSystem, executableFinder: ExecutableFinder) throws -> Task {
        let arguments = ["swift"] + _processArguments
        return try Task(commandName: "xcrun", arguments: arguments, currentDirectoryURL: projectDirectory, executableFinder: executableFinder)
    }
    func showBinPathTask(fileSystem: FileSystem, executableFinder: ExecutableFinder) throws -> Task {
        let arguments = ["swift"] + _processArgumentsWithoutSettingVerbosity + ["--show-bin-path"]
        return try Task(commandName: "xcrun", arguments: arguments, currentDirectoryURL: projectDirectory, executableFinder: executableFinder)
    }
}
