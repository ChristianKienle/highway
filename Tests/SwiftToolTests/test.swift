import XCTest
import TestKit
import FileSystem
import Url
import Task
import SwiftTool

private class Mock {
    init() {
        self.system = MockSystem()
        self.swift = _SwiftTool(system: self.system)
    }
    let system: MockSystem
    let swift: _SwiftTool
}

final class SwiftBuildSystemTests: XCTestCase {
    // MARK: - Properties
    private var mock = Mock()
    
    // MARK: - XCTest
    override func setUp() {
        super.setUp()
        mock = Mock()
    }
    
    // MARK: - Tests
    func testBuildFailsIfBinPathTaskFails() {
        mock.system.unhandledExecutionFallback = { task in
            if task.arguments.all.contains("--build-path") {
                return .failure(.taskDidExitWithFailure(.failure))
            }
            return .success(())
        }
        mock.system.unknownTaskFallback = { command in
            return .success(Task(executableUrl: Absolute("/bin/" + command)))
        }
        
        let options = SwiftOptions(subject: .product("myapp"), configuration: .release, verbose: false, buildPath: nil, additionalArguments: [])
        XCTAssertThrowsError(_ = try mock.swift.build(projectAt: "/Users/chris/project", options: options))
    }
    
    func testBuildFailsIfBuildTaskFails() {
        mock.system.unhandledExecutionFallback = { task in
            if task.arguments.all.contains("--build-path") {
                return .success(())
            }
            return .failure(.taskDidExitWithFailure(.failure))
        }
        mock.system.unknownTaskFallback = { command in
            return .success(Task(executableUrl: Absolute("/bin/" + command)))
        }
        
        let options = SwiftOptions(subject: .product("myapp"), configuration: .release, verbose: false, buildPath: nil, additionalArguments: [])
        XCTAssertThrowsError(_ = try mock.swift.build(projectAt: "/Users/chris/project", options: options))
    }
}


