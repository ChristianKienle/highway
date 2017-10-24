import XCTest
import TestKit
import FileSystem
import Url
import Task
import Git

final class GitAutotagTests: XCTestCase {
    // MARK: - Properties
    private var system = MockSystem()
    private var fs = InMemoryFileSystem()
    // MARK: - XCTest
    override func setUp() {
        super.setUp()
        system = MockSystem()
        fs = InMemoryFileSystem()
    }
    
    // MARK: - Tests
    func testAutotag() {
        XCTAssertNoThrow(try _makeGitAutotagAvailable())
        guard let git = try? GitAutotag(system: system) else {
            XCTFail(); return
        }
        
        
        
        // Fail if directory does not exist
        XCTAssertThrowsError(try git.autotag(at: Absolute("/test")))
        // Create dir
        XCTAssertNoThrow(try fs.createDirectory(at: Absolute("/test")))
        // Now simulate an git failure
        system.unhandledExecutionFallback = { _ in 
//            $0.state = .terminated(.failure)
            return MockSystem.ExecutionResult.failure(.taskDidExitWithFailure(.failure))
        }
//        executor.executions = { $0.state = .terminated(.failure) }
        XCTAssertThrowsError(try git.autotag(at: Absolute("/test")))
        // Now simulate an git success
        system.unhandledExecutionFallback = {
            let sem = DispatchSemaphore(value: 0)
            $0.output.didRead = { _ in
                sem.signal()
            }
            $0.output.writeabilityHandler = { handle in
                handle.write("1.2.3")
                handle.close()
            }
            sem.wait()
            $0.state = .terminated(.success)
            return MockSystem.ExecutionResult.success(())
        }

        XCTAssertNoThrow(try git.autotag(at: Absolute("/test")))
    }
    
    // MARK: - Helper
    private func _makeGitAutotagAvailable() throws {
        let bin:Absolute = "/bin"
        try fs.createDirectory(at: bin)
        try fs.writeData(Data(), to: bin.appending("git-autotag"))
        system.unknownTaskFallback = { taskName in
            if taskName == "git-autotag" {
                let task = Task(executableUrl: bin.appending("git-autotag"))
                return MockSystem.TaskResult.success(task)
            }
            return MockSystem.TaskResult.failure(.executableNotFound(commandName: taskName))
            
        }
    }
}
