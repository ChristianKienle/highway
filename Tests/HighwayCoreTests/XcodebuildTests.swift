import XCTest
import HighwayCore
import FSKit

class XcodebuildTests: XCTestCase {
    func testExample() {
        let fs = InMemoryFileSystem()
        
        XCTAssertNoThrow(try fs.createDirectory(at: AbsoluteUrl("/usr/bin")))
        XCTAssertNoThrow(try fs.writeData(Data(), to: AbsoluteUrl("/usr/bin").appending("xcrun")))
        XCTAssertNoThrow(try fs.createDirectory(at: AbsoluteUrl("/tmp")))

        let finder = ExecutableFinder(searchURLs: [AbsoluteUrl("/usr/bin")], fileSystem: fs)
        let task: Task
        do {
            task = try Xcodebuild().task(executableFinder: finder)
        } catch {
            XCTFail(error.localizedDescription)
            return
        }
        XCTAssertEqual(task.name, "xcrun")
        XCTAssertEqual(try Xcodebuild(projectDirectory: AbsoluteUrl("/tmp")).task(executableFinder: finder).currentDirectoryUrl, AbsoluteUrl("/tmp"))
    }
}
