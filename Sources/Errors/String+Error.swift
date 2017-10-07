import Foundation

extension String: Swift.Error { }
extension String: LocalizedError {
    public var errorDescription: String? { return self }
}
public typealias ErrorMessage = String
