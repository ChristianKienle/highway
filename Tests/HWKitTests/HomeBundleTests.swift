import XCTest
import HWKit
import HighwayCore
import FileSystem
import Url

final class HomeBundleTests: XCTestCase {
    func testInit() {
        let fs = InMemoryFileSystem()
        let config = HomeBundle.Configuration.standard
        let url = Absolute.root.appending(config.directoryName)
        
        XCTAssertThrowsError(try HomeBundle(url: url, fileSystem: fs, configuration: config))
        XCTAssertNoThrow(try fs.createDirectory(at: url))
        XCTAssertNoThrow(try HomeBundle(url: url, fileSystem: fs, configuration: config))
    }
    
    func testMissingComponents() throws {
        let fs = InMemoryFileSystem()
        let config = HomeBundle.Configuration.standard
        let url = Absolute.root.appending(config.directoryName)
        
        XCTAssertNoThrow(try fs.createDirectory(at: url))
        let binDir = url.appending(HomeBundle.Component.binDir.rawValue)
        let highwayCLIUrl = url.appending(HomeBundle.Component.highwayCLI.rawValue)
        let cloneUrl = url.appending(HomeBundle.Component.clone.rawValue)
        
        XCTAssertNoThrow(try fs.createDirectory(at: binDir))
        XCTAssertNoThrow(try fs.writeData(Data(), to: highwayCLIUrl))
        XCTAssertNoThrow(try fs.createDirectory(at: cloneUrl))
        
        let bundle = try HomeBundle(url: url, fileSystem: fs, configuration: config)
        
        // At this point the fs contains a valid home bundle...
        // Make sure HomeBundle acks that.
        XCTAssertTrue(bundle.missingComponents().isEmpty)
        
        // Now remove the expected components one by one
        XCTAssertNoThrow(try fs.deleteItem(at: highwayCLIUrl))
        XCTAssertEqual(bundle.missingComponents(), [.highwayCLI])
        
        XCTAssertNoThrow(try fs.deleteItem(at: cloneUrl))
        XCTAssertEqual(bundle.missingComponents(), [.highwayCLI, .clone])
        
        XCTAssertNoThrow(try fs.deleteItem(at: binDir))
        XCTAssertEqual(bundle.missingComponents(), [.binDir, .highwayCLI, .clone])

        // Check we forgot nothing
        let all: Set<HomeBundle.Component> = [.binDir, .highwayCLI, .clone]
        XCTAssertEqual(bundle.missingComponents(), all)
    }
}
