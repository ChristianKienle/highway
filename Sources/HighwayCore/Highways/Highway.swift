import Foundation

public protocol Highway {
    // MARK: - Init
    init?(highwayName: String)

    // MARK: - Properties
    var highwayName: String { get }
    var usage: String { get }

    // MARK: Concenienve
    func representsHighway(named name: String) -> Bool
}

/// Default Implementation
extension Highway {
    var usage: String { return "No usage provided." }
}

/// Default Implementation for RawRepresentable (enums in most cases)
public extension Highway where Self: RawRepresentable, Self.RawValue == String {
    init?(highwayName: String) {
        self.init(rawValue: highwayName)
    }
    
    var highwayName: String {
        return rawValue
    }
    
    var usage: String {
        return "No usage provided for '\(highwayName)'."
    }
    
    func representsHighway(named name: String) -> Bool {
        return highwayName == name
    }
}

