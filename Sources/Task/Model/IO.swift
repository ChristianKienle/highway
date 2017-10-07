import Foundation

public final class IO {
    // MARK: - Properties
    public var input: Channel = .standardInput()
    public var output: Channel = .standardOutput()
    public private(set) var readOutputData: Data?

    // MARK: - Convenience
    public func enableReadableOutputDataCapturing() {
        readOutputData = Data()
        output = .pipe()
        output.readabilityHandler = { handle in
            handle.withAvailableData { available in
                self.readOutputData?.append(available)
            }
        }
    }
}

