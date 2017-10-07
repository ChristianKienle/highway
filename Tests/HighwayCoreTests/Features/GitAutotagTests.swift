import XCTest
import HighwayCore
import TestKit
import FileSystem
import Url
import Task

final class GitAutotagTests: XCTestCase {
    // MARK: - Properties
    private var context = ContextMock()
    
    // MARK: - XCTest
    override func setUp() {
        super.setUp()
        context = ContextMock()
    }
    
    // MARK: - Tests
    func testAutotag() {
        XCTAssertNoThrow(try _makeGitAutotagAvailable())
        
        guard let git = try? GitAutotag(context: context) else {
            XCTFail(); return
        }
        
        let fs = context.fileSystem
        let executor = context.executorMock
        
        // Fail if directory does not exist
        XCTAssertThrowsError(try git.autotag(at: Absolute("/test")))
        // Create dir
        XCTAssertNoThrow(try fs.createDirectory(at: Absolute("/test")))
        // Now simulate an git failure
        executor.executions = { $0.state = .terminated(.failure) }
        XCTAssertThrowsError(try git.autotag(at: Absolute("/test")))
        // Now simulate an git success
        executor.executions = {
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
        }
        XCTAssertNoThrow(try git.autotag(at: Absolute("/test")))
    }
    
    // MARK: - Helper
    private func _makeGitAutotagAvailable() throws {
        let bin = Absolute("/bin")
        try context.fileSystem.createDirectory(at: bin)
        try context.fileSystem.writeData(Data(), to: bin.appending("git-autotag"))
        context.executableProviderMock[bin] = ["git-autotag"]
    }
}
