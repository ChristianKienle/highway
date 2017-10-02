import Foundation

public protocol Highway {
    func representsHighway(named name: String) -> Bool
    init?(highwayName: String)
    var highwayName: String { get }
    var usage: String { get }
}

extension Highway {
    var usage: String { return "" }
}

public extension Highway where Self: RawRepresentable, Self.RawValue == String {
    var highwayName: String {
        return rawValue
    }
    init?(highwayName: String) {
        self.init(rawValue: highwayName)
    }
    func representsHighway(named name: String) -> Bool {
        return highwayName == name
    }
    var usage: String { return "" }
}

