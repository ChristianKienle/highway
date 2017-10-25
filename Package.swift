// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "highway",
    products: [
        // Used by highway projects, aggregates lots of dependencies and offers a nicer api
        .library(name: "HighwayProject", targets: ["HighwayProject"]),
        .library(name: "POSIX", targets: ["POSIX"]),
        .library(name: "Git", targets: ["Git"]),
        .library(name: "Deliver", targets: ["Deliver"]),
        .library(name: "Arguments", targets: ["Arguments"]),
        .library(name: "Errors", targets: ["Errors"]),
        .library(name: "FileSystem", targets: ["FileSystem"]),
        .library(name: "Url", targets: ["Url"]),
        .library(name: "Result", targets: ["Result"]),
        .library(name: "Task", targets: ["Task"]),
        .library(name: "XCBuild", targets: ["XCBuild"]),
        .library(name: "HighwayCore", targets: ["HighwayCore"]),
        .library(name: "HWKit", targets: ["HWKit"]),
        .library(name: "Keychain", targets: ["Keychain"]),
        .library(name: "Terminal", targets: ["Terminal"]),
        .library(name: "TestKit", targets: ["TestKit"]),
        .library(name: "All",
                 targets: [
                   "HighwayProject",
                   "POSIX",
                   "Deliver",
                   "Arguments",
                   "Errors",
                   "FileSystem",
                   "Url",
                   "Result",
                   "Task",
                   "XCBuild",
                   "HighwayCore",
                   "HWKit",
                   "Terminal",
                   "TestKit", "Keychain", "Git"]
        )
    ],
    targets: [
        .target(name: "HighwayProject", dependencies: ["SwiftTool", "Git", "POSIX", "Deliver", "HighwayCore", "Terminal", "FileSystem", "XCBuild", "Url", "Task"], path: "./Sources/HighwayProject"),
        
        // Task: We use the security command line tool to talk to the Keychain.
        // Arguments: Task => Arguments
        // Errors: We want to throw Errors
        .target(name: "Keychain", dependencies: ["Task", "Arguments", "Errors"]),
        .target(name: "Url"),
        .target(name: "Errors"),
        .target(name: "Arguments", dependencies: ["Errors"]),
        .target(name: "Result"),
        .target(name: "Terminal"),
        .target(name: "Git", dependencies: ["Arguments", "Url", "Task", "Errors", "Terminal"]),
        .target(name: "POSIX", dependencies: ["Url"]),

        .target(name: "Deliver", dependencies: ["POSIX", "Task", "Url", "Result", "Errors", "Arguments", "FileSystem"]),
        .target(name: "SwiftTool", dependencies: ["POSIX", "Task", "Url", "Result", "Errors", "Arguments", "FileSystem"]),

        // Url: Needs to have a concept of absolute/relative files/urls.
        // Result: SHOULD return Results instead of throwing. FIXME!
        // Errors: Throws Errors.
        .target(name: "FileSystem", dependencies: ["POSIX", "Url", "Result", "Errors"]),
        .target(name: "HWKit", dependencies: ["SwiftTool", "Git", "POSIX", "HighwayCore", "Terminal", "FileSystem", "Arguments"]),
        .target(name: "HighwayCore", dependencies: ["POSIX", "Terminal", "FileSystem", "Task", "Url", "Arguments"]),
        .target(name: "highway", dependencies: ["Git", "POSIX", "HighwayProject", "HWKit", "HighwayCore", "Terminal", "FileSystem", "Arguments"]),        
        .target(name: "XCBuild", dependencies: ["POSIX", "Url", "FileSystem", "Task", "Arguments"]),

        // Url: In the end, a Task is always using some kind of files on disk.
        // FileSystem: The framework checks (in certain cases) the existence of files.
        //             For example the current working directory of a Task before it is executed.
        // Arguments: A Task has Arguments.
        // Terminal: We have to log
        .target(name: "Task", dependencies: ["Terminal", "Url", "FileSystem", "Errors", "Result", "Arguments"]),
        .target(name: "TestKit", dependencies: ["Git", "POSIX", "HighwayCore", "Url", "Task"]),

        // Tests
        .testTarget(name: "DeliverTests", dependencies: ["FileSystem", "Arguments"]),
        .testTarget(name: "POSIXTests", dependencies: ["POSIX", "Url"]),
        .testTarget(name: "FileSystemTests", dependencies: ["TestKit"]),
        .testTarget(name: "HighwayCoreTests", dependencies: ["HighwayCore", "TestKit", "Arguments"]),
        .testTarget(name: "HWKitTests", dependencies: ["HWKit", "TestKit", "Arguments"]),
        .testTarget(name: "TerminalTests", dependencies: ["Terminal"]),
        
        // Deliver: We also test the delivery. FIXME: Should be done in another test.
        // Keychain: We use the keychain to access the iTunesConnect password for the system tests.
        .testTarget(name: "XCBuildTests", dependencies: ["TestKit", "Deliver", "XCBuild", "Keychain", "HighwayCore"], exclude: ["Fixtures"]),
        .testTarget(name: "ResultTests", dependencies: ["Result"]),
        .testTarget(name: "TaskTests", dependencies: ["Task", "FileSystem", "TestKit"]),
        .testTarget(name: "UrlTests", dependencies: ["Url"]),
        .testTarget(name: "ArgumentsTests", dependencies: ["Arguments"]),
        .testTarget(name: "GitTests", dependencies: ["TestKit", "FileSystem", "Url", "Git"]),
        .testTarget(name: "SwiftToolTests", dependencies: ["TestKit", "SwiftTool"]),

    ],
    swiftLanguageVersions: [4]
)
