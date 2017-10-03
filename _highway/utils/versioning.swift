import HighwayCore
import FSKit

func getNextVersion(cwd: AbsoluteUrl, context: Context) throws -> String {
    let git = try GitAutotag(context: context)
    return try git.autotag(at: cwd, dryRun: true)
}

func update(nextVersion: String, currentDirectoryURL: AbsoluteUrl, fileSystem: FileSystem) throws {
    let versionFile = AbsoluteUrl(path: "Sources/highway/CurrentVersion.swift", relativeTo: currentDirectoryURL)
    try fileSystem.assertItem(at: versionFile, is: .file)

    let code = "let CurrentVersion = \"\(nextVersion)\""
    try fileSystem.writeString(code, to: versionFile)
}
