import FileSystem
import Url

func update(nextVersion: String, currentDirectoryURL: Absolute, fileSystem: FileSystem) throws {
    let versionFile = Absolute(path: "Sources/highway/CurrentVersion.swift", relativeTo: currentDirectoryURL)
    try fileSystem.assertItem(at: versionFile, is: .file)

    let code = "let CurrentVersion = \"\(nextVersion)\""
    try fileSystem.writeString(code, to: versionFile)
}
