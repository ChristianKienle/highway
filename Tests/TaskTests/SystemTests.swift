import XCTest
import Task
import TestKit
import FileSystem
import Result


final class SystemTests: XCTestCase {
    // MARK: - Properties
    var system = MockLocalSystem()
    
    // MARK: Setup
    override func setUp() {
        super.setUp()
        system = MockLocalSystem()
    }
    
    // MARK: Tests
    func testExecute_error_currentDirectoryDoesNotExist() {
        let task = Task(executableUrl: .root)
        task.currentDirectoryUrl = "/hello/world"
        let result = system.execute(task)
        let error = result.error
        XCTAssertNotNil(error)
        XCTAssertEqual(error, .currentDirectoryDoesNotExist)
    }
    
    func testExecute_error_invalidStateAfterExecuting() {
        system.providerMock["/bin"] = ["xcrun"]
        XCTAssertNoThrow(try system.fsMock.createDirectory(at: "/home"))
        let task = Task(executableUrl: "/bin/xcrun")
        task.currentDirectoryUrl = "/home"
        system.executorMock.mockExecution(of: task) { _ in
            task.state = .waiting
        }
        let result = system.execute(task)
        let error = result.error
        XCTAssertNotNil(error)
        XCTAssertEqual(error, .invalidStateAfterExecuting)
    }
    
    func testExecute_error_taskDidExitWithFailure() {
        system.providerMock["/bin"] = ["xcrun"]
        XCTAssertNoThrow(try system.fsMock.createDirectory(at: "/home"))
        let task = Task(executableUrl: "/bin/xcrun")
        task.currentDirectoryUrl = "/home"
        let terminationIn = Termination.failure
        system.executorMock.mockExecution(of: task) { _ in
            task.state = .terminated(terminationIn)
        }
        
        let result = system.execute(task)
        let error = result.error
        XCTAssertNotNil(error)
        XCTAssertEqual(error, .taskDidExitWithFailure(terminationIn))
    }
    
    func testExecute_OK() {
        system.providerMock["/bin"] = ["xcrun"]
        XCTAssertNoThrow(try system.fsMock.createDirectory(at: "/home"))
        let task = Task(executableUrl: "/bin/xcrun")
        task.currentDirectoryUrl = "/home"
        let terminationIn = Termination.success
        system.executorMock.mockExecution(of: task) { _ in
            task.state = .terminated(terminationIn)
        }
        
        let result = system.execute(task)
        let error = result.error
        XCTAssertNil(error)
        XCTAssertNotNil(result.value)
    }
}
