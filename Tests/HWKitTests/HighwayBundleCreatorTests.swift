import XCTest
import HWKit
import HighwayCore
import TestKit
import FSKit

final class HighwayBundleCreatorTests: XCTestCase {
    func testSuccess() {
        let fs = InMemoryFileSystem()
        let url = AbsoluteUrl("/highway-go")
        let homeUrl = AbsoluteUrl("/.highway")
        XCTAssertNoThrow(try fs.createDirectory(at: url))
        XCTAssertNoThrow(try fs.createDirectory(at: homeUrl))
        let bundle: HighwayBundle
        let homeBundle: HomeBundle
        let config = HighwayBundle.Configuration.standard
        do {
            bundle = try HighwayBundle(url: url, fileSystem: fs, configuration: config)
            homeBundle = try HomeBundle(url: homeUrl, fileSystem: fs, configuration: .standard)
        } catch {
            XCTFail(error.localizedDescription)
            return
        }
        
        let creator = HighwayBundleCreator(bundle: bundle, homeBundle: homeBundle)
        XCTAssertNoThrow(try creator.create())
        
        XCTAssertTrue(fs.file(at: bundle.mainSwiftFileUrl).isExistingFile)
        XCTAssertTrue(fs.file(at: bundle.packageFileUrl).isExistingFile)
        XCTAssertTrue(fs.file(at: bundle.xcconfigFileUrl).isExistingFile)
    }
}
