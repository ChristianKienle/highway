import XCTest
@testable import HighwayCore
import FSKit

final class TaskTests: XCTestCase {
    func testTaskTaskCanBeTransformedToProcessBySystemExecutor() {
        let executor = SystemExecutor()
        let exeUrl = AbsoluteUrl("/usr/bin/ls")
        let currentDirectoryUrl = AbsoluteUrl("/Users/chris/test")
        let arguments = ["hello"]
        let env = ["test":"value"]
        let task = Task(executableURL: exeUrl, arguments: arguments, environment: env, currentDirectoryURL: currentDirectoryUrl)
        let errorIO = TaskIOChannel.pipe(Pipe())
        let outputIO = TaskIOChannel.pipe(Pipe())
        let inputIO = TaskIOChannel.pipe(Pipe())
        
        task.error = errorIO
        task.output = outputIO
        task.input = inputIO

        let process = executor._process(with: task)
        
        XCTAssertNotNil(process.launchPath)
        XCTAssertEqual(process.launchPath, exeUrl.path)

        XCTAssertEqual(process.currentDirectoryPath, currentDirectoryUrl.path)

        XCTAssertNotNil(process.arguments)
        XCTAssertEqual(process.arguments ?? [], arguments)
        XCTAssertTrue((process.environment?.contains { (key, value) in
            return key == "test" && value == "value"
        }) ?? false)
        
        XCTAssertNotNil(process.standardOutput)
        XCTAssertTrue(process.standardOutput is Pipe)

        XCTAssertNotNil(process.standardError)
        XCTAssertTrue(process.standardError is Pipe)

        XCTAssertNotNil(process.standardInput)
        XCTAssertTrue(process.standardInput is Pipe)
    }
}
