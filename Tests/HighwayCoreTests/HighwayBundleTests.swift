import XCTest
import HighwayCore
import FileSystem
import Url

final class HighwayBundleTests: XCTestCase {
    private var fs = InMemoryFileSystem()
    private let config = HighwayBundle.Configuration.standard
    
    override func setUp() {
        super.setUp()
        fs = InMemoryFileSystem()
    }
    
    func testInitFailsIfDirectoryDoesNotExist() {
        XCTAssertThrowsError(try HighwayBundle(url: Absolute("/bundle"), fileSystem: fs))
        XCTAssertThrowsError(try HighwayBundle(fileSystem: fs, parentUrl: Absolute("/bundle")))
    }
    
    func testInitFailsIfUrlPointsToFile() {
        let url = Absolute("/bundle")
        XCTAssertNoThrow(try fs.writeData(Data(), to: url))
        XCTAssertThrowsError(try HighwayBundle(url: url, fileSystem: fs))
        XCTAssertNoThrow(try fs.writeData(Data(), to: Absolute("/bundle/\(HighwayBundle.Configuration.standard.directoryName)")))
        XCTAssertThrowsError(try HighwayBundle(fileSystem: fs, parentUrl: url))
    }
    
    func testInitWorksIfDirectoryExists() {
        XCTAssertNoThrow(try fs.createDirectory(at: Absolute("/dir/\(config.directoryName)")))
        XCTAssertNoThrow(try HighwayBundle(url: Absolute("/dir/\(config.directoryName)"), fileSystem: fs))
        XCTAssertNoThrow(try HighwayBundle(fileSystem: fs, parentUrl: Absolute("/dir")))
    }
    
    func testWriteMethods() throws {
        // Prepare the FS
        let url = Absolute("/dir/\(config.directoryName)")
        XCTAssertNoThrow(try fs.createDirectory(at: url))
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

    }
    
}
