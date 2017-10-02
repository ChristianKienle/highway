import XCTest
import FSKit

class AnchoredFileSystemTests: XCTestCase {
    private var fs = AnchoredFileSystem(underlyingFileSystem: InMemoryFileSystem(), achnoredAt: .root)

    override func setUp() {
        super.setUp()
            super.setUp()
        let inMemory = InMemoryFileSystem()
        let anchorUrl = AbsoluteUrl("/Users/chris")
        do {
            try inMemory.createDirectory(at: anchorUrl)
        } catch {
            XCTFail()
        }
            fs = AnchoredFileSystem(underlyingFileSystem: inMemory, achnoredAt: anchorUrl)
    }
    
    override func tearDown() {
        super.tearDown()
    }

    
    // MARK: Tests
    func testEmpty() {
        let url = AbsoluteUrl("/Users/test")
        let file = fs.file(at: url)
        _assertThrowsFileSystemError(try file.data()) { error in
            XCTAssertTrue(error.isDoesNotExistError)
        }
        
    }
    func testSingleFileExistence() {
        let url = AbsoluteUrl("/simple_file")
        let input = "hello world"
        XCTAssertNoThrow(try fs.writeString(input, to: url))
        XCTAssertEqual(try fs.file(at: url).string(), input)
    }
    
    func testFileInSubdirectoryCanBeFound() {
        XCTAssertNoThrow(try fs.createDirectory(at: AbsoluteUrl("/folderA")))
        XCTAssertNoThrow(try fs.writeString("Hello World", to: AbsoluteUrl("/folderA/simple_file")))
        XCTAssertEqual(try fs.file(at: AbsoluteUrl("/folderA/simple_file")).string(), "Hello World")
    }
    
    func testComplextExistenceScenarios() {
        XCTAssertNoThrow(try fs.createDirectory(at: AbsoluteUrl("/d1/d1-1")))
        XCTAssertNoThrow(try fs.writeString("file d1-1-1", to: AbsoluteUrl("/d1/d1-1/f1-1-1")))
        XCTAssertEqual(try fs.file(at: AbsoluteUrl("/d1/d1-1/f1-1-1")).string(), "file d1-1-1")
        XCTAssertNoThrow(try fs.writeString("file d1-1-2", to: AbsoluteUrl("/d1/d1-1/f1-1-2")))
        XCTAssertEqual(try fs.file(at: AbsoluteUrl("/d1/d1-1/f1-1-2")).string(), "file d1-1-2")
        XCTAssertEqual(try fs.file(at: AbsoluteUrl("/d1/d1-1/f1-1-1")).string(), "file d1-1-1")
    }
    
    func testWriteData() {
        let fileURL = AbsoluteUrl("/test.txt")
        XCTAssertThrowsError(try fs.writeString("x", to: AbsoluteUrl("/users/cmk/test.txt")))
        XCTAssertNoThrow(try fs.writeString("hello", to: fileURL))
        XCTAssertEqual(try fs.file(at: fileURL).string(), "hello")
    }
    
    func testCreateDirectory() {
        let usersDir = AbsoluteUrl("/users")
        let userFile = usersDir.appending("chris.txt")
        
        XCTAssertNoThrow(try fs.createDirectory(at: usersDir))
        XCTAssertNoThrow(try fs.writeString("ich", to: userFile))
        let users = fs.directory(at: usersDir)
        XCTAssertEqual(try users.file(named: "chris.txt").string(), "ich")
        
        XCTAssertNoThrow(try fs.createDirectory(at: AbsoluteUrl("/l1/l2")))
        XCTAssertNoThrow(try fs.writeString("jsonbla", to: AbsoluteUrl("/l1/l2/file.json")))
        
        XCTAssertEqual(try fs.file(at: AbsoluteUrl("/l1/l2/file.json")).string(), "jsonbla")
    }
    
    func testCreateDirectory_with_trailing_slash() {
        XCTAssertNoThrow(try fs.createDirectory(at: AbsoluteUrl("/users/")), "")
        XCTAssertNoThrow(try fs.writeString("ich", to: AbsoluteUrl("/users/test/")))
        
        XCTAssertEqual(try fs.directory(at: AbsoluteUrl("/users")).file(named: "test").string(), "ich")
    }
    
    func testDelete() {
        XCTAssertNoThrow(try fs.createDirectory(at: AbsoluteUrl("/l1/l2")), "")
        XCTAssertNoThrow(try fs.writeString("content", to: AbsoluteUrl("/l1/l2/bla.txt")), "")
        XCTAssertEqual(try fs.file(at: AbsoluteUrl("/l1/l2/bla.txt")).string(), "content", "")
        XCTAssertNoThrow(try fs.deleteItem(at: AbsoluteUrl("/l1/l2/bla.txt")))
        _assertThrowsFileSystemError(try fs.file(at: AbsoluteUrl("/l1/l2/bla.txt")).string()) { error in
            XCTAssertTrue(error.isDoesNotExistError)
            print(error)
            let failure = !error.isDoesNotExistError
            if failure {
                print("doh")
            }
        }
        
        
    }
}
