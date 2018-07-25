import Foundation

/// Options for xcodebuild's build & test actions:
public struct TestOptions: AutoGenerateProtocol {
    public let scheme: String // -scheme
    public let project: String // -project [sub-type: path]
    public let destination: Destination // -destination
    
    public init(scheme: String, project: String, destination: Destination) {
        self.scheme = scheme
        self.project = project
        self.destination = destination
    }
    
}
