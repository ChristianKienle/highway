import XCTest
import FSKit

final class RelativePathTests: XCTestCase {
    func testThatValidPathsAreNotModified() {
        XCTAssertEqual(RelativePath("hello").asString, "hello")
        XCTAssertEqual(RelativePath("hello/world").asString, "hello/world")
        XCTAssertEqual(RelativePath(".hello").asString, ".hello")
        XCTAssertEqual(RelativePath(".").asString, ".")
    }
    func testTrailingSlashesAreRemoved() {
        XCTAssertEqual(RelativePath("hello/").asString, "hello")
        XCTAssertEqual(RelativePath("hello/world/").asString, "hello/world")
    }
    func testEmptyPathIsTransformedIntoCurrentPathIndicator() {
        XCTAssertEqual(RelativePath("").asString, ".")
    }
    
    func testThatRedundantDotsAreRemoved() {
        XCTAssertEqual(RelativePath("hello/./.").asString, "hello")
        XCTAssertEqual(RelativePath("./.").asString, ".")
        XCTAssertEqual(RelativePath("hello/././world/./test/./bla/test/././.build/test").asString, "hello/world/test/bla/test/.build/test")
    }
}
