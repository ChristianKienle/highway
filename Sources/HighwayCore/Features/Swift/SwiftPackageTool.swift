import Foundation
import FSKit

public final class SwiftPackageTool {
    // MARK: - Init
    public init(context: Context = .local()) {
        self.context = context
    }
    // MARK: - Properties
    public let context: Context

    // MARK: - Working with the tool
    public func generateXcodeproj(with options: XCProjectOptions) throws {
        // Ensure destination exists
        let destinationDirectory = options.swiftProjectDirectory
        do {
            try context.fileSystem.assertItem(at: destinationDirectory, is: .directory)
        } catch {
            throw "Cannot generate Xcode project at \(destinationDirectory.path) because the directory does not exist."
        }
        let arguments = options.arguments
        let task = try _packageProcess(arguments: arguments, currentDirectoryUrl: destinationDirectory)
        context.executor.execute(task: task)
        guard task.state.successfullyFinished else {
            throw "swift package failed"
        }
    }
    
    private func _packageProcess(arguments: [String], currentDirectoryUrl: AbsoluteUrl) throws -> Task {
        let arguments = ["package"] + arguments
        let task = try Task(commandName: "swift", arguments: arguments, currentDirectoryURL: currentDirectoryUrl, executableFinder: context.executableFinder)
        task.output = .pipeChannel()
        task.enableReadableOutputDataCapturing()
        return task
    }

    public func package(arguments: [String], currentDirectoryUrl: AbsoluteUrl) throws  {
        let task = try _packageProcess(arguments: arguments, currentDirectoryUrl: currentDirectoryUrl)
        context.executor.execute(task: task)
        guard task.state.successfullyFinished else {
            throw "Failed to run swift package because the process returned an error."
        }
    }
}

public extension SwiftPackageTool {
    public struct XCProjectOptions {
        public init(swiftProjectDirectory: AbsoluteUrl, xcprojectDestinationDirectory: AbsoluteUrl, xcconfigFileName: String?) {
            self.swiftProjectDirectory = swiftProjectDirectory
            self.xcprojectDestinationDirectory = xcprojectDestinationDirectory
            self.xcconfigFileName = xcconfigFileName
        }
        public let swiftProjectDirectory: AbsoluteUrl
        public let xcprojectDestinationDirectory: AbsoluteUrl
        public let xcconfigFileName: String?
        var arguments: [String] {
            let xcconfigArguments = xcconfigFileName.map { return ["--xcconfig-overrides", $0] } ?? []
            return ["generate-xcodeproj"] + xcconfigArguments + ["--output", xcprojectDestinationDirectory.path]
        }
    }
}

