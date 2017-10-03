import Foundation

public let mainSwiftSubtypeSwiftTemplate =
"""
import HighwayCore
import FSKit

enum App: String, Highway {
    case build, test

    /// !!! Add more Highways by adding additional cases. !!!

    var usage: String {
        switch self {
        case .build: return "Builds the Swift project"
        case .test: return "Executes Tests"
        }
    }
}

// MARK: - Helper to get you started
let highways = Highways(App.self)
let swiftc = SwiftBuildSystem()

// MARK: - Setup your custom highways
highways

.highway(.build) {
    _ = try swiftc.build()
}
.highway(.test) {
    try swiftc.test()
}

.go()

"""
