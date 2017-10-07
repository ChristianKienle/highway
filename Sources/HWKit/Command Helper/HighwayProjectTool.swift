import HighwayCore
import Foundation
import FileSystem
import Terminal
import HighwayCore
import Url
import Task
import Arguments

/// This class makes it easy to work with the highway project (aka _highway).
/// Specifically, this class can:
///     - Retrieve all highways offered by _highway.
///     - Build the highway project. (+ fallback)
///     - Execute the highway project executable.
public class HighwayProjectTool {
    // MARK: - Properties
    public let context: Context
    public let compiler: SwiftBuildSystem
    public let bundle: HighwayBundle
    private var fileSystem: FileSystem { return context.fileSystem }
    
    // MARK: - Init
    public init(compiler: SwiftBuildSystem, bundle: HighwayBundle, context: Context) {
        self.compiler = compiler
        self.context = context
        self.bundle = bundle
    }
    
    // MARK: - Working with the Tool
    public func availableHighways() -> [HighwayDescription] {
        guard let result = try? build(thenExecuteWith: [PrivateHighway.listPublicHighwaysAsJSON]) else {
            return []
        }
        return (try? Array(rawHighwaysData: result.outputData)) ?? []
    }

    public func update() throws {
        let package = SwiftPackageTool(context: context)
        try package.package(arguments: ["update"], currentDirectoryUrl: bundle.url)
    }
    
    public func build() throws -> BuildResult {
        let artifact = try compiler.compile(bundle: bundle)
        let url = bundle.executableUrl(swiftBinUrl: artifact.binUrl)
        return BuildResult(executableUrl: url, artifact: artifact)
    }
    
    public func build(thenExecuteWith arguments: Arguments) throws -> BuildThenExecuteResult {
        let buildResult = try build()
        let executableUrl = buildResult.executableUrl
        
        try fileSystem.assertItem(at: executableUrl, is: .file)
        
        let _highway = Task(executableUrl: executableUrl, arguments: arguments, currentDirectoryUrl: bundle.url.parent)
        Terminal.shared.log("Launching: \(_highway.executableUrl)")

        _highway.enableReadableOutputDataCapturing()

        context.executor.execute(task: _highway)
        
        try _highway.throwIfNotSuccess()
        
        let output = _highway.capturedOutputData ?? Data()
        return BuildThenExecuteResult(buildResult: buildResult, outputData: output)
    }
}

public extension HighwayProjectTool {
    public struct BuildResult {
        // MARK: - Init
        public init(executableUrl: Absolute, artifact: SwiftBuildSystem.Artifact) {
            self.executableUrl = executableUrl
            self.artifact = artifact
        }
        // MARK: - Properties
        public let executableUrl: Absolute
        public let artifact: SwiftBuildSystem.Artifact
    }
}

public extension HighwayProjectTool {
    public struct BuildThenExecuteResult {
        // MARK: - Init
        public init(buildResult: BuildResult, outputData: Data) {
            self.buildResult = buildResult
            self.outputData = outputData
        }
        // MARK: - Properties
        public let buildResult: BuildResult
        public let outputData: Data
    }
}


