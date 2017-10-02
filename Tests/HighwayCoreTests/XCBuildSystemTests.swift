import XCTest
@testable import HighwayCore
import FSKit

final class XCBuildSystemTests: XCTestCase {
    private var fs = InMemoryFileSystem()
    override func setUp() {
        super.setUp()
        fs = InMemoryFileSystem()
    }
    
    func testSwiftPackageThrowsIfExistsWithNonSUCCESSStatusCode() {
        
    }
    
    func testThatNoExecutionPlanIsGeneratedIfXcrunIsMissing() {
        // Create project dir, /usr/bin and required binaries
        XCTAssertNoThrow(try fs.createDirectory(at: AbsoluteUrl("/Users/chris/project")))
        XCTAssertNoThrow(try fs.createDirectory(at: AbsoluteUrl("/usr/bin")))
        XCTAssertNoThrow(try fs.writeData(Data(), to: AbsoluteUrl("/usr/bin/xcrun_not_available")))
        XCTAssertNoThrow(try fs.writeData(Data(), to: AbsoluteUrl("/usr/bin/xcpretty")))
        
        // Setup
        let finder = ExecutableFinder(searchURLs: [AbsoluteUrl("/usr/bin")], fileSystem: fs)
        let bs = XCBuildSystem(executableFinder: finder, fileSystem: fs)
        let settings = Xcodebuild(projectDirectory: AbsoluteUrl("/Users/chris/project"))
        
        // Tests
        XCTAssertThrowsError(try bs.executionPlan(settings: settings, outputStyle: .prettyIfAvailable))
    }
    
    func testThatXcprettyIsNotUsedWhenNotAvailable() {
        // Create project dir, /usr/bin and required binaries
        XCTAssertNoThrow(try fs.createDirectory(at: AbsoluteUrl("/Users/chris/project")))
        XCTAssertNoThrow(try fs.createDirectory(at: AbsoluteUrl("/usr/bin")))
        XCTAssertNoThrow(try fs.writeData(Data(), to: AbsoluteUrl("/usr/bin/xcrun")))
        
        // Setup
        let finder = ExecutableFinder(searchURLs: [AbsoluteUrl("/usr/bin")], fileSystem: fs)
        let bs = XCBuildSystem(executableFinder: finder, fileSystem: fs)
        let settings = Xcodebuild(projectDirectory: AbsoluteUrl("/Users/chris/project"))
        var plan: XCBuildSystem.ExecutionPlan?
        
        // Tests
        XCTAssertNoThrow(plan = try bs.executionPlan(settings: settings, outputStyle: .prettyIfAvailable))
        XCTAssertNotNil(plan)
        XCTAssertNil(plan?.xcprettyTask)
        XCTAssertEqual(plan?.xcodebuildTask.currentDirectoryUrl, AbsoluteUrl("/Users/chris/project"))
        guard let xcodebuild = plan?.xcodebuildTask else {
            XCTFail()
            return
        }
        XCTAssertTrue(xcodebuild.output == TaskIOChannel.fileHandle(.standardOutput))
    }
    
    func testThatXcprettyIsNotUsedWhenNotRequested() {
        // Create project dir, /usr/bin and required binaries
        XCTAssertNoThrow(try fs.createDirectory(at: AbsoluteUrl("/Users/chris/project")))
        XCTAssertNoThrow(try fs.createDirectory(at: AbsoluteUrl("/usr/bin")))
        XCTAssertNoThrow(try fs.writeData(Data(), to: AbsoluteUrl("/usr/bin/xcrun")))
        XCTAssertNoThrow(try fs.writeData(Data(), to: AbsoluteUrl("/usr/bin/xcpretty")))
        
        // Setup
        let finder = ExecutableFinder(searchURLs: [AbsoluteUrl("/usr/bin")], fileSystem: fs)
        let bs = XCBuildSystem(executableFinder: finder, fileSystem: fs)
        let settings = Xcodebuild(projectDirectory: AbsoluteUrl("/Users/chris/project"))
        var plan: XCBuildSystem.ExecutionPlan?
        
        // Tests
        XCTAssertNoThrow(plan = try bs.executionPlan(settings: settings, outputStyle: .raw))
        XCTAssertNotNil(plan)
        XCTAssertNil(plan?.xcprettyTask)
        XCTAssertEqual(plan?.xcodebuildTask.currentDirectoryUrl, AbsoluteUrl("/Users/chris/project"))
        guard let xcodebuild = plan?.xcodebuildTask else {
            XCTFail()
            return
        }
        XCTAssertTrue(xcodebuild.output == TaskIOChannel.fileHandle(.standardOutput))
    }
    
    func testExecutionPlanIsConfiguredCorrectlyIfAllIsGood() {
        // Create project dir, /usr/bin and required binaries
        XCTAssertNoThrow(try fs.createDirectory(at: AbsoluteUrl("/Users/chris/project")))
        XCTAssertNoThrow(try fs.createDirectory(at: AbsoluteUrl("/usr/bin")))
        XCTAssertNoThrow(try fs.writeData(Data(), to: AbsoluteUrl("/usr/bin/xcrun")))
        XCTAssertNoThrow(try fs.writeData(Data(), to: AbsoluteUrl("/usr/bin/xcpretty")))
        
        // Setup
        let finder = ExecutableFinder(searchURLs: [AbsoluteUrl("/usr/bin")], fileSystem: fs)
        let bs = XCBuildSystem(executableFinder: finder, fileSystem: fs)
        let settings = Xcodebuild(projectDirectory: AbsoluteUrl("/Users/chris/project"))
        var plan: XCBuildSystem.ExecutionPlan?
        
        // Tests
        XCTAssertNoThrow(plan = try bs.executionPlan(settings: settings, outputStyle: .prettyIfAvailable))
        XCTAssertNotNil(plan)
        XCTAssertNotNil(plan?.xcprettyTask)
        XCTAssertEqual(plan?.xcodebuildTask.currentDirectoryUrl, AbsoluteUrl("/Users/chris/project"))
        guard let xcpretty = plan?.xcprettyTask else {
            XCTFail()
            return
        }
        guard let xcodebuild = plan?.xcodebuildTask else {
            XCTFail()
            return
        }
        XCTAssertTrue(xcodebuild.output == xcpretty.input)
    }
    
    func testBuildSystemFailsIfXcodebuildFails() {
        // Create project dir, /usr/bin and required binaries
        XCTAssertNoThrow(try fs.createDirectory(at: AbsoluteUrl("/Users/chris/project")))
        XCTAssertNoThrow(try fs.createDirectory(at: AbsoluteUrl("/usr/bin")))
        XCTAssertNoThrow(try fs.writeData(Data(), to: AbsoluteUrl("/usr/bin/xcrun")))
        XCTAssertNoThrow(try fs.writeData(Data(), to: AbsoluteUrl("/usr/bin/xcpretty")))
        
        // Setup
        let finder = ExecutableFinder(searchURLs: [AbsoluteUrl("/usr/bin")], fileSystem: fs)
        let bs = XCBuildSystem(executableFinder: finder, fileSystem: fs)
        let settings = Xcodebuild(projectDirectory: AbsoluteUrl("/Users/chris/project"))
        do {
            let plan = try bs.executionPlan(settings: settings, outputStyle: .prettyIfAvailable)
            let executor = XCExecutorMock(executionPlan: plan)
            XCTAssertEqual(bs.execute(plan: plan, executor: executor), XCBuildSystem.Result.failure)
        } catch {
            XCTFail()
        }
    }
}


/// Mocked Executor
private final class XCExecutorMock: TaskExecutor {
    let plan: XCBuildSystem.ExecutionPlan
    init(executionPlan: XCBuildSystem.ExecutionPlan) {
        self.plan = executionPlan
    }
    func execute(tasks: [Task]) {
        plan.xcodebuildTask.state = .finished(.init(terminationReason: .exit, terminationStatus: EXIT_FAILURE))
    }
}
