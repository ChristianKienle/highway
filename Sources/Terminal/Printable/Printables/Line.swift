import Foundation

public struct Line {
    public init(prompt: Prompt, text: Text) {
        self.prompt = prompt
        self.text = text
    }
    public let prompt: Prompt
    public let text: Text
}

extension Line: Printable {
    public func printableString(with options: Print.Options) -> String {
        return prompt.terminalString + text.terminalString
    }
}
