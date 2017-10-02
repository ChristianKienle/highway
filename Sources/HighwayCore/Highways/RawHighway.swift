import Foundation

public struct RawHighway: Codable {
    public init(name: String, usage: String) {
        self.name = name
        self.usage = usage
    }
    public var name: String
    public var usage: String
}

extension Array where Iterator.Element == RawHighway {
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
}
