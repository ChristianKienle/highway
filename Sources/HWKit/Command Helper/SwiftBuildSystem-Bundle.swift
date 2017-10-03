import HighwayCore

public extension SwiftBuildSystem {
    public typealias BundleCompiler = (plan: SwiftBuildSystem.ExecutionPlan, bundle: HighwayBundle)

    func bundleCompiler(`for` bundle: HighwayBundle) throws -> BundleCompiler {
        let options = SwiftOptions(subject: .auto, projectDirectory: bundle.url, configuration: .debug, verbose: true, buildPath: bundle.buildDirectory, additionalArguments: [])
        let plan = try executionPlan(with: options)
        return BundleCompiler(plan: plan, bundle: bundle)
    }
    
    public func compile(bundle: HighwayBundle) throws -> Artifact {
        let compiler = try bundleCompiler(for: bundle)
        return try execute(plan: compiler.plan)
    }
} 
