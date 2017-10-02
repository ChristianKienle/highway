// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "highway",
    products: [
        .library(name: "HighwayCore", targets: ["HighwayCore"]),
        .library(name: "HWKit", targets: ["HWKit"]),
        .library(name: "Terminal", targets: ["Terminal"]),
        .library(name: "TestKit", targets: ["TestKit"]),
        .library(name: "FSKit", targets: ["FSKit"])
    ],
    dependencies: [],
    targets: [
        .target(name: "HWKit", dependencies: ["HighwayCore", "Terminal", "FSKit"]),
        .target(name: "HighwayCore", dependencies: ["Terminal", "FSKit"]),
        .target(name: "highway", dependencies: ["HWKit", "HighwayCore", "Terminal", "FSKit"]),
        .target(name: "Terminal", dependencies: []),
        .target(name: "TestKit", dependencies: ["HighwayCore"]),
        .target(name: "FSKit", dependencies: []),

        // Tests
        .testTarget(name: "HighwayCoreTests", dependencies: ["HighwayCore", "TestKit"]),
        .testTarget(name: "HWKitTests", dependencies: ["HWKit", "TestKit"]),
        .testTarget(name: "TerminalTests", dependencies: ["Terminal"]),
        .testTarget(name: "FSKitTests", dependencies: ["FSKit"])
    ],
    swiftLanguageVersions: [4]
)
