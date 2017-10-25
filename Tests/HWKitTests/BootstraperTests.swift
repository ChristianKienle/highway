import XCTest
import HWKit
import TestKit
import FileSystem
import Url

final class BootstraperTests: XCTestCase {
    func testSuccess() {
        let  git = GitMock()
        git.throwsEnabeld = false
        let homeDir = Absolute("/home")
        let fileSystem = InMemoryFileSystem()
        let bootstrapper = Bootstraper(homeDirectory: homeDir, configuration: .standard, git: git, fileSystem: fileSystem)
        let bundle: HomeBundle
        do {
            bundle = try bootstrapper.requestHomeBundle()
        } catch {
            XCTFail(error.localizedDescription)
            return
        }
        XCTAssertEqual(git.requestedClones.count, 1)
        XCTAssertNoThrow(try fileSystem.assertItem(at: bundle.url, is: .directory))
    }
}
