import Foundation

public struct Relative {
    public static let currentDirectory = Relative(".")
    public init(_ path: String)  {
        if [".", ""].contains(path) {
            _string = "."
            return
        }
       
        let components = path.components(separatedBy: "/").removingTrailingSlashComponent
        let componentsWithoutRedundancy = components.removingRedundantComponents
        // components has no repeating empty strings because we made sure that path
        // does not contain //

        _string = componentsWithoutRedundancy.joined(separator: "/")
    }
    private var _string: String
    public var asString: String { return _string }
}

extension Relative: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
     self.init(value)
    }
    public init(unicodeScalarLiteral value: String) {
        self.init(stringLiteral: value)
    }
    public init(extendedGraphemeClusterLiteral value: String) {
        self.init(stringLiteral: value)
    }
}

extension Relative: RawRepresentable {
    public var rawValue: String {
        return _string
    }
    
    public init?(rawValue: String) {
        self.init(stringLiteral: rawValue)
    }
}

extension Relative: Equatable {
    public static func ==(lhs: Relative, rhs: Relative) -> Bool {
        return lhs._string == rhs._string
    }
}

private func _error(for path: String, _ reason: String) -> Error {
    return "\(path) is not a relative path: \(reason)."
}

private extension Array where Iterator.Element == String {
    var removingTrailingSlashComponent: [String] {
        if last == "" {
            return Array(dropLast())
        }
        return self
    }
    var removingRedundantComponents: [String] {
        return enumerated().filter({ (index, component) -> Bool in
            guard startIndex != index else { // always use the first element (potentially a dot)
                return true
            }
            return component != "."
        }).map { $0.element }
    }
}
