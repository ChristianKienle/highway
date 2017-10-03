import Foundation
import FSKit

public class Task {
    // MARK: - Init
    public convenience init(commandName: String,
                            arguments: [String] = [],
                            environment: [String : String] = [:],
                            currentDirectoryURL: AbsoluteUrl,
                            executableFinder: ExecutableFinder) throws {
        guard let executableUrl = executableFinder.urlForExecuable(named: commandName) else {
            throw "Cannot create task named '\(commandName)': No executeable found."
        }
        self.init(executableURL: executableUrl, arguments: arguments, environment: environment, currentDirectoryURL: currentDirectoryURL)
    }
    
    public init(executableURL: AbsoluteUrl,
                arguments: [String] = [],
                environment: [String : String] = [:],
                currentDirectoryURL: AbsoluteUrl) {
        self.executableURL = executableURL
        self.arguments = arguments
        self.environment = environment
        self.currentDirectoryUrl = currentDirectoryURL
        self.state = .waiting
    }

    public struct Result {
        public static let success = Result(terminationReason: .exit, terminationStatus: EXIT_SUCCESS)
        public static let failure = Result(terminationReason: .exit, terminationStatus: EXIT_FAILURE)
        
        public let terminationReason: Process.TerminationReason
        public let terminationStatus: Int32
        public var isSuccess: Bool { return terminationStatus == EXIT_SUCCESS }
    }
    
    public enum State {
        case waiting
        case executing
        case finished(Result)
        public var result: Result? {
            if case let .finished(result) = self {
                return result
            }
            return nil
        }
        
        public var successfullyFinished: Bool {
            return result?.isSuccess ?? false
        }
    }
    
    // MARK: - Properties
    public var name: String { return executableURL.lastPathComponent }
    public var executableURL: AbsoluteUrl
    public var arguments: [String]
    public var environment: [String : String]
    public var currentDirectoryUrl: AbsoluteUrl
    fileprivate var io = TaskIO()
    public var input: TaskIOChannel {
        get { return io.input }
        set { io.input = newValue }
    }
    public var output: TaskIOChannel {
        get { return io.output }
        set { io.output = newValue }
    }
    public var error: TaskIOChannel {
        get { return io.error }
        set { io.error = newValue }
    }
    
    public var state: State
    public func enableReadableOutputDataCapturing() {
        io.enableReadableOutputDataCapturing()
    }
    public var readOutputData: Data? { return io.readOutputData }
    public var readOutputString: String? {
        guard let data = readOutputData else {
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
        return "\(name) \(arguments.joined(separator: " "))"
    }
}

extension Task.State: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case .waiting:
            return "WAITING"
        case .executing:
            return "EXECUTING"
        case .finished(let result):
            return result.debugDescription
        }
    }
}

extension Task.State: CustomStringConvertible {
    public var description: String {
        switch self {
        case .waiting:
            return "WAITING"
        case .executing:
            return "EXECUTING"
        case .finished(let result):
            return "[FINISHED] \(result.description)"
        }
    }
}

extension Task.Result: CustomStringConvertible {
    public var description: String {
        if terminationStatus == EXIT_SUCCESS {
            return "[OK]"
        }
        return "[ERROR] exit code: \(terminationStatus), reason: \(terminationReason.description)"
    }
}

extension Task.Result: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "terminationReason: \(terminationReason) - status: \(terminationStatus)"
    }
}

public class TaskIOChannelWriter {
    private let fileHandle: FileHandle
    
    init(fileHandle: FileHandle) {
        self.fileHandle = fileHandle
    }
    public func write(_ data: Data) {
        fileHandle.write(data)
        didWrite?(data)
    }
    public func write(_ string: String) {
        guard let data = string.data(using: .utf8) else {
            fatalError()
        }
        write(data)
    }
    public func close() {
        fileHandle.closeFile()
        didClose?()
    }
    public var didWrite: ((Data) -> Void)?
    public var didClose: (() -> Void)?
}

public class TaskIOChannelReader {
    private let fileHandle: FileHandle
    
    init(fileHandle: FileHandle) {
        self.fileHandle = fileHandle
    }
    public func withAvailableData(_ consumeData: (Data)->(Void)) {
        let data = fileHandle.availableData
        consumeData(data)
        didRead?(data)
    }
    public func close() {
        fileHandle.closeFile()
        didClose?()
    }
    public var didRead: ((Data) -> Void)?
    public var didClose: (() -> Void)?
}

public class TaskIOChannel {
    public let fileHandle: FileHandle?
    private let pipe: Pipe?
    private let writer: TaskIOChannelWriter
    private let reader: TaskIOChannelReader
    public class func fileHandle(_ fileHandle: FileHandle) -> TaskIOChannel {
        return self.init(fileHandle: fileHandle)
    }
    public class func pipeChannel() -> TaskIOChannel {
        return pipe(Pipe())
    }
    public class func pipe(_ pipe: Pipe) -> TaskIOChannel {
        return self.init(pipe: pipe)
    }
    
    required public init(fileHandle: FileHandle) {
        self.fileHandle = fileHandle
        self.pipe = nil
        self.writer = TaskIOChannelWriter(fileHandle: FileHandle.nullDevice)
        self.reader = TaskIOChannelReader(fileHandle: FileHandle.nullDevice)
        
    }
    required public init(pipe: Pipe) {
        self.fileHandle = nil
        self.pipe = pipe
        self.writer = TaskIOChannelWriter(fileHandle: pipe.fileHandleForWriting)
        self.reader = TaskIOChannelReader(fileHandle: pipe.fileHandleForReading)
    }
    deinit {
        pipe?.fileHandleForReading.readabilityHandler = nil
        pipe?.fileHandleForWriting.writeabilityHandler = nil
    }
    public var didRead: ((Data) -> Void)?
    public var didWrite: ((Data) -> Void)?
    public var writeabilityHandler: ((TaskIOChannelWriter) -> Void)? {
        didSet {
            if writeabilityHandler == nil {
                self.pipe?.fileHandleForWriting.writeabilityHandler = nil
                return
            }
            self.writer.didWrite = { data in
                self.didWrite?(data)
            }
            self.pipe?.fileHandleForWriting.writeabilityHandler = { [unowned self] handle in
                self.writeabilityHandler?(self.writer)
                return
            }
        }
    }
    public var readabilityHandler: ((TaskIOChannelReader) -> Void)? {
        didSet {
            if readabilityHandler == nil {
                self.pipe?.fileHandleForReading.readabilityHandler = nil
                return
            }
            self.reader.didRead = { data in
                self.didRead?(data)
            }
            self.pipe?.fileHandleForReading.readabilityHandler = { [unowned self] handle in
                self.readabilityHandler?(self.reader)
            }
        }
    }
    
    var asProcessChannel: Any {
        return (pipe ?? fileHandle) as Any
    }
    public static func ==(lhs: TaskIOChannel, rhs: TaskIOChannel) -> Bool {
        if let lp = lhs.pipe, let rp = rhs.pipe, lp == rp {
            return true
        }
        if let lfh = lhs.fileHandle, let rfh = rhs.fileHandle, lfh == rfh {
            return true
        }
        return false
    }
    
    public func writeToPipedFileHandle(_ data: Data) {
        pipe?.fileHandleForWriting.write(data)
    }
    public func writeToPipedFileHandle(_ string: String) {
        guard let data = string.data(using: .utf8) else {
            return
        }
        writeToPipedFileHandle(data)
    }
    
    public func withPipedFileHandleForWriting(_ doActions: (FileHandle)->()) {
        guard let fileHandle = pipe?.fileHandleForWriting else { return }
        doActions(fileHandle)
    }
}

public final class TaskIO {
    public var input: TaskIOChannel = .fileHandle(.standardInput)
    public var output: TaskIOChannel = .fileHandle(.standardOutput)
    public var error: TaskIOChannel = .fileHandle(.standardError)
    public func enableReadableOutputDataCapturing() {
        readOutputData = Data()
        output.readabilityHandler = { handle in
            handle.withAvailableData { available in
                self.readOutputData?.append(available)
            }
        }
    }
    public private(set) var readOutputData: Data?
}

extension Process.TerminationReason: CustomStringConvertible {
    public var description: String {
        switch self {
        case .exit:
            return "exit with error"
        case .uncaughtSignal:
            return "exit because of uncaught signal"
        }
    }
}
