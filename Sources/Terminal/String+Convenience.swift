import Foundation

extension String {
    public static let newline = "\n"
}

extension String {
    enum Ansi {
        static let CSI = "\u{001B}["
        static let BOLD = CSI + "1m"
        static let RESET = CSI + "0m"
    }
}

extension String {
    func indented(width: Int, using indentationString: String = " ") -> String {
        let indent = String(repeating: indentationString, count: width)
        return indent + self
    }
    public static func whitespace(_ width: Int = 0) -> String {
        return String(repeating: " " , count: width)
    }
}

