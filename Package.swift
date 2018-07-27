// swift-tools-version:4.1
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
        .library(name: "ZFile", targets: ["ZFile"]),
        .library(name: "Url", targets: ["Url"]),
        .library(name: "Result", targets: ["Result"]),
        .library(name: "Task", targets: ["Task"]),
        .library(name: "XCBuild", targets: ["XCBuild"]),
        .library(name: "HighwayCore", targets: ["HighwayCore"]),
        .library(name: "HWKit", targets: ["HWKit"]),
        .library(name: "Keychain", targets: ["Keychain"]),
        .library(name: "Terminal", targets: ["Terminal"]),
        .library(name: "SourceryAutoProtocols", targets: ["SourceryAutoProtocols"]),
        .library(name: "SourceryMocks", targets: ["SourceryMocks"]),
        .library(name: "All",
                 targets: [
                   "HighwayProject",
                   "POSIX",
                   "Deliver",
                   "Arguments",
                   "Errors",
                   "ZFile",
                   "Url",
                   "Result",
                   "Task",
                   "XCBuild",
                   "HighwayCore",
                   "HWKit",
                   "Terminal",
                   "SourceryMocks", "Keychain", "Git", "SourceryAutoProtocols", "SourceryMocks"]
        )
    ],
    targets: [
        .target(name: "SourceryAutoProtocols",
                path: "./Sources/🧙‍♂️/AutoProtocols"
        ),
        .target(name: "SourceryMocks",
                dependencies: ["HighwayProject"],
                path: "./Sources/🧙‍♂️/Mocks"
        ),
        
        .target(name: "HighwayProject",
                dependencies: ["Git", "POSIX", "Deliver", "HighwayCore", "Terminal", "ZFile", "XCBuild", "Url", "Task", "SourceryAutoProtocols"],
                path: "./Sources/HighwayProject"),
        
        // Task: We use the security command line tool to talk to the Keychain.
        // Arguments: Task => Arguments
        // Errors: We want to throw Errors
        .target(name: "Keychain", dependencies: ["Task", "Arguments", "Errors", "SourceryAutoProtocols"]),
        .target(name: "Url", dependencies: ["SourceryAutoProtocols"]),
        .target(name: "Errors", dependencies: ["SourceryAutoProtocols"]),
        .target(name: "Arguments", dependencies: ["Errors", "SourceryAutoProtocols"]),
        .target(name: "Result", dependencies: ["SourceryAutoProtocols"]),
        .target(name: "Terminal", dependencies: ["SourceryAutoProtocols"]),
        .target(name: "Git", dependencies: ["Arguments", "Url", "Task", "Errors", "Terminal", "SourceryAutoProtocols"]),
        .target(name: "POSIX", dependencies: ["Url", "SourceryAutoProtocols"]),

        .target(name: "Deliver", dependencies: ["POSIX", "Task", "Url", "Result", "Errors", "Arguments", "ZFile", "SourceryAutoProtocols"]),

        // Url: Needs to have a concept of absolute/relative files/urls.
        // Result: SHOULD return Results instead of throwing. FIXME!
        // Errors: Throws Errors.
        .target(name: "ZFile", dependencies: ["SourceryAutoProtocols"]),
        .target(name: "HWKit", dependencies: ["Git", "POSIX", "HighwayCore", "Terminal", "ZFile", "Arguments", "SourceryAutoProtocols"]),
        .target(name: "HighwayCore", dependencies: ["POSIX", "Terminal", "ZFile", "Task", "Url", "Arguments", "SourceryAutoProtocols"]),
        .target(name: "highway", dependencies: ["Git", "POSIX", "HighwayProject", "HWKit", "HighwayCore", "Terminal", "ZFile", "Arguments", "SourceryAutoProtocols"]),
        .target(name: "XCBuild", dependencies: ["POSIX", "Url", "ZFile", "Task", "Arguments", "SourceryAutoProtocols"]),

        // Url: In the end, a Task is always using some kind of files on disk.
        // ZFile: The framework checks (in certain cases) the existence of files.
        //             For example the current working directory of a Task before it is executed.
        // Arguments: A Task has Arguments.
        // Terminal: We have to log
        .target(name: "Task", dependencies: ["Terminal", "Url", "ZFile", "Errors", "Result", "Arguments", "SourceryAutoProtocols", "POSIX"]),

        // Tests
        .testTarget(name: "DeliverTests", dependencies: ["ZFile", "Arguments"]),
        .testTarget(name: "POSIXTests", dependencies: ["POSIX", "Url"]),
        .testTarget(name: "HighwayCoreTests", dependencies: ["HighwayCore", "SourceryMocks", "Arguments"]),
        .testTarget(name: "HWKitTests", dependencies: ["HWKit", "SourceryMocks", "Arguments"]),
        .testTarget(name: "TerminalTests", dependencies: ["Terminal", "SourceryMocks"]),
        
        // Deliver: We also test the delivery. FIXME: Should be done in another test.
        // Keychain: We use the keychain to access the iTunesConnect password for the system tests.
        .testTarget(name: "XCBuildTests", dependencies: ["SourceryMocks", "Deliver", "XCBuild", "Keychain", "HighwayCore", "SourceryMocks"], exclude: ["Fixtures"]),
        .testTarget(name: "ResultTests", dependencies: ["Result", "SourceryMocks"]),
        .testTarget(name: "TaskTests", dependencies: ["Task", "ZFile", "SourceryMocks"]),
        .testTarget(name: "UrlTests", dependencies: ["Url"]),
        .testTarget(name: "ArgumentsTests", dependencies: ["Arguments"]),
        .testTarget(name: "GitTests", dependencies: ["SourceryMocks", "ZFile", "Url", "Git"]),
    ],
    swiftLanguageVersions: [4]
)
