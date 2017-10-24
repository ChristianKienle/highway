import HighwayCore
import Foundation
import Terminal
import Arguments
import HighwayProject
import Git
import Url

extension GitAutotag {
    func getNextVersion(cwd: Absolute) throws -> String {
        return try autotag(at: cwd, dryRun: true)
    }
}

enum CustomHighway: String, HighwayType {
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

final class App: Highway<CustomHighway> {
    override func setupHighways() {
        self[.test] ==> _test
        self[.release].depends(on: .test, .updateVersion, .build) ==> _release
        self[.build].depends(on: .test) ==> _build
        self[.updateVersion] ==> _commitUpdateVersionAndTag
        self[.release_then_upload].depends(on: .release) ==> _release_then_upload
        self.onError = _error
    }
    
    func _commitUpdateVersionAndTag() throws -> String {
        let nextVersion = try GitAutotag(system: system).getNextVersion(cwd: cwd)
        try update(nextVersion: nextVersion, currentDirectoryURL: cwd, fileSystem: context.fileSystem)
        
        try git.addAll(at: cwd)
        try git.commit(at: cwd, message: "Release \(nextVersion)")
        _ = try GitAutotag(system: system).autotag(at: cwd, dryRun: false)
        ui.message("New version: \(nextVersion)")
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
        let buildOptions = SwiftOptions(subject: .auto, projectDirectory: cwd, configuration: .release, verbose: true, additionalArguments: [])
        let plan = try swiftBuildSystem.executionPlan(with: buildOptions)
        return try swiftBuildSystem.execute(plan: plan)
    }
    
    func _release() throws {
        ui.message("Releasing...")
    }
    
    func _release_then_upload() throws {
        try git.pushToMaster(at: cwd)
        try git.pushTagsToMaster(at: cwd)
    }
}

App(CustomHighway.self).go()
