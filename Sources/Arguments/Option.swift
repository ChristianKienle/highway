import Foundation
import Errors

public struct _Option {
    // MARK: - Init
    public init(_ name: String, value: String) {
        self.name = name
        self.value = value
    }

    public static func option(_ name: String, value: String) -> _Option {
        return self.init(name, value: value)
    }
    
    // MARK: - Properties
    public let name: String
    public let value: String

}

/// ========================================================================
/// A big "THANK YOU" to Jake Heiser:
///
/// GitHub: https://github.com/jakeheis
/// Web:    http://jakeheis.com
///
/// A lot of concepts, ideas and implementation details come from your great
/// framework 'SwiftCLI': https://github.com/jakeheis/SwiftCLI
///
/// When we meet someday I will buy you a 🍺 and pay for lot's of 🍱 🍣.
/// ========================================================================

public struct Options {
    public init(_ options: [Option]) {
        self._options = options
    }
    
    private var _options: [Option]
}
public protocol Option: class {
    var displayableDescription: String { get }
    var identifier: String { get }
    var names: [String] { get }
    func usage(padding: Int) -> String
}

public class Parser<O> {
    public init(_ object: O) {
        self.object = object
    }
    public func consume(_ args: [String]) throws {
        var arguments = args
        while let first = arguments.first {
            if let key = _boundKey(for: first) {
            
                arguments = try _consume(boundKey: key, args: arguments)
            }
        }
    }
    private func _boundKey(`for` name: String) -> BoundKey<Any>? {
        return boundKeys.first { $0.key.names.contains(name) }
    }
    private func _consume<ValueType>(boundKey: BoundKey<ValueType>, args: [String]) throws -> [String] {
        var result = args
        result.removeFirst()

        guard let rawValue = result.first else {
            throw "Invalid"
        }
        result.removeFirst()

        let anyValue = try boundKey.key.setValue(rawValue)
        guard let value = anyValue as? ValueType else {
            throw "Type error"
        }
        boundKey.binder(object, value)
        return Array(result)
    }
    public var object: O
    public typealias Binder = (O) -> (Void)
    func add<OptionType: Option>(_ option: OptionType, binder: @escaping Binder) {
        boundOptions.append(BoundOption(option: option, binder: binder))
    }
    private var boundOptions = [BoundOption]()
    struct BoundOption {
        let option: Option
        let binder: Binder
    }
    public func add<ValueType>(_ key: Key<ValueType>, binder: @escaping (O, ValueType) -> ()) {
        let anyBinder: ((_ object: O, _ value: Any) -> ()) = { object, value in
            let v = value as! ValueType
            binder(object, v)
        }
        boundKeys.append(BoundKey(key: key, binder: anyBinder))
    }
    private var boundKeys = [BoundKey<Any>]()
    struct BoundKey<ValueType> {
        let key: AnyKey
        let binder: (_ object: O, _ value: ValueType) -> ()
    }
}

extension Option {
    public func usage(padding: Int) -> String {
        let ws = String(repeating: " ", count: padding - identifier.count)
        return "\(identifier)\(ws)\(displayableDescription)"
    }
}

open class Flag: Option {
    public init(_ names: String..., description: String, isOn: Bool = false) {
        self.names = names
        self.displayableDescription = description
        self.isOn = isOn
    }
    public let names: [String]
    public let displayableDescription: String
    public var identifier: String {
        return names.joined(separator: ", ")
    }
    public var isOn = false
}

open class Key<Value: Keyable>: Option {
    public init(_ names: String..., description: String, value: Value? = nil) {
        self.names = names
        self.displayableDescription = description
        self.value = value
    }
    public var value: Value?
    
    public let displayableDescription: String
    public let names: [String]
    public var identifier: String {
        return names.joined(separator: ", ") + " <value>"
    }
    open func setValue(_ rawValue: String) throws -> Any {
        guard let value = Value.value(from: rawValue) else {
            throw ""
        }
        self.value = value
        return value
    }
}

public protocol AnyKey: Option {
    func setValue(_ value: String) throws -> Any
}
extension Key: AnyKey {
}

public protocol Keyable {
    static func value(from: String) -> Self?
}


extension String: Keyable {
    public static func value(from: String) -> String? {
        return from
    }
}

extension Int: Keyable {
    public static func value(from: String) -> Int? {
        return Int(from)
    }
}

extension Float: Keyable {
    public static func value(from: String) -> Float? {
        return Float(from)
    }
}

extension Double: Keyable {
    public static func value(from: String) -> Double? {
        return Double(from)
    }
}

extension RawRepresentable where Self: Keyable, RawValue == String {
    public static func value(from: String) -> Self? {
        return Self.init(rawValue: from)
    }
}
