import Foundation
import Url
import FileSystem

public struct Export {
    // MARK: - Properties
    public let url: Absolute
    public let ipaUrl: Absolute
    
    // MARK: - Init
    init(url: Absolute, fileSystem: FileSystem) throws {
        self.url = url
        let rootDir = fileSystem.directory(at: url)
        guard rootDir.isExistingDirectory else {
            throw "File at \(rootDir) is not a directory and thus no valid export."
        }
        guard let ipaUrl = (try fileSystem.directoryContents(at: url).first { $0.url.pathExtension == "ipa" }) else {
            throw "No ipa found"
        }
        self.ipaUrl = ipaUrl
    }
}
