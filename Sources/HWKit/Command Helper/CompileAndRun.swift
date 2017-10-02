import HighwayCore
import Terminal
import FSKit

public final class CompileAndRun {
    // MARK: - Init
    public init(bundle: HighwayBundle, compiler: SwiftBuildSystem) {
        self.bundle = bundle
        self.compiler = compiler
    }

    // MARK: - Properties
    public let compiler: SwiftBuildSystem
    public let bundle: HighwayBundle
    public var bundleConfiguration: HighwayBundle.Configuration { return bundle.configuration }

    // MARK: - Command
    public func compileAndRun(arguments: [String]) throws {
        let artifact = try compiler.compile(bundle: bundle)
        let executableURL = AbsoluteUrl(path: bundleConfiguration.targetName, relativeTo: artifact.binUrl)
        let p = Task(executableURL: executableURL, arguments: arguments, currentDirectoryURL: getabscwd())
        Terminal.shared.log("Launching: \(p.description)")
        let context = Context.local()
        context.executor.execute(task: p)
        let success = p.state.successfullyFinished
        guard success else {
            throw "Failed to execute \(executableURL.path)"
        }
    }
}

