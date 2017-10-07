import Foundation
import FileSystem
import Url
import Task
import Arguments

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
    
    private func _packageProcess(arguments: Arguments, currentDirectoryUrl: Absolute) throws -> Task {
        let arguments = ["package"] + arguments
        let task = try Task(commandName: "swift", provider: context.executableProvider)
        task.currentDirectoryUrl = currentDirectoryUrl
        task.arguments = arguments
        task.enableReadableOutputDataCapturing()
        return task
    }

    public func package(arguments: Arguments, currentDirectoryUrl: Absolute) throws  {
        let task = try _packageProcess(arguments: arguments, currentDirectoryUrl: currentDirectoryUrl)
        context.executor.execute(task: task)
        guard task.state.successfullyFinished else {
            throw "Failed to run swift package because the process returned an error."
        }
    }
}

public extension SwiftPackageTool {
    public struct XCProjectOptions {
        public init(swiftProjectDirectory: Absolute, xcprojectDestinationDirectory: Absolute, xcconfigFileName: String?) {
            self.swiftProjectDirectory = swiftProjectDirectory
            self.xcprojectDestinationDirectory = xcprojectDestinationDirectory
            self.xcconfigFileName = xcconfigFileName
        }
        public let swiftProjectDirectory: Absolute
        public let xcprojectDestinationDirectory: Absolute
        public let xcconfigFileName: String?
        var arguments: Arguments {
            let xcconfigArguments = xcconfigFileName.map { return ["--xcconfig-overrides", $0] } ?? []
            return Arguments(["generate-xcodeproj"] + xcconfigArguments + ["--output", xcprojectDestinationDirectory.path])
        }
    }
}

