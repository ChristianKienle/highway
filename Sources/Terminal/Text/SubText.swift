import Foundation

public struct SubText {
    // MARK: - Convenience
    public static let empty = SubText()
    public static let newline = SubText(.newline)

    // MARK: - Init
    public init(_ text: String = "", color: Color = .none, bold: Bool = false) {
        self.text = text
        self.color = color
        self.bold = bold
    }
    
    // MARK: - Properties
    public var text: String
    public var color: Color
    public var bold: Bool
    public var length: Int { return text.lengthOfBytes(using: .utf8) }
    public var terminalString: String {
        // Strings without any styling have to be printed as raw strings for some reason
        if bold == false && color == .none {
            return text
        }
        let _bold = bold ? String.Ansi.BOLD : ""
        return String.Ansi.RESET + color.terminalString + _bold + text + String.Ansi.RESET
    }
}

public extension SubText {
    public init(whitespaceWidth width: Int = 0) {
        self.init(String.whitespace(width))
    }
    public static func whitespace(_ width: Int = 1) -> SubText {
        return SubText(whitespaceWidth: width)
    }
}
