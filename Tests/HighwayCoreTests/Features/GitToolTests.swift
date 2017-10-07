import XCTest
import TestKit
import FileSystem
@testable import HighwayCore
import Url
import Task

private final class MockGitSystem {
    var executor: ExecutorMock {
        return context.executorMock
    }
    let context = ContextMock()
    var fs: FileSystem { return context.fileSystem }
    func makeGitAvailable() throws {
        try fs.createDirectory(at: Absolute("/bin"))
        try fs.writeData(Data(), to: Absolute("/bin/git"))
        context.executableProviderMock[Absolute("/bin")] = ["git"]
    }
}

final class GitToolTests: XCTestCase {
    private var gitSystem = MockGitSystem()
    private var fs: FileSystem { return gitSystem.context.fileSystem }
    private var executor: ExecutorMock { return gitSystem.executor }
    
    override func setUp() {
        super.setUp()
        gitSystem = MockGitSystem()
    }

    func testAddEverythingTask() {
        XCTAssertNoThrow(try gitSystem.makeGitAvailable())
        guard let git = try? GitTool(context: gitSystem.context) else {
            XCTFail(); return
        }
        
        let gitExecuted = expectation(description: "git executed")
        executor.executions = { task in
            XCTAssertEqual(task.executableUrl, Absolute("/bin/git"))
            XCTAssertEqual(task.currentDirectoryUrl, Absolute("/test"))
            XCTAssertEqual(task.arguments, ["add", "."])
            task.state = .terminated(.success)
            gitExecuted.fulfill()
        }
        
        XCTAssertNoThrow(try git.addAll(at: Absolute("/test")))
        waitForExpectations(timeout: 5) { XCTAssertNil($0) }
    }
    
    func testGitTool_init() {
        XCTAssertThrowsError(try GitTool(context: gitSystem.context))
        XCTAssertNoThrow(try gitSystem.makeGitAvailable())
        XCTAssertNoThrow(try GitTool(context: gitSystem.context))
    }

    func testAddEverything() {
        XCTAssertNoThrow(try gitSystem.makeGitAvailable())

        guard let git = try? GitTool(context: gitSystem.context) else {
            XCTFail(); return
        }

        // Fail if directory does not exist
        XCTAssertThrowsError(try git.addAll(at: Absolute("/test")))
        // Create dir
        XCTAssertNoThrow(try fs.createDirectory(at: Absolute("/test")))
        // Now simulate an git failure
        gitSystem.executor.executions = { $0.state = .terminated(.failure) }
        XCTAssertThrowsError(try git.addAll(at: Absolute("/test")))
        // Now simulate an git success
        gitSystem.executor.executions = { $0.state = .terminated(.success) }
        XCTAssertNoThrow(try git.addAll(at: Absolute("/test")))
    }

    func testCommit() {
        XCTAssertNoThrow(try gitSystem.makeGitAvailable())

        guard let git = try? GitTool(context: gitSystem.context) else {
            XCTFail(); return
        }

        // Fail if directory does not exist
        XCTAssertThrowsError(try git.commit(at: Absolute("/test"), message: "Hello"))
        // Create dir
        XCTAssertNoThrow(try fs.createDirectory(at: Absolute("/test")))
        // Now simulate an git failure
        gitSystem.executor.executions = { $0.state = .terminated(.failure) }
        XCTAssertThrowsError(try git.commit(at: Absolute("/test"), message: "Hello"))
        // Now simulate an git success
        gitSystem.executor.executions = { $0.state = .terminated(.success) }
        XCTAssertNoThrow(try git.commit(at: Absolute("/test"), message: "Hello"))
    }

    func testCurrentTag() {
        XCTAssertNoThrow(try gitSystem.makeGitAvailable())

        guard let git = try? GitTool(context: gitSystem.context) else {
            XCTFail(); return
        }

        // Fail if directory does not exist
        XCTAssertThrowsError(try git.currentTag(at: Absolute("/test")))
        // Create dir
        XCTAssertNoThrow(try fs.createDirectory(at: Absolute("/test")))
        // Now simulate an git failure
        gitSystem.executor.executions = { $0.state = .terminated(.failure) }
        XCTAssertThrowsError(try git.currentTag(at: Absolute("/test")))
        // Now simulate success but without any output
        gitSystem.executor.executions = { $0.state = .terminated(.success) }
        XCTAssertThrowsError(try git.currentTag(at: Absolute("/test")))
        // Now simulate success but without garbage output
        gitSystem.executor.executions = {
            let sem = DispatchSemaphore(value: 0)
            $0.output.didRead = { _ in
                sem.signal()
            }
            $0.output.writeabilityHandler = { handle in
                handle.write("schlonz")
                handle.close()
            }
            sem.wait()
            $0.state = .terminated(.success)
        }
        XCTAssertThrowsError(try git.currentTag(at: Absolute("/test")))
        // Now simulate an git success with valid outout
        gitSystem.executor.executions = {
            let sem = DispatchSemaphore(value: 0)
            $0.output.didRead = { _ in
                sem.signal()
            }
            $0.output.writeabilityHandler = { handle in
                handle.write("v1.2.3")
                handle.close()
            }
            sem.wait()
            $0.state = .terminated(.success)
        }
        XCTAssertNoThrow(try git.currentTag(at: Absolute("/test")))
    }
    
    func testAllOkay() {
        XCTAssertNoThrow(try gitSystem.makeGitAvailable())
        XCTAssertNoThrow(try fs.createDirectory(at: Absolute("/.highway")))

        guard let git = try? GitTool(context: gitSystem.context) else {
            XCTFail(); return
        }
            let repoUrl = "git@bitbucket.org:ChristianKienle/highway.git"
            let localUrl = Absolute("/.highway/highway.git")
            let options = Git.CloneOptions(remoteUrl: repoUrl, localPath: localUrl,  performMirror: true)
            
            let gitExecuted = expectation(description: "git executed")
            executor.executions = { task in
                XCTAssertEqual(task.name, "git")
                XCTAssertEqual(task.executableUrl, Absolute("/bin/git"))
                XCTAssertEqual(task.arguments, ["clone", "--mirror", repoUrl, localUrl.path])
                task.state = .terminated(.success)
                gitExecuted.fulfill()
            }
            
            XCTAssertNoThrow(try git.clone(with: options))
            waitForExpectations(timeout: 5) { XCTAssertNil($0) }
    }
}
