import Foundation

class FileStream {
    // MARK: - Init
    init(fd: UnsafeMutablePointer<FILE>) {
        self.fd = fd
    }
    
    // MARK: - Properties
    private let queue = DispatchQueue(label: "de.christian-kienle.highway.FileStream")
    private let fd: UnsafeMutablePointer<FILE>
    
    // MARK: - Working with the Stream
    func write(_ text: String) {
        queue.sync {
            fputs(text, fd)
            fflush(fd)
        }
    }
}
