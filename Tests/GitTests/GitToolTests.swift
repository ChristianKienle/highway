import XCTest
import TestKit
import FileSystem
import Git
import Url
import Task

private final class MockGitSystem {
    let system = MockSystem()
    let fs = InMemoryFileSystem()
    
    func makeGitAvailable() throws {
        try fs.createDirectory(at: Absolute("/bin"))
        try fs.writeData(Data(), to: Absolute("/bin/git"))
        system.unknownTaskFallback = { taskName in
            if taskName == "git" {
                let task = Task(executableUrl: "/bin/git")
                return MockSystem.TaskResult.success(task)
            }
            return MockSystem.TaskResult.failure(.executableNotFound(commandName: taskName))
        }
    }
}

final class GitToolTests: XCTestCase {
    private var gitSystem = MockGitSystem()
    private var fs: FileSystem { return gitSystem.fs }
    
    override func setUp() {
        super.setUp()
        gitSystem = MockGitSystem()
    }
    
    func testAddEverythingTask() {
        XCTAssertNoThrow(try gitSystem.makeGitAvailable())
        let git = _GitTool(system: gitSystem.system)
        
        let gitExecuted = expectation(description: "git executed")
        gitSystem.system.unhandledExecutionFallback = { task in
            XCTAssertEqual(task.executableUrl, Absolute("/bin/git"))
            XCTAssertEqual(task.currentDirectoryUrl, Absolute("/test"))
            XCTAssertEqual(task.arguments, ["add", "."])
            task.state = .terminated(.success)
            gitExecuted.fulfill()
            return TestKit.MockSystem.ExecutionResult.success(())
        }
        
        XCTAssertNoThrow(try git.addAll(at: Absolute("/test")))
        waitForExpectations(timeout: 5) { XCTAssertNil($0) }
    }
    
    func testAddEverything() {
        XCTAssertNoThrow(try gitSystem.makeGitAvailable())
        
        let git = _GitTool(system: gitSystem.system)

        // Fail if directory does not exist
        XCTAssertThrowsError(try git.addAll(at: Absolute("/test")))
        // Create dir
        XCTAssertNoThrow(try fs.createDirectory(at: Absolute("/test")))
        // Now simulate an git failure
        gitSystem.system.unhandledExecutionFallback = { task in
            return TestKit.MockSystem.ExecutionResult.failure(.taskDidExitWithFailure(.failure))
        }
        
        XCTAssertThrowsError(try git.addAll(at: Absolute("/test")))
        // Now simulate an git success
        gitSystem.system.unhandledExecutionFallback = { task in
            return TestKit.MockSystem.ExecutionResult.success(())
        }
        XCTAssertNoThrow(try git.addAll(at: Absolute("/test")))
    }
    
    func testCommit() {
        XCTAssertNoThrow(try gitSystem.makeGitAvailable())
        
        let git = _GitTool(system: gitSystem.system)

        // Fail if directory does not exist
        XCTAssertThrowsError(try git.commit(at: Absolute("/test"), message: "Hello"))
        // Create dir
        XCTAssertNoThrow(try fs.createDirectory(at: Absolute("/test")))
        // Now simulate an git failure
        gitSystem.system.unhandledExecutionFallback = { task in
            return TestKit.MockSystem.ExecutionResult.failure(.taskDidExitWithFailure(.failure))
        }
        XCTAssertThrowsError(try git.commit(at: Absolute("/test"), message: "Hello"))
        // Now simulate an git success
        gitSystem.system.unhandledExecutionFallback = { task in
            return TestKit.MockSystem.ExecutionResult.success(())
        }
        XCTAssertNoThrow(try git.commit(at: Absolute("/test"), message: "Hello"))
    }
    
    func testCurrentTag() {
        XCTAssertNoThrow(try gitSystem.makeGitAvailable())
        
        let git = _GitTool(system: gitSystem.system)

        // Fail if directory does not exist
        XCTAssertThrowsError(try git.currentTag(at: Absolute("/test")))
        // Create dir
        XCTAssertNoThrow(try fs.createDirectory(at: Absolute("/test")))
        // Now simulate an git failure
        gitSystem.system.unhandledExecutionFallback = { task in
            return TestKit.MockSystem.ExecutionResult.failure(.taskDidExitWithFailure(.failure))
        }
        XCTAssertThrowsError(try git.currentTag(at: Absolute("/test")))
        // Now simulate success but without any output
        gitSystem.system.unhandledExecutionFallback = { task in
            return TestKit.MockSystem.ExecutionResult.success(())
        }
        XCTAssertThrowsError(try git.currentTag(at: Absolute("/test")))
        // Now simulate success but without garbage output
        gitSystem.system.unhandledExecutionFallback = { task in
            let sem = DispatchSemaphore(value: 0)
            task.output.didRead = { _ in
                sem.signal()
            }
            task.output.writeabilityHandler = { handle in
                handle.write("schlonz")
                handle.close()
            }
            sem.wait()
            task.state = .terminated(.success)
            return TestKit.MockSystem.ExecutionResult.success(())
        }
        
        XCTAssertThrowsError(try git.currentTag(at: Absolute("/test")))
        // Now simulate an git success with valid outout
        gitSystem.system.unhandledExecutionFallback = { task in
            let sem = DispatchSemaphore(value: 0)
            task.output.didRead = { _ in
                sem.signal()
            }
            task.output.writeabilityHandler = { handle in
                handle.write("v1.2.3")
                handle.close()
            }
            sem.wait()
            task.state = .terminated(.success)
            return TestKit.MockSystem.ExecutionResult.success(())
        }
        
        XCTAssertNoThrow(try git.currentTag(at: Absolute("/test")))
    }
    
    func testAllOkay() {
        XCTAssertNoThrow(try gitSystem.makeGitAvailable())
        XCTAssertNoThrow(try fs.createDirectory(at: Absolute("/.highway")))
        
        let git = _GitTool(system: gitSystem.system)

        let repoUrl = "git@bitbucket.org:ChristianKienle/highway.git"
        let localUrl = Absolute("/.highway/highway.git")
        let options = Git.CloneOptions(remoteUrl: repoUrl, localPath: localUrl,  performMirror: true)
        
        let gitExecuted = expectation(description: "git executed")
        gitSystem.system.unhandledExecutionFallback = { task in
            XCTAssertEqual(task.name, "git")
            XCTAssertEqual(task.executableUrl, Absolute("/bin/git"))
            XCTAssertEqual(task.arguments, ["clone", "--mirror", repoUrl, localUrl.path])
            task.state = .terminated(.success)
            gitExecuted.fulfill()
            return TestKit.MockSystem.ExecutionResult.success(())
        }
        
        XCTAssertNoThrow(try git.clone(with: options))
        waitForExpectations(timeout: 5) { XCTAssertNil($0) }
    }
}
