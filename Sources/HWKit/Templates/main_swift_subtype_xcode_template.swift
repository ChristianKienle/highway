import Foundation

public let mainSwiftSubtypeXcodeTemplate =
"""
import HighwayCore
import XCBuild
import HighwayProject
import Deliver
import Foundation

enum Way: String, HighwayType {
    case test, build, run
    var usage: String {
        switch self {
        case .build: return "Builds the project"
        case .test: return "Executes tests"
        case .run: return "Runs the project"
        }
    }
}

class App: Highway<Way> {
    override func setupHighways() {
        self[.build] ==> build
        self[.test] ==> test
        self[.run] ==> run
    }

    // MARK: - Highways
    func build() {

    }

    func test() throws {
        var options = TestOptions()
        options.project = "<insert path to *.xcproject here>"
        options.scheme = "<insert name of scheme here>"
        options.destination = Destination.simulator(.iOS, name: "iPhone 7", os: .latest, id: nil)
        try xcbuild.buildAndTest(using: options)
    }

    func run() {

    }
}

App(Way.self).go()


"""
