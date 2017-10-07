import Foundation

/// Options for xcodebuild's archive action:
public struct ArchiveOptions {
    // MARK: - Init
    public init() {}
    
    // MARK: - Properties
    public var scheme: String? // -scheme
    public var project: String? // -project [sub-type: path]
    public var destination: Destination? // -destination
    
    // Option: -archivePath
    // Type: path
    // Notes: Directory at archivePath must not exist already.
    public var archivePath: String?
}
