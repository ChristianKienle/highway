import Foundation

public struct Termination {
    // MARK: - Types
    public typealias Reason = Process.TerminationReason

    // MARK: - Convenience
    public static let success = Termination(reason: .exit, status: EXIT_SUCCESS)
    public static let failure = Termination(reason: .exit, status: EXIT_FAILURE)
    
    // MARK: - Init
    public init(describing process: Process) {
        self.init(reason: process.terminationReason, status: process.terminationStatus)
    }
    
    init(reason: Reason, status: Int32) {
        self.reason = reason
        self.status = status
    }
    // MARK: - Properties
    public let reason: Reason
    public let status: Int32
    public var isSuccess: Bool { return status == EXIT_SUCCESS }
}

extension Termination: CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String {
        return "[\(isSuccess ? "SUCCESS" : "ERROR")] Status: \(status), Reason: \(reason)"
    }
    public var debugDescription: String { return description }
}

extension Termination: Equatable {
    public static func ==(lhs: Termination, rhs: Termination) -> Bool {
        return lhs.status == rhs.status && lhs.reason == rhs.reason
    }
}

extension Process.TerminationReason: CustomStringConvertible {
    public var description: String {
        switch self {
        case .exit: return "Exited normally."
        case .uncaughtSignal: return "Exited due to an uncaught signal."
        }
    }
}
