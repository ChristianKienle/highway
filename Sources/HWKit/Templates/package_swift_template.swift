import Foundation

func packageDescriptionTemplate(packageName: String, targetName: String, dependencyFromVersion: String, dependencyUrl: String) -> String {
    return """
    // swift-tools-version:4.0
    import PackageDescription
    
    let package = Package(
    name: "\(packageName)",
    dependencies: [
    .package(url: "\(dependencyUrl)", .upToNextMajor(from: "\(dependencyFromVersion)"))
    ],
    targets: [
    .target(name: "\(targetName)", dependencies: ["HighwayCore"], path: ".")
    ]
    )
    """
}

