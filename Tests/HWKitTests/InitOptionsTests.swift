import XCTest
import HWKit

final class InitOptionsTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testDefaultOptions() {
        XCTAssertEqual(try InitOptions([]),
                       .init(projectType: .swift, shouldCreateProject: false))
    }

    func testSwift_NoProjectCreation() {
        XCTAssertEqual(try InitOptions(["--type", "swift"]),
                       .init(projectType: .swift, shouldCreateProject: false))
    }
    
    func testSwift_ProjectCreation() {
        XCTAssertEqual(try InitOptions(["--type", "swift", "--create-project"]),
                       .init(projectType: .swift, shouldCreateProject: true))

    }

    func testXcode_with_create_project() {
        XCTAssertThrowsError(try InitOptions(["--type", "xcode", "--create-project"]))
    }
    
    func testXcode_with_unknown_option() {
        XCTAssertThrowsError(try InitOptions(["--unknown", "xcode"]))
    }
    
    func testXcode_with_unknown_projectType() {
        XCTAssertThrowsError(try InitOptions(["--type", "none"]))
    }
    
    func testXcode_without_projectType() {
        XCTAssertThrowsError(try InitOptions(["--type"]))
    }
    func testXcode_without_projectType_and_option() {
        XCTAssertThrowsError(try InitOptions(["--type", "--create-project"]))
    }

}
