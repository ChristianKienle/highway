import XCTest
import HighwayCore
import ZFile
import Url
@testable import Task
import Arguments

final class TaskTests: XCTestCase {
    func testTaskTaskCanBeTransformedToProcessBySystemExecutor() {
        let exeUrl = Absolute("/usr/bin/ls")
        let currentDirectoryUrl = Absolute("/Users/chris/test")
        let arguments: Arguments = ["hello"]
        let env = ["test":"value"]
        let task = Task(executableUrl: exeUrl, arguments: arguments, currentDirectoryUrl: currentDirectoryUrl)
        task.environment = env
        let outputIO = Channel.pipe()
        let inputIO = Channel.pipe()
        
        task.output = outputIO
        task.input = inputIO

        let process = task.toProcess
        
        XCTAssertNotNil(process.launchPath)
        XCTAssertEqual(process.launchPath, exeUrl.path)

        XCTAssertEqual(process.currentDirectoryPath, currentDirectoryUrl.path)

        XCTAssertNotNil(process.arguments)
        XCTAssertEqual(process.arguments ?? [], arguments.all)
        XCTAssertTrue((process.environment?.contains { (key, value) in
            return key == "test" && value == "value"
        }) ?? false)
        
        XCTAssertNotNil(process.standardOutput)
        XCTAssertTrue(process.standardOutput is Pipe)

        XCTAssertNotNil(process.standardInput)
        XCTAssertTrue(process.standardInput is Pipe)
    }
}
