import Foundation

public enum State {
    case waiting
    case executing
    case terminated(Termination)
    
    // MARK: - Properties
    public var termination: Termination? {
        if case let .terminated(_termination) = self { return _termination }
        return nil
    }
    public var successfullyFinished: Bool { return termination?.isSuccess ?? false }
}

extension State: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case .waiting:
            return "WAITING"
        case .executing:
            return "EXECUTING"
        case .terminated(let termination):
            return termination.debugDescription
        }
    }
}

extension State: CustomStringConvertible {
    public var description: String {
        switch self {
        case .waiting: return "[WAITING]"
        case .executing: return "[EXECUTING]"
        case .terminated(let termination): return "[TERMINATED] \(termination)"
        }
    }
}
