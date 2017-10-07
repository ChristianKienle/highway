import XCTest
import FileSystem

final class AbsoluteURLTests: XCTestCase {
    func testInitRelativeTo() {
        assertAbsoluteEqualsPath(Absolute(path: "test", relativeTo: Absolute("/")), "/test")
        assertAbsoluteEqualsPath(Absolute(path: "", relativeTo: Absolute("/")), "/")
        assertAbsoluteEqualsPath(Absolute(path: "hello/world", relativeTo: Absolute("/")), "/hello/world")
    }
    
    func testAppendRelative() {
        let base = Absolute("/")
        let bin = base.appending(Relative("bin"))
        assertAbsoluteEqualsPath(bin, "/bin")
    }
}

private func assertAbsoluteEqualsPath(_ absoluteURL: Absolute, _ absolutePath: String, file: StaticString = #file, line: UInt = #line) {
    XCTAssertEqual(absoluteURL, Absolute(absolutePath), "\nURLs not equal:\n\(absoluteURL) \n\nExpected: \(absolutePath)", file: file, line: line)
}
