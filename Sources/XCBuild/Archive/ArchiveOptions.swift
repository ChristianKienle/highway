import Foundation
import SourceryAutoProtocols

public protocol ArchiveOptionsProtocol: AutoMockable {
    
    /// sourcery:inline:ArchiveOptions.AutoGenerateProtocol
    var scheme: String { get }
    var project: String { get }
    var destination: DestinationProtocol { get }
    var archivePath: String { get }
    /// sourcery:end
}

/// Options for xcodebuild's archive action:
public struct ArchiveOptions: ArchiveOptionsProtocol, AutoGenerateProtocol {
    
    // MARK: - Properties
    public let scheme: String // -scheme
    public let project: String // -project [sub-type: path]
    public let destination: DestinationProtocol // -destination
    
    // Option: -archivePath
    // Type: path
    // Notes: Directory at archivePath must not exist already.
    public let archivePath: String
    
    // MARK: - Init
    public init(scheme: String, project: String, destination: DestinationProtocol, archivePath: String) {
        self.scheme = scheme
        self.project = project
        self.destination = destination
        self.archivePath = archivePath
    }
    
  
}
