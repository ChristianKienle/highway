import HighwayCore
import Foundation
import FileSystem
import Terminal
import HighwayCore
import Url
import Task
import Arguments
import SwiftTool

/// This class makes it easy to work with the highway project (aka _highway).
/// Specifically, this class can:
///     - Retrieve all highways offered by _highway.
///     - Build the highway project. (+ fallback)
///     - Execute the highway project executable.
public class HighwayProjectTool {
    // MARK: - Properties
    public let system: System
    public let compiler: SwiftTool
    public let bundle: HighwayBundle
    public var fileSystem: FileSystem
    
    // MARK: - Init
    public init(compiler: SwiftTool, bundle: HighwayBundle, system: System, fileSystem: FileSystem) {
        self.compiler = compiler
        self.system = system
        self.bundle = bundle
        self.fileSystem = fileSystem
    }
    
    // MARK: - Working with the Tool
    public func availableHighways() -> [HighwayDescription] {
        guard let result = try? build(thenExecuteWith: [PrivateHighway.listPublicHighwaysAsJSON]) else {
            return []
        }
        return (try? Array(rawHighwaysData: result.outputData)) ?? []
    }

    public func update() throws {
        try compiler.update(projectAt: bundle.url)
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

        try system.execute(_highway).assertSuccess()
        
        let output = _highway.capturedOutputData ?? Data()
        return BuildThenExecuteResult(buildResult: buildResult, outputData: output)
    }
}

public extension HighwayProjectTool {
    public struct BuildResult {
        // MARK: - Init
        public init(executableUrl: Absolute, artifact: Artifact) {
            self.executableUrl = executableUrl
            self.artifact = artifact
        }
        // MARK: - Properties
        public let executableUrl: Absolute
        public let artifact: Artifact
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


