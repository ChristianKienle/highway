import HighwayCore
import Foundation
import FSKit

public class HighwayGoTool {
    // MARK: - Properties
    public let executableUrl: AbsoluteUrl
    public let context: Context
    private var fileSystem: FileSystem { return context.fileSystem }
    private var currentDirectoryURL: AbsoluteUrl { return context.currentWorkingUrl }

    // MARK: - Init
    public init(executableUrl: AbsoluteUrl, bundle: HighwayBundle.Configuration, context: Context) throws {
        self.executableUrl = executableUrl
        self.context = context
        
        // Validate
        try fileSystem.assertItem(at: executableUrl, is: .file)
        try fileSystem.assertItem(at: currentDirectoryURL, is: .directory)
    }
    
    // MARK: - Working with the Tool
    public func availableHighways() -> [RawHighway] {
        let task = Task(executableURL: executableUrl, arguments: ["listPublicHighwaysAsJSON"], currentDirectoryURL: currentDirectoryURL)
        task.output = .pipeChannel()
        task.enableReadableOutputDataCapturing()
        context.executor.execute(task: task)
        
        guard let output = task.readOutputData else {
            return []
        }
        
        let highways = try? Array(rawHighwaysData: output)
        return highways ?? []
    }
}



