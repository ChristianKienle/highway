import Foundation

public extension Data {
    public init(_ string: String) {
        self = string.data(using: .utf8)!
    }
}
