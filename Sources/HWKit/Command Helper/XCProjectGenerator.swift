import HighwayCore
import FileSystem
import Url
import SwiftTool

// MARK: - Types
public typealias GeneratedXCProject = XcodeprojOptions

public class XCProjectGenerator {
    // MARK: - Init
    public init(swift: SwiftTool, bundle: HighwayBundle) {
        self.swift = swift
        self.bundle = bundle
    }
    
    // MARK: - Properties
    public let swift: SwiftTool
    public let bundle: HighwayBundle
    
    // MARK: - Command
    public func generate() throws -> Result {
        let xcconfigName = bundle.configuration.xcconfigName
        let projectUrl = bundle.xcodeprojectUrl
        let options = XcodeprojOptions(swiftProject: bundle.url, outputDir: projectUrl, xcconfig: xcconfigName)
        try swift.generateProject(with: options)
        return Result(projectUrl: projectUrl)
    }
}

public extension XCProjectGenerator {
    public struct Result {
        init(projectUrl: Absolute) {
            openCommand = "open \(projectUrl.path)"
        }
        public let openCommand: String
    }
}
