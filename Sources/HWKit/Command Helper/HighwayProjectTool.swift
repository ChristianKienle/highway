import HighwayCore
import Foundation
import ZFile
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
    private var fileSystem: FileSystemProtocol { return context.fileSystem }
    
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
        let url = try bundle.executableUrl(swiftBinUrl: artifact.binUrl)
        return BuildResult(executableUrl: url, artifact: artifact)
    }
    
    public func build(thenExecuteWith arguments: Arguments) throws -> BuildThenExecuteResult {
        let buildResult = try build()
        let executableUrl = buildResult.executableUrl
        
        let _highway = Task(executable: executableUrl,
                            arguments: arguments,
                            currentDirectoryUrl: try bundle.url.parentFolder()
        )
        Terminal.shared.log("Launching: \(_highway.executable)")

        _highway.enableReadableOutputDataCapturing()

        try context.executor.execute(task: _highway)
        
        try _highway.throwIfNotSuccess("🛣🔥 \(HighwayProjectTool.self) failed running highway\n\(_highway).")
        
        let output = _highway.capturedOutputData ?? Data()
        return BuildThenExecuteResult(buildResult: buildResult, outputData: output)
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


