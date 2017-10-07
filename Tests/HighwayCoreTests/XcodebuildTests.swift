import XCTest
import HighwayCore
import FileSystem
import Url
import Task
import TestKit

class XcodebuildTests: XCTestCase {
    func testExample() {
        let fs = InMemoryFileSystem()
        
        XCTAssertNoThrow(try fs.createDirectory(at: Absolute("/usr/bin")))
        XCTAssertNoThrow(try fs.writeData(Data(), to: Absolute("/usr/bin").appending("xcrun")))
        XCTAssertNoThrow(try fs.createDirectory(at: Absolute("/tmp")))

        let finder = ExecutableProviderMock()
        finder[Absolute("/usr/bin")] = ["xcrun"]
        let task: Task
        do {
            task = try Xcodebuild().task(executableFinder: finder)
        } catch {
            XCTFail(error.localizedDescription)
            return
        }
        XCTAssertEqual(task.name, "xcrun")
        XCTAssertEqual(try Xcodebuild(projectDirectory: Absolute("/tmp")).task(executableFinder: finder).currentDirectoryUrl, Absolute("/tmp"))
    }
}
