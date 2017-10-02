import HighwayCore
import FSKit

func getNextVersion(context: Context) throws -> String {
    let git = try GitAutotag(context: context)
    return try git.autotag(at: context.currentWorkingUrl, dryRun: true)
}

func update(nextVersion: String, currentDirectoryURL: AbsoluteUrl, fileSystem: FileSystem) throws {
    let versionFile = AbsoluteUrl(path: "Sources/highway/CurrentVersion.swift", relativeTo: currentDirectoryURL)
    guard fileSystem.file(at: versionFile).isExistingFile else {
        throw "Unable to update version number. '\(versionFile.debugDescription)' does not exist."
    }
    let code = "let CurrentVersion = \"\(nextVersion)\""
    guard let data = code.data(using: .utf8) else {
        fatalError("Unable to convert String ('\(code)') to Data.")
    }
    try fileSystem.writeData(data, to: versionFile)
}
