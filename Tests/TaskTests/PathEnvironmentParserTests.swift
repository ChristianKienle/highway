import XCTest
import Task
import Url

final class PathEnvironmentParserTests: XCTestCase {
    // MARK: Tests
    func testParser() {
        let cwd: Absolute = "/Users/chris"
        _assert("") // yields nothing
        _assert("/usr/bin", yields: "/usr/bin")
        _assert("/usr/bin:/usr/local/bin", yields: "/usr/bin", "/usr/local/bin")
        _assert("/usr/bin::/usr/local/bin", yields: "/usr/bin", "/usr/local/bin")
        _assert(".", yields: cwd)
        _assert("hello/world", yields: cwd.appending("/hello/world"))
    }
    
    func testContainsDot() {
        _assert("/a/./b", yields: "/a/b")
    }
    
    // MARK: Helper
    private func _urlsFrom(path: String, _ cwd: Absolute = "/Users/chris") -> [Absolute] {
        return PathEnvironmentParser(value: path, currentDirectoryUrl: cwd).urls
    }
    
    func _assert(_ path: String, `in` cwd: Absolute = "/Users/chris", yields expectedUrls: Absolute..., file: StaticString = #file, line: UInt = #line) {
        let actual = _urlsFrom(path: path, cwd)
        XCTAssertEqual(actual, expectedUrls, "failure", file: file, line: line)
    }
}
