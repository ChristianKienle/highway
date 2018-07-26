import Url
import Arguments
import Task
import ZFile
import Result
import Errors

public class Altool {
    // MARK: - Properties
    public let system: SystemProtocol
    public let fileSystem: FileSystemProtocol
    private let provider: AltoolProvider
    
    // MARK: - Init
    public init(system: SystemProtocol, fileSystem: FileSystemProtocol) {
        self.system = system
        self.fileSystem = fileSystem
        self.provider = AltoolProvider(system: system, fileSystem: fileSystem)
    }
    
    // MARK: - Working with the Tool
    public enum Error: Swift.Error {
        case other(ErrorMessage)
        case executionError(ExecutionError)
    }
    public func execute(with options: Options) throws -> Bool {
        let task = try _task(with: options)
        
        return try system.execute(task)
    }
    
    // MARK: - Helper
    private func _task(with options: Options) throws ->Task {
        return Task(executable: try provider.executable(),
                    arguments: options.arguments,
                    currentDirectoryUrl: nil
        )
    }
}
private class AltoolProvider {
    private let system: SystemProtocol
    private let fileSystem: FileSystemProtocol
    
    init(system: SystemProtocol, fileSystem: FileSystemProtocol) {
        self.system = system
        self.fileSystem = fileSystem
    }
    
    func executable() throws -> FileProtocol {
        return try _developerDirectory().parentFolder().file(named: "Applications/Application Loader.app/Contents/Frameworks/ITunesSoftwareService.framework/Versions/A/Support/altool")
    }
    
    /// for example: Applications/Xcode.app/Contents/Applications/Application Loader.app/Contents/Frameworks/ITunesSoftwareService.framework/Versions/A/Support/altool
    private func _developerDirectory() throws -> FolderProtocol {
        let defaultDir = try Folder(path: "/Applications/Xcode.app/Contents/Developer")
        do {
            let xcrun = try system.task(named: "xcrun")
            xcrun.arguments.append(contentsOf: ["xcode-select", "-p"])
            xcrun.enableReadableOutputDataCapturing()
            try system.execute(xcrun)
            guard let developerDirectory = xcrun.trimmedOutput else {
                return defaultDir
            }
            return try Folder(path: developerDirectory)
        } catch {
            return defaultDir
        }
    }
    
}
