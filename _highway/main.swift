import HighwayCore
import Security
import Foundation
import Terminal
import FSKit

enum CustomHighway: String, Highway {
    case test, build, release, updateVersion, release_then_upload
    var usage: String {
        switch self {
        case .test:
            return "Executed all unit and integration tests"
        case .build:
            return "Builds highway"
        case .release:
            return "Creates and publishes a new release"
        case .release_then_upload:
            return "Creates and publishes a new release, then uploads it."
        case .updateVersion:
            return "Writes the next tag to CurrentVersion.swift and tags the current state."
        }
    }
}

let terminal = Terminal.shared
let keychain = Keychain()
let context = Context.local()
let highways = Highways(CustomHighway.self)
let cwd = getabscwd()
func _commitUpdateVersionAndTag() throws -> String {
    let nextVersion = try getNextVersion(cwd: cwd, context: context)
    try update(nextVersion: nextVersion, currentDirectoryURL: cwd, fileSystem: context.fileSystem)
    
    let git = try GitTool(context: context)
    try git.addAll(at: cwd)
    try git.commit(at: cwd, message: "Release \(nextVersion)")
    _ = try GitAutotag(context: context).autotag(at: cwd, dryRun: false)
    terminal.log("New version: \(nextVersion)")
    return nextVersion
}

func _error(_ error: Swift.Error) {
    print(error)
    exit(EXIT_FAILURE)
}

func _test() throws {
    try SwiftBuildSystem().test()
}

func _build() throws -> SwiftBuildSystem.Artifact {
    let swiftBuildSystem = SwiftBuildSystem(context: context)
    let buildOptions = SwiftOptions(subject: .auto, projectDirectory: getabscwd(), configuration: .release, verbose: true, additionalArguments: [])
    let plan = try swiftBuildSystem.executionPlan(with: buildOptions)
    return try swiftBuildSystem.execute(plan: plan)
}

func _release() throws {
    Terminal.shared.log("Releasing...")
}

func _release_then_upload() throws {
    let git = try GitTool(context: context)
    try git.pushToMaster(at: cwd)
    try git.pushTagsToMaster(at: cwd)
}

highways
    .highway(.test, _test)
    .highway(.release, dependsOn: [.test, .updateVersion, .build], _release)
    .highway(.build,  _build)
    .highway(.updateVersion, _commitUpdateVersionAndTag)
    .highway(.release_then_upload, dependsOn: [.release], _release_then_upload)
    .onError { error in _error(error) }
    .go()

