import Foundation
import ZFile
import Arguments
import SourceryAutoProtocols

public protocol TaskProtocol: AutoMockable {

    // sourcery:inline:Task.AutoGenerateProtocol
    var name: String { get }
    var executable: FileProtocol { get set }
    var arguments: Arguments { get set }
    var environment: [String : String] { get set }
    var currentDirectoryUrl: FolderProtocol? { get set }
    var input: Channel { get set }
    var output: Channel { get set }
    var state: State { get set }
    var capturedOutputData: Data? { get }
    var readOutputString: String? { get }
    var trimmedOutput: String? { get }
    var capturedOutputString: String? { get }
    var successfullyFinished: Bool { get }
    var description: String { get }

    func enableReadableOutputDataCapturing()
    func throwIfNotSuccess(_ error: Swift.Error) throws 
    // sourcery:end
}

public class Task: TaskProtocol, AutoGenerateProtocol {
    
    // MARK: - Init
    public convenience init(commandName: String, arguments: Arguments = .empty, currentDirectoryUrl: FolderProtocol? = nil, provider: ExecutableProvider) throws {
       
        self.init(executable: try provider.executable(with: commandName),
                  arguments: arguments,
                  currentDirectoryUrl: currentDirectoryUrl
        )
    }

    public init(executable: FileProtocol, arguments: Arguments = .empty, currentDirectoryUrl: FolderProtocol? = nil) {
        self.executable = executable
        self.state = .waiting
        self.arguments = arguments
        self.currentDirectoryUrl = currentDirectoryUrl
    }

    // MARK: - Properties
    public var name: String { return executable.name }
    public var executable: FileProtocol
    public var arguments = Arguments.empty
    public var environment = [String : String]()
    public var currentDirectoryUrl: FolderProtocol?
    
    public var input: Channel {
        get { return io.input }
        set { io.input = newValue }
    }
    public var output: Channel {
        get { return io.output }
        set { io.output = newValue }
    }
    
    public var state: State
    public func enableReadableOutputDataCapturing() {
        io.enableReadableOutputDataCapturing()
    }
    public var capturedOutputData: Data? { return io.readOutputData }

    public var readOutputString: String? {
        return capturedOutputString
    }
    public var trimmedOutput: String? {
        return capturedOutputString?.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    public var capturedOutputString: String? {
        guard let data = capturedOutputData else {
            return nil
        }
        return String(data: data, encoding: .utf8)
    }

    public var successfullyFinished: Bool {
        return state.successfullyFinished
    }
    
    public func throwIfNotSuccess(_ error: Swift.Error) throws {
        guard successfullyFinished else {
            throw "🛣 🔥 \(name) with customError: \n \(error).\n"
        }
    }
    
    // MARK: - Private
    
    private var io = IO()
    
}

extension Task: CustomStringConvertible {
    public var description: String {
        return "\(name) \(arguments)"
    }
}
