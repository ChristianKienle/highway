import XCTest
import Task
import FileSystem
import Url

/// Tests the SystemExecutableProvider with a custom FileSystem
final class SystemExecutableProviderTests: XCTestCase {
    // MARK: - Properties
    private var finder = SystemExecutableProvider(searchedUrls: [], fileSystem: InMemoryFileSystem())
    private var fs: FileSystem { return finder.fileSystem }

    // MARK: - XCTest
    override func setUp() {
        super.setUp()
        finder = SystemExecutableProvider(searchedUrls: [], fileSystem: InMemoryFileSystem())
    }
    
    // MARK: - Tests
    func testWithEmptyFileSystem() {
        XCTAssertNil(finder.urlForExecuable("hello"))
        XCTAssertNil(finder.urlForExecuable("/hello"))
        XCTAssertNil(finder.urlForExecuable("/local"))
        XCTAssertNil(finder.urlForExecuable("local"))
        XCTAssertNil(finder.urlForExecuable(""))
        finder.searchedUrls = ["/usr/bin", "/hello", "/usr/local"]
        XCTAssertNil(finder.urlForExecuable("hello"))
        XCTAssertNil(finder.urlForExecuable("/hello"))
        XCTAssertNil(finder.urlForExecuable("/local"))
        XCTAssertNil(finder.urlForExecuable("local"))
        XCTAssertNil(finder.urlForExecuable(""))
    }
    
    func testSimple() {
        XCTAssertNoThrow(try fs.createDirectory(at: "/usr/bin"))
        XCTAssertNoThrow(try fs.writeData(Data(), to: "/usr/bin/bash"))
        finder.searchedUrls = ["/usr/bin"]
        XCTAssertEqual(finder.urlForExecuable("bash"), "/usr/bin/bash")
    }
    
    func testThatOrderIsOK() {
        XCTAssertNoThrow(try fs.createDirectory(at: "/usr/bin"))
        XCTAssertNoThrow(try fs.createDirectory(at: "/local/bin"))
        XCTAssertNoThrow(try fs.writeData(Data(), to: "/usr/bin/bash"))
        XCTAssertNoThrow(try fs.writeData(Data(), to: "/local/bin/bash"))
        finder.searchedUrls = ["/local/bin", "/usr/bin"]
        XCTAssertEqual(finder.urlForExecuable("bash"), "/local/bin/bash")
    }
}
