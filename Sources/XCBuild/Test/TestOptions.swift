import Foundation
import SourceryAutoProtocols


public protocol TestOptionsProtocol: AutoMockable {
    
    /// sourcery:inline:TestOptions.AutoGenerateProtocol
    var scheme: String { get }
    var project: String { get }
    var destination: DestinationProtocol { get }
   
    /// sourcery:end
}

/// Options for xcodebuild's build & test actions:
public struct TestOptions: TestOptionsProtocol, AutoGenerateProtocol {
    public let scheme: String // -scheme
    public let project: String // -project [sub-type: path]
    public let destination: DestinationProtocol // -destination
    
    public init(scheme: String, project: String, destination: Destination) {
        self.scheme = scheme
        self.project = project
        self.destination = destination
    }
    
}
