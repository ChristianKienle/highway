import Foundation

public struct Example: Codable {
    // MARK: - Properties
    public var arguments: String?
    public var help: String
    
    // MARK: - Init
    public init(arguments: String?, help: String) {
        self.arguments = arguments
        self.help = help
    }
}

public protocol HighwayType: Hashable {
    // MARK: - Init
    init?(name: String)

    // MARK: - Properties
    var name: String { get }
    var usage: String { get }
    var examples: [Example] { get }
}

extension HighwayType {
    var examples: [Example] {
        return []
    }
}

/// Default Implementation
extension HighwayType {
    public var hashValue: Int { return name.hashValue }
    var usage: String { return "No usage provided." }
}

/// Default Implementation for RawRepresentable (enums in most cases)
public extension HighwayType where Self: RawRepresentable, Self.RawValue == String {
    // MARK: - Init
    init?(name: String) {
        self.init(rawValue: name)
    }
    
    // MARK: - Properties
    var name: String { return rawValue }
    var usage: String { return "No usage provided for '\(name)'." }
    
    /// By default we use `name` and `usage` to create an example instance.
    /// Renders like this:
    /// - $example0.usage
    ///   highway $name $example0.$arguments
    ///
    ///   $example1.usage
    ///   highway $name $example1.arguments
    var examples: [Example] {
        return [Example(arguments: nil, help: usage)]
    }
}

