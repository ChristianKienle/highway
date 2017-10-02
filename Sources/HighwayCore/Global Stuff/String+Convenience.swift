import Foundation

public extension String {
    public static let elli = "…"
}

public extension String {
    public func padded(to maxLength: Int) -> String {
        let delta = maxLength - lengthOfBytes(using: .utf8)
        guard delta > 0 else {
            return self
        }
        let padding = String(repeating: " ", count: delta)
        return self + padding
    }
}
