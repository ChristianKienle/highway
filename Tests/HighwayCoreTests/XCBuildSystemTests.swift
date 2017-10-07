import XCTest
@testable import HighwayCore
import FileSystem
import Url
import TestKit
import Task

final class XCBuildSystemTests: XCTestCase {
    private var fs = InMemoryFileSystem()
    private var provider = ExecutableProviderMock()
    override func setUp() {
        super.setUp()
        fs = InMemoryFileSystem()
        provider = ExecutableProviderMock()
    }
    
    func testSwiftPackageThrowsIfExistsWithNonSUCCESSStatusCode() {
        
    }
    
    func testThatNoExecutionPlanIsGeneratedIfXcrunIsMissing() {
        // Create project dir, /usr/bin and required binaries
        XCTAssertNoThrow(try fs.createDirectory(at: Absolute("/Users/chris/project")))
        XCTAssertNoThrow(try fs.createDirectory(at: Absolute("/usr/bin")))
        XCTAssertNoThrow(try fs.writeData(Data(), to: Absolute("/usr/bin/xcrun_not_available")))
        XCTAssertNoThrow(try fs.writeData(Data(), to: Absolute("/usr/bin/xcpretty")))
        
        // Setup
        provider[Absolute("/usr/bin")] = ["xcrun_not_available", "xcpretty"]

        let bs = XCBuildSystem(executableProvider: provider, fileSystem: fs)
        let settings = Xcodebuild(projectDirectory: Absolute("/Users/chris/project"))
        
        // Tests
        XCTAssertThrowsError(try bs.executionPlan(settings: settings, outputStyle: .prettyIfAvailable))
    }
    
    func testThatXcprettyIsNotUsedWhenNotAvailable() {
        // Create project dir, /usr/bin and required binaries
        XCTAssertNoThrow(try fs.createDirectory(at: Absolute("/Users/chris/project")))
        XCTAssertNoThrow(try fs.createDirectory(at: Absolute("/usr/bin")))
        XCTAssertNoThrow(try fs.writeData(Data(), to: Absolute("/usr/bin/xcrun")))
        
        // Setup
        provider[Absolute("/usr/bin")] = ["xcrun"]
        let bs = XCBuildSystem(executableProvider: provider, fileSystem: fs)
        let settings = Xcodebuild(projectDirectory: Absolute("/Users/chris/project"))
        var plan: XCBuildSystem.ExecutionPlan?
        
        // Tests
        XCTAssertNoThrow(plan = try bs.executionPlan(settings: settings, outputStyle: .prettyIfAvailable))
        XCTAssertNotNil(plan)
        XCTAssertNil(plan?.xcprettyTask)
        XCTAssertEqual(plan?.xcodebuildTask.currentDirectoryUrl, Absolute("/Users/chris/project"))
        guard let xcodebuild = plan?.xcodebuildTask else {
            XCTFail()
            return
        }
        XCTAssertTrue(xcodebuild.output == Channel.standardOutput())
    }
    
    func testThatXcprettyIsNotUsedWhenNotRequested() {
        // Create project dir, /usr/bin and required binaries
        XCTAssertNoThrow(try fs.createDirectory(at: Absolute("/Users/chris/project")))
        XCTAssertNoThrow(try fs.createDirectory(at: Absolute("/usr/bin")))
        XCTAssertNoThrow(try fs.writeData(Data(), to: Absolute("/usr/bin/xcrun")))
        XCTAssertNoThrow(try fs.writeData(Data(), to: Absolute("/usr/bin/xcpretty")))
        
        // Setup
        provider[Absolute("/usr/bin")] = ["xcrun", "xcpretty"]
        let bs = XCBuildSystem(executableProvider: provider, fileSystem: fs)
        let settings = Xcodebuild(projectDirectory: Absolute("/Users/chris/project"))
        var plan: XCBuildSystem.ExecutionPlan?
        
        // Tests
        XCTAssertNoThrow(plan = try bs.executionPlan(settings: settings, outputStyle: .raw))
        XCTAssertNotNil(plan)
        XCTAssertNil(plan?.xcprettyTask)
        XCTAssertEqual(plan?.xcodebuildTask.currentDirectoryUrl, Absolute("/Users/chris/project"))
        guard let xcodebuild = plan?.xcodebuildTask else {
            XCTFail()
            return
        }
        XCTAssertTrue(xcodebuild.output == Channel.standardOutput())
    }
    
    func testExecutionPlanIsConfiguredCorrectlyIfAllIsGood() {
        // Create project dir, /usr/bin and required binaries
        XCTAssertNoThrow(try fs.createDirectory(at: Absolute("/Users/chris/project")))
        XCTAssertNoThrow(try fs.createDirectory(at: Absolute("/usr/bin")))
        XCTAssertNoThrow(try fs.writeData(Data(), to: Absolute("/usr/bin/xcrun")))
        XCTAssertNoThrow(try fs.writeData(Data(), to: Absolute("/usr/bin/xcpretty")))
        
        // Setup
        provider[Absolute("/usr/bin")] = ["xcrun", "xcpretty"]
        let bs = XCBuildSystem(executableProvider: provider, fileSystem: fs)
        let settings = Xcodebuild(projectDirectory: Absolute("/Users/chris/project"))
        var plan: XCBuildSystem.ExecutionPlan?
        
        // Tests
        XCTAssertNoThrow(plan = try bs.executionPlan(settings: settings, outputStyle: .prettyIfAvailable))
        XCTAssertNotNil(plan)
        XCTAssertNotNil(plan?.xcprettyTask)
        XCTAssertEqual(plan?.xcodebuildTask.currentDirectoryUrl, Absolute("/Users/chris/project"))
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
        XCTAssertNoThrow(try fs.createDirectory(at: Absolute("/Users/chris/project")))
        XCTAssertNoThrow(try fs.createDirectory(at: Absolute("/usr/bin")))
        XCTAssertNoThrow(try fs.writeData(Data(), to: Absolute("/usr/bin/xcrun")))
        XCTAssertNoThrow(try fs.writeData(Data(), to: Absolute("/usr/bin/xcpretty")))
        
        // Setup
        provider[Absolute("/usr/bin")] = ["xcrun", "xcpretty"]

        let bs = XCBuildSystem(executableProvider: provider, fileSystem: fs)
        let settings = Xcodebuild(projectDirectory: Absolute("/Users/chris/project"))
        do {
            let plan = try bs.executionPlan(settings: settings, outputStyle: .prettyIfAvailable)
            let executor = ExecutorMock()
            executor.mockExecution(of: plan.xcodebuildTask) { task in
                task.state = .terminated(.failure)
            }
            XCTAssertEqual(bs.execute(plan: plan, executor: executor), XCBuildSystem.Result.failure)
        } catch {
            XCTFail()
        }
    }
}

