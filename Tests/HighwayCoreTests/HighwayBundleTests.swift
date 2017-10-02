import XCTest
import HighwayCore
import FSKit

final class HighwayBundleTests: XCTestCase {
    private var fs = InMemoryFileSystem()
    private let config = HighwayBundle.Configuration.standard
    
    override func setUp() {
        super.setUp()
        fs = InMemoryFileSystem()
    }
    
    func testInitFailsIfDirectoryDoesNotExist() {
        XCTAssertThrowsError(try HighwayBundle(url: AbsoluteUrl("/bundle"), fileSystem: fs))
        XCTAssertThrowsError(try HighwayBundle(parentUrl: AbsoluteUrl("/bundle"), fileSystem: fs))
    }
    
    func testInitFailsIfUrlPointsToFile() {
        let url = AbsoluteUrl("/bundle")
        XCTAssertNoThrow(try fs.writeData(Data(), to: url))
        XCTAssertThrowsError(try HighwayBundle(url: url, fileSystem: fs))
        XCTAssertNoThrow(try fs.writeData(Data(), to: AbsoluteUrl("/bundle/\(HighwayBundle.Configuration.standard.directoryName)")))
        XCTAssertThrowsError(try HighwayBundle(parentUrl: url, fileSystem: fs))
    }
    func testInitWorksIfDirectoryExists() {
        XCTAssertNoThrow(try fs.createDirectory(at: AbsoluteUrl("/dir/\(config.directoryName)")))
        XCTAssertNoThrow(try HighwayBundle(url: AbsoluteUrl("/dir/\(config.directoryName)"), fileSystem: fs))
        XCTAssertNoThrow(try HighwayBundle(parentUrl: AbsoluteUrl("/dir"), fileSystem: fs))
    }
    func testWriteMethods() {
        // Prepare the FS
        let url = AbsoluteUrl("/dir/\(config.directoryName)")
        XCTAssertNoThrow(try fs.createDirectory(at: url))
        do {
            let b = try HighwayBundle(url: url, fileSystem: fs)
            var input = Data([])
            
            // xcconfig
            input = Data([0x1])
            XCTAssertNoThrow(try b.write(xcconfigData: input))
            XCTAssertEqual(try fs.data(at: b.xcconfigFileUrl), input)
            
            // packageDescription
            input = Data([0x12])
            XCTAssertNoThrow(try b.write(packageDescription: input))
            XCTAssertEqual(try fs.data(at: b.packageFileUrl), input)

            // main.swift
            input = Data([0x14])
            XCTAssertThrowsError(try fs.assertItem(at: b.mainSwiftFileUrl, is: .file))
            XCTAssertNoThrow(try b.write(mainSwiftData: input))
            XCTAssertEqual(try fs.data(at: b.mainSwiftFileUrl), input)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
}
