import Foundation

public protocol Printable {
    func printableString(with options: Print.Options) -> String
}

public protocol Printer {
    func string(with options: Print.Options) -> String
}

public enum Print {
    public struct Options {
        public let width: Int
        static func defaultOptions() -> Options {
            return self.init(width: terminal_width())
        }
    }
}

private func terminal_width() -> Int {
    let env = ProcessInfo.processInfo.environment
    if let columns = env["COLUMNS"], let width = Int(columns) {
        return width
    }
    var ws = winsize()
    if ioctl(1, UInt(TIOCGWINSZ), &ws) == 0 {
        return Int(ws.ws_col)
    }
    return 80
}
