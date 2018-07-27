import Foundation
import ZFile
import Url
import Task
import Arguments

public final class SwiftPackageTool {
    // MARK: - Init
    public init(context: Context) {
        self.context = context
    }
    // MARK: - Properties
    public let context: Context

    // MARK: - Working with the tool
    public func generateXcodeproj(with options: XCProjectOptions) throws {
        // Ensure destination exists
        let destinationDirectory = options.swiftProjectDirectory
        
        let arguments = options.arguments
        let task = try _packageProcess(arguments: arguments, currentDirectoryUrl: destinationDirectory)
        try context.executor.execute(task: task)
        
        guard task.state.successfullyFinished else {
            throw "swift package failed"
        }
    }
    
    private func _packageProcess(arguments: Arguments, currentDirectoryUrl: FolderProtocol) throws -> Task {
        let arguments = ["package"] + arguments
        let task = try Task(commandName: "swift", provider: context.executableProvider)
        task.currentDirectoryUrl = currentDirectoryUrl
        task.arguments = arguments
        task.enableReadableOutputDataCapturing()
        return task
    }

    public func package(arguments: Arguments, currentDirectoryUrl: FolderProtocol) throws  {
        let task = try _packageProcess(arguments: arguments, currentDirectoryUrl: currentDirectoryUrl)
        try context.executor.execute(task: task)
        
        guard task.state.successfullyFinished else {
            throw "Failed to run swift package because the process returned an error."
        }
    }
}

public extension SwiftPackageTool {
    public struct XCProjectOptions {
        public init(swiftProjectDirectory: FolderProtocol, xcprojectDestinationDirectory: FolderProtocol, xcconfigFileName: String?) {
            self.swiftProjectDirectory = swiftProjectDirectory
            self.xcprojectDestinationDirectory = xcprojectDestinationDirectory
            self.xcconfigFileName = xcconfigFileName
        }
        public let swiftProjectDirectory: FolderProtocol
        public let xcprojectDestinationDirectory: FolderProtocol
        public let xcconfigFileName: String?
        
        var arguments: Arguments {
            let xcconfigArguments = xcconfigFileName.map { return ["--xcconfig-overrides", $0] } ?? []
            return Arguments(["generate-xcodeproj"] + xcconfigArguments + ["--output", xcprojectDestinationDirectory.path])
        }
    }
}

