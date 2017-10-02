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
            return "Writes the current tag to CurrentVersion.swift"
        }
    }
}

let terminal = Terminal.shared
let keychain = Keychain()
let context = Context.local()
let highways = Highways(CustomHighway.self)

func _commitUpdateVersioAndTag() throws -> String {
    let nextVersion = try getNextVersion(context: context)
    try update(nextVersion: nextVersion, currentDirectoryURL: context.currentWorkingUrl, fileSystem: context.fileSystem)
    
    let git = try GitTool(context: context)
    let cwd = context.currentWorkingUrl
    try git.addEverything(at: cwd)
    try git.commit(with: "update", at: cwd)
    _ = try GitAutotag(context: context).autotag(at: cwd, dryRun: false)

    terminal.log(finishedTask: FinishedTask(title: "Updating current version\(String.elli)", resultInfo: nextVersion, color: .green))
    return nextVersion
}

func _error(_ error: Swift.Error) {
    print(error)
    exit(EXIT_FAILURE)
}

func _test() throws {
    try SwiftBuildSystem().test(executor: Context.local().executor)
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
    let cwd = context.currentWorkingUrl
    try git.push(at: cwd)
    try git.pushTags(at: cwd)
}

func _tagAndPush() throws {
    let git = try GitTool(context: context)
    let cwd = context.currentWorkingUrl
    try git.addEverything(at: cwd)
    try git.commit(with: "update", at: cwd)
    _ = try GitAutotag(context: context).autotag(at: cwd, dryRun: false)
    try git.push(at: cwd)
    try git.pushTags(at: cwd)
}

highways
    .highway(.test) { try _test() }
    .highway(.release, dependsOn: [.test, .updateVersion, .build]) { try _release() }
    .highwayWithResult(.build,  _build)
    .highwayWithResult(.updateVersion, _commitUpdateVersioAndTag)
    .highway(.release_then_upload, dependsOn: [.release], _release_then_upload)
    .onError { error in _error(error) }
    .go()

