// swift-tools-version:4.0
import PackageDescription
import Foundation

let package = Package(
    name: "_highway",
    dependencies: [
        .package(
            url: ProcessInfo.processInfo.environment["HIGHWAY_REPOSITORY"] ??
                URL(fileURLWithPath: NSHomeDirectory() + "/.highway/highway").absoluteString,
            .branch(ProcessInfo.processInfo.environment["HIGHWAY_BRANCH"] ?? "master"))
    ],
    targets: [
        .target(name: "_highway", dependencies: ["Url", "Deliver", "HighwayProject", "XCBuild", "HighwayCore", "FileSystem"], path: ".")
    ]
)
