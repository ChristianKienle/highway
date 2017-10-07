import XCTest
@testable import XCBuild

final class DestinationTests: XCTestCase {
    func testExample() {
        _assert(.macOS(architecture: .i386), equals: ["arch" : "i386", "platform" : "macOS"])
        _assert(.macOS(architecture: .x86_64), equals: ["arch" : "x86_64", "platform" : "macOS"])
        
        _assert(.device(.iOS, name: "Chris", id: nil), equals: ["name" : "Chris", "generic/platform" : "iOS"])
        _assert(.device(.iOS, name: "Chris", id: "123"), equals: ["id" : "123", "name" : "Chris", "generic/platform" : "iOS"])
        
        _assert(.simulator(.iOS, name: "Hello", os: .iOS(version: "10.1"), id: nil),
                equals: ["name" : "Hello", "OS" : "10.1", "platform" : "iOS Simulator"])
    }
    
    // MARK: Helper
    private func _assert(_ destination: Destination, equals properties: [String: String], file: StaticString = #file, line: UInt = #line) {
        XCTAssertTrue(destination.raw == properties, "failure", file: file, line: line)
    }
}
