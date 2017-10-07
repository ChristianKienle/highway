import Foundation

extension String: Printable {
    public func printableString(with options: Print.Options) -> String {
        return self
    }
}

extension SubText: Printable {
    public func printableString(with options: Print.Options) -> String {
        return terminalString
    }
}

extension Text: Printable {
    public func printableString(with options: Print.Options) -> String {
        return terminalString
    }
}
