import HighwayCore
import Security
import Foundation
import Terminal
import FSKit
import HWKit
import HighwayProject

enum CustomHighway: String, HighwayType {
    case test, build, release, updateVersion, release_then_upload, run
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
        case .run:
            return "Run and have fun."

        }
    }
}


let terminal = Terminal.shared
let keychain = Keychain()
let context = Context.local()
let highway = Highway(CustomHighway.self)
let cwd = getabscwd()

func _run(invocation: Invocation) throws {
    do {
        
        let run = SwiftRun.Tool()
        var options = SwiftRun.Options()
        options.executable = "highway"
        options.currentWorkingDirectory = cwd
        options.packageUrl = cwd
        options.arguments = Arguments()
        
        let result = try run.run(with: options)
        print(result.output)
    } catch {
        print(error.localizedDescription)
    }
}

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

    highway[.run] ==> _run
    highway[.test] ==> _test
    highway[.release].depends(on: [.test, .updateVersion, .build]) ==> _release
    highway[.build].depends(on: [.test]) ==> _build
    highway[.updateVersion] ==> _commitUpdateVersionAndTag
    highway[.release_then_upload].depends(on: [.release]) ==> _release_then_upload
    highway.onError = { error in _error(error) }
    highway.go()

