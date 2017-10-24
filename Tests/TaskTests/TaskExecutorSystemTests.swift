import XCTest
import HighwayCore
import Task
import TestKit

final class TaskExecutorSystemTests: XCTestCase {
    private let provider = SystemExecutableProvider.local()
    private let executor = SystemExecutor(ui: MockUI())
    
    func testOutputCapturing() throws {
        let echo = try Task(commandName: "echo", provider: provider)
        echo.arguments = ["hello"]
        echo.output = .pipe()
        echo.enableReadableOutputDataCapturing()
        executor.execute(task: echo)
        XCTAssertNotNil(echo.capturedOutputString)
        XCTAssertEqual(echo.capturedOutputString, "hello\n")
    }
    
    func testWriteLotsOfDataAndReadItBackViaCat() throws {
        let fileUrl = URL(fileURLWithPath: #file).deletingLastPathComponent().appendingPathComponent("Fixtures", isDirectory: true).appendingPathComponent("BigTextFile.text")
        let fixtureData = try Data(contentsOf: fileUrl)
        let task = try Task(commandName: "cat", provider: provider)
        task.arguments = ["-u", fileUrl.path]
        task.output = .pipe()
        var outputData = Data()
        task.output.readabilityHandler = { handle in
            handle.withAvailableData { newData in
                outputData += newData
            }
        }
        executor.execute(task: task) // sync
        let outString = String(data: outputData, encoding: .utf8)
        XCTAssertNotNil(outString)
        XCTAssertTrue((outString?.lengthOfBytes(using: .utf8) ?? 0) > 0)
        XCTAssertEqual(fixtureData, outputData)
    }
    
    func testSimpleChainedTasks() throws {
        let echo = try Task(commandName: "echo", provider: provider)
        echo.arguments = ["hello"]
        let wc = try Task(commandName: "wc", provider: provider)
        wc.arguments = ["-l"]
        echo.output = .pipe()
        wc.input = echo.output
        wc.enableReadableOutputDataCapturing()
        executor.launch(task: echo, wait: false)
        executor.execute(task: wc)
        let outString = wc.capturedOutputString
        XCTAssertNotNil(outString)
        XCTAssertTrue((outString?.lengthOfBytes(using: .utf8) ?? 0) > 0)
    }
}
