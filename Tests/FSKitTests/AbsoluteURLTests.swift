import XCTest
import FSKit

final class AbsoluteURLTests: XCTestCase {
    func testInitRelativeTo() {
        assertAbsoluteEqualsPath(AbsoluteUrl(path: "test", relativeTo: AbsoluteUrl("/")), "/test")
        assertAbsoluteEqualsPath(AbsoluteUrl(path: "", relativeTo: AbsoluteUrl("/")), "/")
        assertAbsoluteEqualsPath(AbsoluteUrl(path: "hello/world", relativeTo: AbsoluteUrl("/")), "/hello/world")
    }
    
    func testAppendRelative() {
        let base = AbsoluteUrl("/")
        let bin = base.appending(RelativePath("bin"))
        assertAbsoluteEqualsPath(bin, "/bin")
    }
}

private func assertAbsoluteEqualsPath(_ absoluteURL: AbsoluteUrl, _ absolutePath: String, file: StaticString = #file, line: UInt = #line) {
    XCTAssertEqual(absoluteURL, AbsoluteUrl(absolutePath), "\nURLs not equal:\n\(absoluteURL) \n\nExpected: \(absolutePath)", file: file, line: line)
}
