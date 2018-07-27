import Foundation
import SourceryAutoProtocols
import ZFile

public protocol TestOptionsProtocol: AutoMockable {
    
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
    
    public init(scheme: String, project: String, destination: Destination, resultBundlePath: String, fileSystem: FileSystem = FileSystem()) throws {
        
        guard fileSystem.itemKind(at: resultBundlePath) == nil else {
            throw "🛣🔥 \(#line) \(#function) resultBundlePath should not exist at given path \(resultBundlePath)."
        }
        
        self.scheme = scheme
        self.project = project
        self.destination = destination
        self.resultBundlePath = resultBundlePath
    }
    
}
