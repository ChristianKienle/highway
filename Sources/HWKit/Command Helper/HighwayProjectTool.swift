import HighwayCore
import Foundation
import FSKit
import Terminal

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
    private var currentDirectoryUrl: AbsoluteUrl { return context.currentWorkingUrl }
    
    // MARK: - Init
    public init(compiler: SwiftBuildSystem, bundle: HighwayBundle, context: Context) throws {
        self.compiler = compiler
        self.context = context
        self.bundle = bundle
    }
    
    
    // MARK: - Working with the Tool
    public func availableHighways() -> [RawHighway] {
        do {
            let arguments = ["listPublicHighwaysAsJSON"]
            let result = try build(thenExecuteWith: arguments, currentDirectoryUrl: currentDirectoryUrl)
            return (try? Array(rawHighwaysData: result.outputData)) ?? []
        } catch {
            return []
        }
    }

    public func build() throws -> BuildResult {
        let artifact = try compiler.compile(bundle: bundle)
        let url = bundle.executableUrl(swiftBinUrl: artifact.binUrl)
        return BuildResult(executableUrl: url, artifact: artifact)
    }
    
    public func build(thenExecuteWith arguments: [String], currentDirectoryUrl: AbsoluteUrl) throws -> BuildThenExecuteResult {
        let buildResult = try build()
        let executableURL = buildResult.executableUrl
        
        try fileSystem.assertItem(at: executableURL, is: .file)
        
        let _highway = Task(executableURL: executableURL, arguments: arguments, currentDirectoryURL: currentDirectoryUrl)
        Terminal.shared.log("Launching: \(_highway.executableURL)")

        _highway.output = .pipeChannel()
        _highway.enableReadableOutputDataCapturing()

        context.executor.execute(task: _highway)
        
        try _highway.throwIfNotSuccess()
        
        let output = _highway.readOutputData ?? Data()

        return BuildThenExecuteResult(buildResult: buildResult, outputData: output)
    }

}

public extension HighwayProjectTool {
    public struct BuildResult {
        // MARK: - Init
        public init(executableUrl: AbsoluteUrl, artifact: SwiftBuildSystem.Artifact) {
            self.executableUrl = executableUrl
            self.artifact = artifact
        }
        // MARK: - Properties
        public let executableUrl: AbsoluteUrl
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


