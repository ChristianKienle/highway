import XCTest
import FileSystem

final class RelativePathTests: XCTestCase {
    func testThatValidPathsAreNotModified() {
        XCTAssertEqual(Relative("hello").asString, "hello")
        XCTAssertEqual(Relative("hello/world").asString, "hello/world")
        XCTAssertEqual(Relative(".hello").asString, ".hello")
        XCTAssertEqual(Relative(".").asString, ".")
    }
    func testTrailingSlashesAreRemoved() {
        XCTAssertEqual(Relative("hello/").asString, "hello")
        XCTAssertEqual(Relative("hello/world/").asString, "hello/world")
    }
    func testEmptyPathIsTransformedIntoCurrentPathIndicator() {
        XCTAssertEqual(Relative("").asString, ".")
    }
    
    func testThatRedundantDotsAreRemoved() {
        XCTAssertEqual(Relative("hello/./.").asString, "hello")
        XCTAssertEqual(Relative("./.").asString, ".")
        XCTAssertEqual(Relative("hello/././world/./test/./bla/test/././.build/test").asString, "hello/world/test/bla/test/.build/test")
    }
}
