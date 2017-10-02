import Foundation

public enum FSError: Error {
    case doesNotExist
    case typeMismatch // expected item to be a file or directory but is the opposite in reality
    case other(Swift.Error)
    public var isDoesNotExistError: Bool {
        guard case .doesNotExist = self else { return false }
        return true
    }
}
