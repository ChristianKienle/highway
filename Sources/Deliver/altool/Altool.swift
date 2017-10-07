import Url
import Arguments
import Task
import FileSystem
import Result
import Errors
public class Altool {
    // MARK: - Properties
    public let system: System
    public let fileSystem: FileSystem
    private let provider: AltoolProvider
    
    // MARK: - Init
    public init(system: System, fileSystem: FileSystem) {
        self.system = system
        self.fileSystem = fileSystem
        self.provider = AltoolProvider(system: system, fileSystem: fileSystem)
    }
    
    // MARK: - Working with the Tool
    public enum Error: Swift.Error {
        case other(ErrorMessage)
        case executionError(ExecutionError)
    }
    public func execute(with options: Options) -> Result<Void, Error> {
        let taskResult = _task(with: options)
        switch taskResult {
        case .success(let task):
            switch system.execute(task) {
            case .success:
                return .success(())
            case .failure(let executionError):
                return .failure(.executionError(executionError))
            }
        case .failure(let errorMessage):
            return .failure(.other(errorMessage))
        }
    }
    
    // MARK: - Helper
    private func _task(with options: Options) -> Result<Task, ErrorMessage> {
        let url = provider.executableUrl()
        return url.map { return Task(executableUrl: $0, arguments: options.arguments, currentDirectoryUrl: nil) }
    }
}
private class AltoolProvider {
    private let system: System
    private let fileSystem: FileSystem
    
    init(system: System, fileSystem: FileSystem) {
        self.system = system
        self.fileSystem = fileSystem
    }
    
    func executableUrl() -> Result<Absolute, ErrorMessage> {
        let url = _developerDirectory().parent.appending("Applications/Application Loader.app/Contents/Frameworks/ITunesSoftwareService.framework/Versions/A/Support/altool")
        guard fileSystem.file(at: url).isExistingFile else {
            return .failure("altool not found in '\(url)'.")
        }
        return .success(url)
    }
    
    /// for example: Applications/Xcode.app/Contents/Applications/Application Loader.app/Contents/Frameworks/ITunesSoftwareService.framework/Versions/A/Support/altool
    private func _developerDirectory() -> Absolute {
        let defaultDir: Absolute = "/Applications/Xcode.app/Contents/Developer"
        do {
            let xcrun = try system.task(named: "xcrun").dematerialize()
            xcrun.arguments.append(contentsOf: ["xcode-select", "-p"])
            xcrun.enableReadableOutputDataCapturing()
            try system.execute(xcrun).assertSuccess()
            guard let developerDirectory = xcrun.trimmedOutput else {
                return defaultDir
            }
            return Absolute(developerDirectory)
        } catch {
            return defaultDir
        }
    }
    
}
