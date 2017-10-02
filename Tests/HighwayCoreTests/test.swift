import XCTest
@testable import HighwayCore
import FSKit

private func _searchURLs(from string: String, _ cwd: String) -> [AbsoluteUrl] {
    let cwdURL = AbsoluteUrl(cwd)
    return PathEnvironmentValueParser(pathEnvironmentValue: string, currentWorkingDirectory: cwdURL).searchFileURLs
}

private extension String {
    var stdURL: AbsoluteUrl {
        return AbsoluteUrl(self)
    }
}

class HighwayCoreTests: XCTestCase {
    private var finder = ExecutableFinder(searchURLs: [], fileSystem: InMemoryFileSystem())
    private var fs: FileSystem { return finder.fileSystem }
    func testParser() {
        let cwd = "/Users/chris"
        XCTAssertEqual(_searchURLs(from: "", cwd), [])
        XCTAssertEqual(_searchURLs(from: "/usr/bin", cwd), ["/usr/bin".stdURL])
        XCTAssertEqual(_searchURLs(from: "/usr/bin:/usr/local/bin", cwd), ["/usr/bin".stdURL, "/usr/local/bin".stdURL])
        XCTAssertEqual(_searchURLs(from: "/usr/bin::/usr/local/bin", cwd), ["/usr/bin".stdURL, "/usr/local/bin".stdURL])
        XCTAssertEqual(_searchURLs(from: ".", cwd), [cwd.stdURL])
        XCTAssertEqual(_searchURLs(from: "hello/world", cwd), [(cwd + "/hello/world").stdURL])
        XCTAssertEqual(_searchURLs(from: "hello/world", cwd), [(cwd + "/hello/world").stdURL])
    }

    override func setUp() {
        super.setUp()
        finder = ExecutableFinder(searchURLs: [], fileSystem: InMemoryFileSystem())
    }
    func testWithEmptyFileSystem() {
        XCTAssertNil(finder.urlForExecuable(named: "hello"))
        XCTAssertNil(finder.urlForExecuable(named: ""))
        
        finder.searchURLs = [AbsoluteUrl("/usr/bin")]
        finder.searchURLs = [AbsoluteUrl("/hello")]
        finder.searchURLs = [AbsoluteUrl("/usr/local")]

        XCTAssertNil(finder.urlForExecuable(named: "hello"))
        XCTAssertNil(finder.urlForExecuable(named: ""))
    }
    func testSimple() {
        XCTAssertNoThrow(try fs.createDirectory(at: AbsoluteUrl("/usr/bin")))
        XCTAssertNoThrow(try fs.writeData(Data(), to: AbsoluteUrl("/usr/bin/bash")))

        finder.searchURLs = [AbsoluteUrl("/usr/bin")]
        XCTAssertEqual(finder.urlForExecuable(named: "bash"), AbsoluteUrl("/usr/bin/bash"))
    }
    
    func testThatOrderIsOK() {
        XCTAssertNoThrow(try fs.createDirectory(at: AbsoluteUrl("/usr/bin")))
        XCTAssertNoThrow(try fs.createDirectory(at: AbsoluteUrl("/local/bin")))
        XCTAssertNoThrow(try fs.writeData(Data(), to: AbsoluteUrl("/usr/bin/bash")))
        XCTAssertNoThrow(try fs.writeData(Data(), to: AbsoluteUrl("/local/bin/bash")))

        finder.searchURLs = [AbsoluteUrl("/local/bin"), AbsoluteUrl("/usr/bin")]
        XCTAssertEqual(finder.urlForExecuable(named: "bash"), AbsoluteUrl("/local/bin/bash"))
    }
}
