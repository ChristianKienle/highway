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
    public var verbose = false
    
    public func log(_ text: String) {
        rawLog("\r" + self.promptTemplate.terminalString + text + "\n")
    }
    private func rawLog(_ text: String) {
        _sync {
            stream.write(text)
        }
    }
    private func rawLogNl(_ text: String) {
        _sync {
            stream.write("\r" + text + "\n")
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

fileprivate extension Terminal {
    func _withPrompt(_ text: String) -> String {
        return promptTemplate.terminalString + text
    }
}

extension Terminal: UIProtocol {
    
    public func error(_ text: String) {
        rawLogNl(_withPrompt(text))
    }
    public func success(_ text: String) {
        rawLogNl(_withPrompt(text))
    }
    
    public func message(_ text: String) {
        rawLogNl(_withPrompt(text))
    }
    
    public func verbose(_ text: String) {
        guard self.verbose else { return }
        rawLogNl(_withPrompt(text))
    }
    public func print(_ printable: Printable) {
        rawLog(printable.printableString(with: .defaultOptions()))
    }
    
    public func verbosePrint(_ printable: Printable) {
        guard self.verbose else { return }
        rawLog(printable.printableString(with: .defaultOptions()))
    }

}


