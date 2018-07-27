import Foundation
import SourceryAutoProtocols
import ZFile
import Arguments
import Task

public protocol TestOptionsProtocol: ArgumentExecutableProtocol {
    
    /// sourcery:inline:TestOptions.AutoGenerateProtocol
    var scheme: String { get }
    var project: String { get }
    var destination: DestinationProtocol { get }
    var resultBundlePath: String { get }
    /// sourcery:end
}

/// Options for xcodebuild's build & test actions:
public struct TestOptions: TestOptionsProtocol, AutoGenerateProtocol {
    
    public let scheme: String // -scheme
    public let project: String // -project [sub-type: path]
    public let destination: DestinationProtocol // -destination
    public let resultBundlePath: String
    
    private let executableProvider: ExecutableProviderProtocol
    
    public init(scheme: String,
                project: String,
                destination: Destination,
                resultBundlePath: String,
                fileSystem: FileSystem = FileSystem(),
                executableProvider: ExecutableProviderProtocol? = nil
        ) throws {
        
        
        guard fileSystem.itemKind(at: resultBundlePath) == nil else {
            throw "🛣🔥 \(#line) \(#function) resultBundlePath should not exist at given path \(resultBundlePath)."
        }
        
        self.scheme = scheme
        self.project = project
        self.destination = destination
        self.resultBundlePath = resultBundlePath
        self.executableProvider = (executableProvider == nil) ? try SystemExecutableProvider() : executableProvider!
    }
    
    public func arguments() throws -> Arguments {
        var args = Arguments.empty
        
        args += _option("scheme", value: scheme)
        args += _option("project", value: project)
        args += _option("destination", value: destination.asString)
        args += _option("resultBundlePath", value: resultBundlePath)
        args += _option("quiet", value: nil)
        args.append(["build", "test"])
       
        return args
        
    }
    
    public func executableFile() throws -> FileProtocol {
        return try self.executableProvider.executable(with: "") // TODO
    }
    
}
