import Foundation

public extension Channel {
    public class Reader {
        // MARK: - Properties
        private let fileHandle: FileHandle
        public var didRead: ((Data) -> Void)?
        public var didClose: (() -> Void)?

        // MARK: - Init
        init(_ fileHandle: FileHandle) {
            self.fileHandle = fileHandle
        }

        // MARK: - Working with the Channel
        public func withAvailableData(_ consumeData: (Data)->(Void)) {
            let data = fileHandle.availableData
            consumeData(data)
            didRead?(data)
        }
        
        public func close() {
            fileHandle.closeFile()
            didClose?()
        }
    }
}
