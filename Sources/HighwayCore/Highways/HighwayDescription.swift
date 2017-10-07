import Foundation
import Terminal

/// Describes a Highway.
public struct HighwayDescription: Codable {
    // MARK: - Properties
    public let name: String
    public let usage: String
    public var examples = [Example]()

    // MARK: - Init
    init(name: String, usage: String) {
        self.name = name
        self.usage = usage
    }
}

extension Example {
    func text(highway: String, indent: Text) -> Text {
        let line1 = indent + .text("- ") + .text(help + ":", color: .green) + .newline
        let line2 = indent + .whitespace(2) + .text("highway", color: .cyan) + .whitespace() + .text(highway, color: .none) + .whitespace() + .text(arguments ?? "", color: .none) + .newline
        return Text([line1, line2])
    }
}

extension Array where Iterator.Element == HighwayDescription {
    public func jsonString() throws -> String {
        let coder = JSONEncoder()
        let data = try coder.encode(self)
        guard let string = String(data: data, encoding: .utf8) else {
            throw "Failed to convert data to String."
        }
        return string
    }
    
    public init(rawHighwaysData data: Data) throws {
        let coder = JSONDecoder()
        let rawHighways = try coder.decode(type(of: self), from: data)
        self.init(rawHighways)
    }
    
    func text() -> Text {
        return Text(map { $0.text() })
    }
    
    public func printableString(with options: Print.Options) -> String {
        return text().printableString(with: options)
    }
}

public extension HighwayDescription {
    func text() -> Text {
        guard examples.isEmpty == false else {
            return Text()
        }
        let texts:[Text] = examples.map { $0.text(highway: self.name, indent: .whitespace(5)) + .newline }
        return Text(texts)
    }
}

