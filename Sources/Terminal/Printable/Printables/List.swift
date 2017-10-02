import Foundation

public struct List {
    // MARK: - Init
    private init(lines: [Line] = []) {
        self.lines = lines
    }
    public init(lines rawLines: [String] = []) {
        lines = []
        rawLines.forEach { self.append($0) }
    }
    // MARK: - Properties
    private var lines: [Line]
    
    // MARK: - Working with the List
    public mutating func append(_ rawText: String) {
        lines.append(Line(prompt: .normal, text: Text(rawText)))
    }
}

extension List: Printable {
    public func printableString(with options: Print.Options) -> String {
        return lines.map { $0.printableString(with: options) }.joined(separator: .newline)
    }
}
