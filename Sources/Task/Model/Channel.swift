import Foundation

public class Channel {
    // MARK: - Init
    required public init(_ fileHandle: FileHandle) {
        _fileHandle = fileHandle
        _pipe = nil
        writer = Writer(.nullDevice)
        reader = Reader(.nullDevice)
    }
    
    required public init(_ pipe: Pipe) {
        _fileHandle = nil
        _pipe = pipe
        writer = Writer(pipe.fileHandleForWriting)
        reader = Reader(pipe.fileHandleForReading)
    }
    
    // MARK: - Properties
    private let _fileHandle: FileHandle?
    private let _pipe: Pipe?
    private let writer: Writer
    private let reader: Reader
    var asProcessChannel: Any {
        return (_pipe ?? _fileHandle) as Any
    }
    public var didRead: ((Data) -> Void)?
    public var didWrite: ((Data) -> Void)?
    public var writeabilityHandler: ((Writer) -> Void)? {
        didSet {
            if writeabilityHandler == nil {
                _pipe?.fileHandleForWriting.writeabilityHandler = nil
                return
            }
            writer.didWrite = { self.didWrite?($0) }
            _pipe?.fileHandleForWriting.writeabilityHandler = { [unowned self] _ in
                self.writeabilityHandler?(self.writer)
                return
            }
        }
    }
    
    public var readabilityHandler: ((Reader) -> Void)? {
        didSet {
            if readabilityHandler == nil {
                _pipe?.fileHandleForReading.readabilityHandler = nil
                return
            }
            reader.didRead = { self.didRead?($0) }
            _pipe?.fileHandleForReading.readabilityHandler = { [unowned self] _ in
                self.readabilityHandler?(self.reader)
            }
        }
    }

    // MARK: - Convenience
    public class func standardInput() -> Channel {
        return .init(.standardInput)
    }
    
    public class func standardOutput() -> Channel {
        return .init(.standardOutput)
    }
    
    public class func pipe() -> Channel {
        return self.init(Pipe())
    }
    
    // MARK: - Working with the Channel
    public func withPipedFileHandleForWriting(_ doActions: (FileHandle)->()) {
        guard let fileHandle = _pipe?.fileHandleForWriting else { return }
        doActions(fileHandle)
    }

    // MARK: - Deinit
    deinit {
        _pipe?.fileHandleForReading.readabilityHandler = nil
        _pipe?.fileHandleForWriting.writeabilityHandler = nil
    }
}

extension Channel: Equatable {
    public static func ==(lhs: Channel, rhs: Channel) -> Bool {
        if let lp = lhs._pipe, let rp = rhs._pipe, lp == rp {
            return true
        }
        if let lfh = lhs._fileHandle, let rfh = rhs._fileHandle, lfh == rfh {
            return true
        }
        return false
    }
}
