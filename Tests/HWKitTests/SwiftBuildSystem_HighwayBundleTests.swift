import XCTest
@testable import HWKit
import HighwayCore
import TestKit
import ZFile
import Url

final class SwiftBuildSystem_HighwayBundleTests: XCTestCase {
    
    func testSuccess() {
        let fs = InMemoryFileSystem()
        let config = HighwayBundle.Configuration.standard
        let bundleUrl = Absolute.root.appending(config.directoryName)
        XCTAssertNoThrow(try fs.createDirectory(at: bundleUrl))
        let binDir = Absolute("/bin")
        let swiftUrl = Absolute("/bin/xcrun")
        XCTAssertNoThrow(try fs.createDirectory(at: binDir))
        XCTAssertNoThrow(try fs.writeData(Data(), to: swiftUrl))
        let bundle: HighwayBundle
        do {
            bundle = try HighwayBundle(url: bundleUrl, fileSystem: fs, configuration: config)
        }
        catch {
            XCTFail(error.localizedDescription)
            return
        }
        
        let finder = ExecutableProviderMock()
        finder[binDir] = ["xcrun"]
            
        let executor = ExecutorMock { _ in
            return;
        }
        let context = Context(executableProvider: finder, executor: executor, fileSystem: fs)
        let buildSystem = SwiftBuildSystem(context: context)
        
        guard let compiler = try? buildSystem.bundleCompiler(for: bundle) else {
            XCTFail()
            return
        }
        let buildTask = compiler.plan.buildTask

        XCTAssertEqual(buildTask.executableUrl, swiftUrl)
        XCTAssertEqual(buildTask.arguments, ["swift", "build", "--configuration", "debug", "--build-path", bundle.buildDirectory.path, "-v"])
        
        let binPathTask = compiler.plan.showBinPathTask
        XCTAssertEqual(binPathTask.executableUrl, swiftUrl)
        XCTAssertEqual(binPathTask.arguments, ["swift", "build", "--configuration", "debug", "--build-path", bundle.buildDirectory.path, "--show-bin-path"])

    }
}

