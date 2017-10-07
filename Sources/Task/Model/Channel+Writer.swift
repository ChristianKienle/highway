import Foundation

public extension Channel {
    public class Writer {
        // MARK: - Properties
        public var didWrite: ((Data) -> Void)?
        public var didClose: (() -> Void)?
        private let fileHandle: FileHandle

        // MARK: - Init
        init(_ fileHandle: FileHandle) {
            self.fileHandle = fileHandle
        }
        
        // MARK: - Working with the Channel
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
    }
}
