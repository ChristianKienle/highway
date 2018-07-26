import XCTest
import HWKit
import TestKit
import ZFile
import Url

class BootstraperTests: XCTestCase {
    private var context = ContextMock()
    private var git = GitMock()
    
    override func setUp() {
        super.setUp()
        context = ContextMock()
        git = GitMock()
    }
    
    func testSuccess() {
        git.throwsEnabeld = false
        let homeDir = Absolute("/home")
        let bootstrapper = Bootstraper(homeDirectory: homeDir, configuration: .standard, git: git, context: context)
        let bundle: HomeBundle
        do {
            bundle = try bootstrapper.requestHomeBundle()
        } catch {
            XCTFail(error.localizedDescription)
            return
        }
        XCTAssertEqual(git.requestedClones.count, 1)
        XCTAssertNoThrow(try context.fileSystem.assertItem(at: bundle.url, is: .directory))
    }
}
