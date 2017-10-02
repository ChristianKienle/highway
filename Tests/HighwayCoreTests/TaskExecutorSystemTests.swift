import XCTest
import HighwayCore

final class TaskExecutorSystemTests: XCTestCase {
    private var ctx = Context.local()
    func testOutputCapturing() {
        do {
            let echo = try Task(commandName: "echo", arguments: ["hello"], environment:[:], currentDirectoryURL: getabscwd(), executableFinder: ctx.executableFinder)
            echo.output = .pipeChannel()
            echo.enableReadableOutputDataCapturing()
            ctx.executor.execute(tasks: [echo])
            let out = echo.readOutputData
            XCTAssertNotNil(out)
            let outString = String(data: out ?? Data(), encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines)
            XCTAssertEqual(outString, "hello")
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
            task = try Task(commandName: "cat", arguments: ["-u", fileUrl.path], currentDirectoryURL: getabscwd(), executableFinder: ctx.executableFinder)
        } catch {
            XCTFail(error.localizedDescription)
            return
        }
        task.output = TaskIOChannel.pipeChannel()
        var outputData = Data()
        task.output.readabilityHandler = { handle in
            handle.withAvailableData { newData in
                outputData += newData
            }
        }
        
        ctx.executor.execute(tasks: [task]) // sync
        let outString = String(data: outputData, encoding: .utf8)
        XCTAssertNotNil(outString)
        XCTAssertTrue((outString?.lengthOfBytes(using: .utf8) ?? 0) > 0)
        XCTAssertEqual(fixtureData, outputData)
    }
    func testSimpleChainedTasks() {
        let echo: Task
        let wc: Task
        do {
            echo = try Task(commandName: "echo", arguments: ["hello"], environment:[:], currentDirectoryURL: getabscwd(), executableFinder: ctx.executableFinder)
            wc = try Task(commandName: "wc", arguments: ["-l"], environment:[:], currentDirectoryURL: getabscwd(), executableFinder: ctx.executableFinder)
        } catch {
            XCTFail(error.localizedDescription)
            return
        }
        let echoOut = TaskIOChannel.pipeChannel()
        echo.output = echoOut
        wc.input = echoOut
        let wcOut = TaskIOChannel.pipeChannel()
        wc.output = wcOut
        var outputData = Data()
        wcOut.readabilityHandler = { handle in
            handle.withAvailableData { newData in
                outputData += newData
            }
        }
        
        
        ctx.executor.execute(tasks: [echo, wc]) // sync
        let outString = String(data: outputData, encoding: .utf8)
        XCTAssertNotNil(outString)
        XCTAssertTrue((outString?.lengthOfBytes(using: .utf8) ?? 0) > 0)
    }
}
