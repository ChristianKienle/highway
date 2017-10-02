import XCTest
import TestKit
import FSKit
@testable import HighwayCore

private final class MockGitSystem {
    let executor = ExecutorMock()
    lazy var context: Context = {
        let cwd = AbsoluteUrl.root
        let fs = InMemoryFileSystem()
        let finder = ExecutableFinder(searchURLs: [AbsoluteUrl("/bin")], fileSystem: fs)
        return Context(currentWorkingUrl: cwd, executableFinder: finder, executor: executor)
    }()

    var fs: FileSystem { return context.fileSystem }
    func makeGitAvailable() throws {
        try fs.createDirectory(at: AbsoluteUrl("/bin"))
        try fs.writeData(Data(), to: AbsoluteUrl("/bin/git"))
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
        guard let task = try? git.taskThatAddsEverything(at: AbsoluteUrl("/test")) else {
            XCTFail(); return
        }
        XCTAssertEqual(task.executableURL, AbsoluteUrl("/bin/git"))
        XCTAssertEqual(task.currentDirectoryUrl, AbsoluteUrl("/test"))
        XCTAssertEqual(task.arguments, ["add", "."])
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
        XCTAssertThrowsError(try git.addEverything(at: AbsoluteUrl("/test")))
        // Create dir
        XCTAssertNoThrow(try fs.createDirectory(at: AbsoluteUrl("/test")))
        // Now simulate an git failure
        gitSystem.executor.executions = { $0.state = .finished(.failure) }
        XCTAssertThrowsError(try git.addEverything(at: AbsoluteUrl("/test")))
        // Now simulate an git success
        gitSystem.executor.executions = { $0.state = .finished(.success) }
        XCTAssertNoThrow(try git.addEverything(at: AbsoluteUrl("/test")))
    }
    
    func testCommit() {
        XCTAssertNoThrow(try gitSystem.makeGitAvailable())
        
        guard let git = try? GitTool(context: gitSystem.context) else {
            XCTFail(); return
        }
        
        // Fail if directory does not exist
        XCTAssertThrowsError(try git.commit(with: "Hello", at: AbsoluteUrl("/test")))
        // Create dir
        XCTAssertNoThrow(try fs.createDirectory(at: AbsoluteUrl("/test")))
        // Now simulate an git failure
        gitSystem.executor.executions = { $0.state = .finished(.failure) }
        XCTAssertThrowsError(try git.commit(with: "Hello", at: AbsoluteUrl("/test")))
        // Now simulate an git success
        gitSystem.executor.executions = { $0.state = .finished(.success) }
        XCTAssertNoThrow(try git.commit(with: "Hello", at: AbsoluteUrl("/test")))
    }
    
    func testCurrentTag() {
        XCTAssertNoThrow(try gitSystem.makeGitAvailable())
        
        guard let git = try? GitTool(context: gitSystem.context) else {
            XCTFail(); return
        }
        
        // Fail if directory does not exist
        XCTAssertThrowsError(try git.currentTagOfRepository(at: AbsoluteUrl("/test")))
        // Create dir
        XCTAssertNoThrow(try fs.createDirectory(at: AbsoluteUrl("/test")))
        // Now simulate an git failure
        gitSystem.executor.executions = { $0.state = .finished(.failure) }
        XCTAssertThrowsError(try git.currentTagOfRepository(at: AbsoluteUrl("/test")))
        // Now simulate success but without any output
        gitSystem.executor.executions = { $0.state = .finished(.success) }
        XCTAssertThrowsError(try git.currentTagOfRepository(at: AbsoluteUrl("/test")))
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
            $0.state = .finished(.success)
        }
        XCTAssertThrowsError(try git.currentTagOfRepository(at: AbsoluteUrl("/test")))
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
            $0.state = .finished(.success)
        }
        XCTAssertNoThrow(try git.currentTagOfRepository(at: AbsoluteUrl("/test")))
    }
    
    func testAllOkay() {
        XCTAssertNoThrow(try gitSystem.makeGitAvailable())
        XCTAssertNoThrow(try fs.createDirectory(at: AbsoluteUrl("/.highway")))

        guard let git = try? GitTool(context: gitSystem.context) else {
            XCTFail(); return
        }
        do {
            let repoUrl = "git@bitbucket.org:ChristianKienle/highway.git"
            let localUrl = AbsoluteUrl("/.highway/highway.git")
            let options = GitTool.CloneOptions(remoteUrl: repoUrl, localPath: localUrl,  performMirror: true)
            let plan = try git.cloneExecutionPlan(with: options)
            let task = plan.task
            XCTAssertEqual(task.name, "git")
            XCTAssertEqual(task.executableURL, AbsoluteUrl("/bin/git"))
            XCTAssertEqual(task.arguments, ["clone", "--mirror", repoUrl, localUrl.path])
            
            executor.mockExecution(of: task) { _ in
                task.state = .finished(.success)
            }

            
            XCTAssertNoThrow(try git.execute(cloneExecutionPlan: plan))
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

}
