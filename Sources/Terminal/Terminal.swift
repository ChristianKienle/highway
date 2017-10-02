import Foundation

// TODO: Read http://www.lihaoyi.com/post/BuildyourownCommandLinewithANSIescapecodes.html
// TODO: Then rewrite this class.
public class Terminal {
    // MARK: - Global
    public static let shared = Terminal()
    
    // MARK: - Init
    public init() { }
    
    // MARK: - Properties
    private let queue = DispatchQueue(label: "de.christian-kienle.highway.terminal")
    private var promptTemplate = Prompt.normal
    private let stream = FileStream(fd: stdout)

    public func log(_ text: String) {
        _sync {
            let msg = "\r" + self.promptTemplate.terminalString + text + "\n"
            stream.write(msg)
        }
    }
    
    // MARK: - Write Stuff
    public func write(_ printer: Printer) {
        _sync {
            self._write(printer)
        }
    }
    private func _write(_ printer: Printer) {
        let string = printer.string(with: .defaultOptions())
        stream.write(string)
    }
    
    public func write(_ printable: Printable) {
        _sync {
            self._write(printable)
        }
    }
    
    private func _write(_ printable: Printable) {
        let string = printable.printableString(with: .defaultOptions())
        stream.write(string)
    }
    
    // MARK: - Working with the Queue
    /// Execute handler on the terminal queue
    private func _sync(_ handler: ()->()) {
        queue.sync {
            handler()
        }
    }
}

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

