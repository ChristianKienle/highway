import XCTest
@testable import HighwayCore
import TestKit
import FSKit

final class SwiftBuildSystemTests: XCTestCase {
    // MARK: - Properties
    private var system = SystemMock()
    private func fs() -> FileSystem {
        return system.context.fileSystem
    }
    private func _finder() -> ExecutableFinder {
        return system.context.executableFinder
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
        XCTAssertNoThrow(try fs().createDirectory(at: AbsoluteUrl("/Users/chris/project")))
        XCTAssertNoThrow(try fs().createDirectory(at: AbsoluteUrl("/usr/bin")))
        XCTAssertNoThrow(try fs().writeData(Data(), to: AbsoluteUrl("/usr/bin/xcrun_does_not_exist")))
        XCTAssertNoThrow(try fs().writeData(Data(), to: AbsoluteUrl("/usr/xcrun"))) // not searched
        
        // Setup
        _finder().searchURLs = [AbsoluteUrl("/usr/bin")]
        let options = SwiftOptions(subject: .product("myapp"), projectDirectory: AbsoluteUrl("/Users/chris/project"))
        
        // Tests
        XCTAssertThrowsError(try system.swift_build.executionPlan(with: options))
    }
    
    func testBuildFailsIfBinPathTaskFails() {
        // Create project dir, /usr/bin and required binaries
        XCTAssertNoThrow(try fs().createDirectory(at: AbsoluteUrl("/Users/chris/project")))
        XCTAssertNoThrow(try fs().createDirectory(at: AbsoluteUrl("/usr/bin")))
        XCTAssertNoThrow(try fs().writeData(Data(), to: AbsoluteUrl("/usr/bin/xcrun")))
        
        // Setup
        _finder().searchURLs = [AbsoluteUrl("/usr/bin")]
        let options = SwiftOptions(subject: .product("myapp"), projectDirectory: AbsoluteUrl("/Users/chris/project"))
        do {
            let plan = try _swift_build().executionPlan(with: options)
            XCTAssertEqual(plan.buildTask.executableURL, AbsoluteUrl("/usr/bin/xcrun"))
            XCTAssertEqual(plan.showBinPathTask.executableURL, AbsoluteUrl("/usr/bin/xcrun"))
            XCTAssertEqual(plan.buildTask.currentDirectoryUrl, AbsoluteUrl("/Users/chris/project"))
            XCTAssertEqual(plan.showBinPathTask.currentDirectoryUrl, AbsoluteUrl("/Users/chris/project"))
            _executor().mockExecution(of: plan.buildTask) { task in
                task.state = .finished(.success)
                task.output.withPipedFileHandleForWriting { handle in
                    handle.closeFile() // we have to close - otherwise the build system waits forever
                }
            }
            _executor().mockExecution(of: plan.showBinPathTask) { task in
                task.state = .finished(.failure)
            }
            XCTAssertThrowsError(try _swift_build().execute(plan: plan))
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testBuildFailsIfBuildTaskFails() {
        // Create project dir, /usr/bin and required binaries
        XCTAssertNoThrow(try fs().createDirectory(at: AbsoluteUrl("/Users/chris/project")))
        XCTAssertNoThrow(try fs().createDirectory(at: AbsoluteUrl("/usr/bin")))
        XCTAssertNoThrow(try fs().writeData(Data(), to: AbsoluteUrl("/usr/bin/xcrun")))
        
        // Setup
        _finder().searchURLs = [AbsoluteUrl("/usr/bin")]
        let options = SwiftOptions(subject: .product("myapp"), projectDirectory: AbsoluteUrl("/Users/chris/project"))
        do {
            let plan = try _swift_build().executionPlan(with: options)
            XCTAssertEqual(plan.buildTask.executableURL, AbsoluteUrl("/usr/bin/xcrun"))
            XCTAssertEqual(plan.showBinPathTask.executableURL, AbsoluteUrl("/usr/bin/xcrun"))
            XCTAssertEqual(plan.buildTask.currentDirectoryUrl, AbsoluteUrl("/Users/chris/project"))
            XCTAssertEqual(plan.showBinPathTask.currentDirectoryUrl, AbsoluteUrl("/Users/chris/project"))
            
            _executor().mockExecution(of: plan.buildTask) { task in
                task.state = .finished(.failure)
            }
            _executor().mockExecution(of: plan.showBinPathTask) { task in
                task.state = .finished(.success)
            }
            XCTAssertThrowsError(try _swift_build().execute(plan: plan))
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    func testExecutionFailsIfBinPathDoesNotExist() {
        // Create project dir, /usr/bin and required binaries
        XCTAssertNoThrow(try fs().createDirectory(at: AbsoluteUrl("/Users/chris/project")))
        XCTAssertNoThrow(try fs().createDirectory(at: AbsoluteUrl("/usr/bin")))
        XCTAssertNoThrow(try fs().writeData(Data(), to: AbsoluteUrl("/usr/bin/xcrun")))
        
        // Setup
        _finder().searchURLs = [AbsoluteUrl("/usr/bin")]
        let options = SwiftOptions(subject: .product("myapp"), projectDirectory: AbsoluteUrl("/Users/chris/project"))
        do {
            let plan = try _swift_build().executionPlan(with: options)
            XCTAssertEqual(plan.buildTask.executableURL, AbsoluteUrl("/usr/bin/xcrun"))
            XCTAssertEqual(plan.showBinPathTask.executableURL, AbsoluteUrl("/usr/bin/xcrun"))
            XCTAssertEqual(plan.buildTask.currentDirectoryUrl, AbsoluteUrl("/Users/chris/project"))
            XCTAssertEqual(plan.showBinPathTask.currentDirectoryUrl, AbsoluteUrl("/Users/chris/project"))
            
            
            _executor().mockExecution(of: plan.buildTask) { task in
                task.output.withPipedFileHandleForWriting { handle in
                    handle.write("> line1\n> line2")
                    handle.closeFile()
                }
                task.state = .finished(.success)
            }
            _executor().mockExecution(of: plan.showBinPathTask) { task in
                task.output.withPipedFileHandleForWriting { handle in
                    handle.write("/usr/bin/highway/which/does/not/exist")
                    handle.closeFile()
                }
                task.state = .finished(.success)
            }
            XCTAssertThrowsError(try _swift_build().execute(plan: plan))
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testSimpleSuccessfulBuild() {
        // Create project dir, /usr/bin and required binaries
        XCTAssertNoThrow(try fs().createDirectory(at: AbsoluteUrl("/Users/chris/project")))
        XCTAssertNoThrow(try fs().createDirectory(at: AbsoluteUrl("/usr/bin")))
        XCTAssertNoThrow(try fs().writeData(Data(), to: AbsoluteUrl("/usr/bin/xcrun")))
        XCTAssertNoThrow(try fs().writeData(Data(), to: AbsoluteUrl("/usr/bin/highway")))
        
        // Setup
        _finder().searchURLs = [AbsoluteUrl("/usr/bin")]
        let options = SwiftOptions(subject: .product("myapp"), projectDirectory: AbsoluteUrl("/Users/chris/project"))
        do {
            let plan = try _swift_build().executionPlan(with: options)
            XCTAssertEqual(plan.buildTask.executableURL, AbsoluteUrl("/usr/bin/xcrun"))
            XCTAssertEqual(plan.showBinPathTask.executableURL, AbsoluteUrl("/usr/bin/xcrun"))
            XCTAssertEqual(plan.buildTask.currentDirectoryUrl, AbsoluteUrl("/Users/chris/project"))
            XCTAssertEqual(plan.showBinPathTask.currentDirectoryUrl, AbsoluteUrl("/Users/chris/project"))
            
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
                task.state = .finished(.success)
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
                task.state = .finished(.success)
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
