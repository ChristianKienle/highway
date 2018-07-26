import Foundation
import ZFile
import Arguments

public class Task {
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
    fileprivate var io = IO()
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
    @available(*, unavailable, renamed: "capturedOutputData")
    public var readOutputData: Data? { return io.readOutputData }
    public var capturedOutputData: Data? { return io.readOutputData }

    @available(*, unavailable, renamed: "capturedOutputString")
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
    public func throwIfNotSuccess(_ error: Swift.Error? = nil) throws {
        guard successfullyFinished else {
            if let error = error {
                throw error
            }
            throw "\(name) not finished successfully."
        }
    }
}

extension Task: CustomStringConvertible {
    public var description: String {
        return "\(name) \(arguments)"
    }
}
