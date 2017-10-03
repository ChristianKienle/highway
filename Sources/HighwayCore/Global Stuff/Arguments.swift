import Foundation

public struct Arguments {
    // MARK: - Convenience
    public static let empty = Arguments()
    
    // MARK: - Init
    public init(all: [String] = []) {
        self.all = all
    }
    
    // MARK: - Properties
    public let all: [String]
    public var remaining: [String] {
        return Array(all.dropFirst())
    }
}

extension Arguments: Equatable {
    public static func ==(l: Arguments, r: Arguments) -> Bool {
        return l.all == r.all
    }
}
