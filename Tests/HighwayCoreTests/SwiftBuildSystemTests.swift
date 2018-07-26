import XCTest
@testable import HighwayCore
import TestKit
import ZFile
import Url
import Task

final class SwiftBuildSystemTests: XCTestCase {
    // MARK: - Properties
    private var system = SystemMock()
    private func fs() -> FileSystem {
        return system.context.fileSystem
    }
    private func _finder() -> ExecutableProviderMock {
        return system.context.executableProviderMock
    }
    private func _executor() -> ExecutorMock {
        return system.context.executorMock
    }
    private func _swift_build() -> SwiftBuildSystem {
        return system.swift_build
    }

    // MARK: - XCTest
    override func setUp() {
        super.setUp()
        system = SystemMock()
    }
    
    // MARK: - Tests
    func testPlanCreationFailsWithoutXCRun() {
        // Create project dir, /usr/bin and required binaries
        XCTAssertNoThrow(try fs().createDirectory(at: Absolute("/Users/chris/project")))
        XCTAssertNoThrow(try fs().createDirectory(at: Absolute("/usr/bin")))
        XCTAssertNoThrow(try fs().writeData(Data(), to: Absolute("/usr/bin/xcrun_does_not_exist")))
        XCTAssertNoThrow(try fs().writeData(Data(), to: Absolute("/usr/xcrun"))) // not searched
        
        // Setup
        _finder()[Absolute("/usr/bin")] = ["xcrun_does_not_exist"]
//        _finder()[Absolute("/usr")] = ["xcrun"]
        
        let options = SwiftOptions(subject: .product("myapp"), projectDirectory: Absolute("/Users/chris/project"))
        
        // Tests
        XCTAssertThrowsError(try system.swift_build.executionPlan(with: options))
    }
    
    func testBuildFailsIfBinPathTaskFails() {
        // Create project dir, /usr/bin and required binaries
        XCTAssertNoThrow(try fs().createDirectory(at: Absolute("/Users/chris/project")))
        XCTAssertNoThrow(try fs().createDirectory(at: Absolute("/usr/bin")))
        XCTAssertNoThrow(try fs().writeData(Data(), to: Absolute("/usr/bin/xcrun")))
        
        // Setup
        _finder()[Absolute("/usr/bin")] = ["xcrun"]
        let options = SwiftOptions(subject: .product("myapp"), projectDirectory: Absolute("/Users/chris/project"))
        do {
            let plan = try _swift_build().executionPlan(with: options)
            XCTAssertEqual(plan.buildTask.executableUrl, Absolute("/usr/bin/xcrun"))
            XCTAssertEqual(plan.showBinPathTask.executableUrl, Absolute("/usr/bin/xcrun"))
            XCTAssertEqual(plan.buildTask.currentDirectoryUrl, Absolute("/Users/chris/project"))
            XCTAssertEqual(plan.showBinPathTask.currentDirectoryUrl, Absolute("/Users/chris/project"))
            _executor().mockExecution(of: plan.buildTask) { task in
                task.state = .terminated(.success)
                task.output.withPipedFileHandleForWriting { handle in
                    handle.closeFile() // we have to close - otherwise the build system waits forever
                }
            }
            _executor().mockExecution(of: plan.showBinPathTask) { task in
                task.state = .terminated(.failure)
            }
            XCTAssertThrowsError(try _swift_build().execute(plan: plan))
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testBuildFailsIfBuildTaskFails() {
        // Create project dir, /usr/bin and required binaries
        XCTAssertNoThrow(try fs().createDirectory(at: Absolute("/Users/chris/project")))
        XCTAssertNoThrow(try fs().createDirectory(at: Absolute("/usr/bin")))
        XCTAssertNoThrow(try fs().writeData(Data(), to: Absolute("/usr/bin/xcrun")))
        
        // Setup
        _finder()[Absolute("/usr/bin")] = ["xcrun"]

        let options = SwiftOptions(subject: .product("myapp"), projectDirectory: Absolute("/Users/chris/project"))
        do {
            let plan = try _swift_build().executionPlan(with: options)
            XCTAssertEqual(plan.buildTask.executableUrl, Absolute("/usr/bin/xcrun"))
            XCTAssertEqual(plan.showBinPathTask.executableUrl, Absolute("/usr/bin/xcrun"))
            XCTAssertEqual(plan.buildTask.currentDirectoryUrl, Absolute("/Users/chris/project"))
            XCTAssertEqual(plan.showBinPathTask.currentDirectoryUrl, Absolute("/Users/chris/project"))
            
            _executor().mockExecution(of: plan.buildTask) { task in
                task.state = .terminated(.failure)
            }
            _executor().mockExecution(of: plan.showBinPathTask) { task in
                task.state = .terminated(.success)
            }
            XCTAssertThrowsError(try _swift_build().execute(plan: plan))
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    func testExecutionFailsIfBinPathDoesNotExist() {
        // Create project dir, /usr/bin and required binaries
        XCTAssertNoThrow(try fs().createDirectory(at: Absolute("/Users/chris/project")))
        XCTAssertNoThrow(try fs().createDirectory(at: Absolute("/usr/bin")))
        XCTAssertNoThrow(try fs().writeData(Data(), to: Absolute("/usr/bin/xcrun")))
        
        // Setup
        let options = SwiftOptions(subject: .product("myapp"), projectDirectory: Absolute("/Users/chris/project"))
        do {
            _finder()[Absolute("/usr/bin")] = ["xcrun"]
            let plan = try _swift_build().executionPlan(with: options)
            XCTAssertEqual(plan.buildTask.executableUrl, Absolute("/usr/bin/xcrun"))
            XCTAssertEqual(plan.showBinPathTask.executableUrl, Absolute("/usr/bin/xcrun"))
            XCTAssertEqual(plan.buildTask.currentDirectoryUrl, Absolute("/Users/chris/project"))
            XCTAssertEqual(plan.showBinPathTask.currentDirectoryUrl, Absolute("/Users/chris/project"))
            
            
            _executor().mockExecution(of: plan.buildTask) { task in
                task.output.withPipedFileHandleForWriting { handle in
                    handle.write("> line1\n> line2")
                    handle.closeFile()
                }
                task.state = .terminated(.success)
            }
            _executor().mockExecution(of: plan.showBinPathTask) { task in
                task.output.withPipedFileHandleForWriting { handle in
                    handle.write("/usr/bin/highway/which/does/not/exist")
                    handle.closeFile()
                }
                task.state = .terminated(.success)
            }
            XCTAssertThrowsError(try _swift_build().execute(plan: plan))
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testSimpleSuccessfulBuild() {
        // Create project dir, /usr/bin and required binaries
        XCTAssertNoThrow(try fs().createDirectory(at: Absolute("/Users/chris/project")))
        XCTAssertNoThrow(try fs().createDirectory(at: Absolute("/usr/bin")))
        XCTAssertNoThrow(try fs().writeData(Data(), to: Absolute("/usr/bin/xcrun")))
        XCTAssertNoThrow(try fs().writeData(Data(), to: Absolute("/usr/bin/highway")))
        
        // Setup
        _finder()[Absolute("/usr/bin")] = ["xcrun"]
        let options = SwiftOptions(subject: .product("myapp"), projectDirectory: Absolute("/Users/chris/project"))
        do {
            let plan = try _swift_build().executionPlan(with: options)
            XCTAssertEqual(plan.buildTask.executableUrl, Absolute("/usr/bin/xcrun"))
            XCTAssertEqual(plan.showBinPathTask.executableUrl, Absolute("/usr/bin/xcrun"))
            XCTAssertEqual(plan.buildTask.currentDirectoryUrl, Absolute("/Users/chris/project"))
            XCTAssertEqual(plan.showBinPathTask.currentDirectoryUrl, Absolute("/Users/chris/project"))
            
            _executor().mockExecution(of: plan.buildTask) { task in
                let sem = DispatchSemaphore(value: 0)
                plan.buildTask.output.didRead = { _ in
                    sem.signal()
                }
                task.output.writeabilityHandler = { handle in
                    handle.write("> line1\n> line2")
                    handle.close()
                }
                sem.wait()
                task.state = .terminated(.success)
            }
            _executor().mockExecution(of: plan.showBinPathTask) { task in
                let sem = DispatchSemaphore(value: 0)
                plan.showBinPathTask.output.didRead = { _ in
                    sem.signal()
                }
                task.output.writeabilityHandler = { handle in
                    handle.write("/usr/bin")
                    handle.close()
                }
                sem.wait()
                task.state = .terminated(.success)
            }
            
            let artifact = try _swift_build().execute(plan: plan)
            XCTAssertEqual(artifact.binPath, "/usr/bin")
            XCTAssertEqual(artifact.buildOutput, "> line1\n> line2")
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
}

fileprivate class SystemMock {
    init() {
        context = ContextMock()
        swift_build = SwiftBuildSystem(context: context)
    }
    let context: ContextMock
    let swift_build: SwiftBuildSystem
}
