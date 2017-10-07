import Foundation

func packageDescriptionTemplate(packageName: String, targetName: String, branch: String, dependencyUrl: String) -> String {
    return """
    // swift-tools-version:4.0
    import PackageDescription
    import Foundation

    let package = Package(
        name: "\(packageName)",
        dependencies: [
            .package(
                url: ProcessInfo.processInfo.environment["HIGHWAY_REPOSITORY"] ??
                    URL(fileURLWithPath: NSHomeDirectory() + "/.highway/highway").absoluteString,
                .branch(ProcessInfo.processInfo.environment["HIGHWAY_BRANCH"] ?? "master"))
        ],
        targets: [
            .target(name: "\(targetName)", dependencies: ["Deliver", "HighwayProject", "XCBuild", "HighwayCore", "FileSystem"], path: ".")
        ]
    )
    """    
}
