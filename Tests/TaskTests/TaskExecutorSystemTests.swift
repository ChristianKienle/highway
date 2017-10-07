import XCTest
import HighwayCore
import Task
import TestKit

final class TaskExecutorSystemTests: XCTestCase {
    private let provider = SystemExecutableProvider.local()
    private let executor = SystemExecutor(ui: MockUI())
    
    func testOutputCapturing() {
        do {
            let echo = try Task(commandName: "echo", provider: provider)
            echo.arguments = ["hello"]
            
            echo.output = .pipe()
            echo.enableReadableOutputDataCapturing()
            executor.execute(tasks: [echo])
            XCTAssertNotNil(echo.capturedOutputString)
            XCTAssertEqual(echo.capturedOutputString, "hello\n")
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testWriteLotsOfDataAndReadItBackViaCat() {
        let fileUrl = URL(fileURLWithPath: #file).deletingLastPathComponent().appendingPathComponent("Fixtures", isDirectory: true).appendingPathComponent("BigTextFile.text")
        let task: Task
        let fixtureData: Data
        do {
            fixtureData = try Data(contentsOf: fileUrl)
            task = try Task(commandName: "cat", provider: provider)
            task.arguments = ["-u", fileUrl.path]
        } catch {
            XCTFail(error.localizedDescription)
            return
        }
        task.output = .pipe()
        var outputData = Data()
        task.output.readabilityHandler = { handle in
            handle.withAvailableData { newData in
                outputData += newData
            }
        }
        
        executor.execute(tasks: [task]) // sync
        let outString = String(data: outputData, encoding: .utf8)
        XCTAssertNotNil(outString)
        XCTAssertTrue((outString?.lengthOfBytes(using: .utf8) ?? 0) > 0)
        XCTAssertEqual(fixtureData, outputData)
    }
    func testSimpleChainedTasks() {
        let echo: Task
        let wc: Task
        do {
            echo = try Task(commandName: "echo", provider: provider)
            echo.arguments = ["hello"]
            wc = try Task(commandName: "wc", provider: provider)
            wc.arguments = ["-l"]
        } catch {
            XCTFail(error.localizedDescription)
            return
        }
        echo.output = .pipe()
        wc.input = echo.output
        wc.enableReadableOutputDataCapturing()
        executor.execute(tasks: [echo, wc]) // sync
        let outString = wc.capturedOutputString
        XCTAssertNotNil(outString)
        XCTAssertTrue((outString?.lengthOfBytes(using: .utf8) ?? 0) > 0)
    }
}
