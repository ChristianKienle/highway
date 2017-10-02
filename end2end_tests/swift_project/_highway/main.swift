import HighwayCore
import FSKit

enum App: String, Highway {
    case build
    case test
    case run

    /// !!! Add more Highways by adding additional cases. !!!

    var usage: String {
        switch self {
        case .build: return "Builds the project"
        case .test: return "Executes tests"
        case .run: return "Runs the project"
        }
    }
}

// MARK: - Helper to get you started

let context = Context.local()
let pwd = context.currentWorkingUrl // also works when build + run within Xcode
let highways = Highways(App.self)

// MARK: - Setup your custom highways
func _test_then_build() throws {
    Fastlane().gym("arguments", "passed", "to", "fastlane gym")
    Fastlane().scan("arguments", "passed", "to", "fastlane scan")
    
    let swift = SwiftBuildSystem()
    
    try swift.test() // Test
    
    // Build and get an object describing the result.
    let artifact = try swift.build()
    
    print("😜  \(artifact.binPath)")
    print("😜  \(artifact.buildOutput)")

}

highways
.highway(.build, _test_then_build)
.highway(.test) {

}
.highway(.run) {

}

.go()
