import Foundation

let mainSwiftTemplate =
"""
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
let cwd = getabscwd() // also works when build + run within Xcode
let highways = Highways(App.self)

// MARK: - Setup your custom highways

highways

.highway(.build) {

}
.highway(.test) {

}
.highway(.run) {

}

.go()

"""


