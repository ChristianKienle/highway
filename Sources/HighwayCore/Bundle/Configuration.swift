//
//  Configuration.swift
//  XCBuild
//
//  Created by Stijn on 26/07/2018.
//

import Foundation

public struct Configuration {
    // MARK: - Getting the default Configuration
    public static let standard: Configuration = {
        var config = Configuration()
        config.branch = env("HIGHWAY_BUNDLE_BRANCH", defaultValue: "master")
        return config
    }()
    // MARK: - Properties
    public var mainSwiftFileName = "main.swift"
    public var packageSwiftFileName = "Package.swift"
    public var xcodeprojectName = "_highway.xcodeproj"
    public var packageName = "_highway"
    public var targetName = "_highway"
    public var directoryName = "_highway"
    public var buildDirectoryName = ".build" // there is a bug in PM: generating the xcode project causes .build to be used every time...
    public var pinsFileName = "Package.resolved"
    // MARK: - Properties / Convenience
    public var xcconfigName = "config.xcconfig"
    public var gitignoreName = ".gitignore"
    
    // MARK: - Private Stuff
    public var branch = "master"
}
