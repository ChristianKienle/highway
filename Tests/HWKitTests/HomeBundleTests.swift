import XCTest
import HWKit
import HighwayCore
import ZFile
import Url

final class HomeBundleTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInit() {
        let fs = InMemoryFileSystem()
        let config = HomeBundle.Configuration.standard
        let url = Absolute.root.appending(config.directoryName)
        
        XCTAssertThrowsError(try HomeBundle(url: url, fileSystem: fs, configuration: config))
        XCTAssertNoThrow(try fs.createDirectory(at: url))
        XCTAssertNoThrow(try HomeBundle(url: url, fileSystem: fs, configuration: config))
    }
    
    func testMissingComponents() {
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
        
        let bundle: HomeBundle
        do {
            bundle = try HomeBundle(url: url, fileSystem: fs, configuration: config)
        } catch {
            XCTFail(error.localizedDescription)
            return
        }
        
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
