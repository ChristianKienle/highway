import Foundation

public struct Prompt {
    // MARK: - Convenience
    public static let success = Prompt(color: .green)
    public static let error = Prompt(color: .red)
    public static let normal = Prompt(color: .none)
    public static let warning = Prompt(color: .yellow)

    // MARK: - Init
    public init(color: Color) {
        self.color = color
        strings = Text(repeating: .promptCharacter(with: color), count: 3)
    }

    // MARK: - Properties
    public var length: Int { return strings.length }
    public var strings: Text
    public var terminalString: String { return strings.terminalString + " " }
    public let color: Color
    
    // MARK: - Working with the Prompt
    public mutating func set(color: Color, forCharacterAt index: Int) {
        strings.setColor(self.color)
        strings[index] = .promptCharacter(with: color)
    }
}

private extension SubText {
    static func promptCharacter(with color: Color = .none) -> SubText {
        return SubText("❯", color: color)
    }
}
