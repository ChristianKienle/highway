import Foundation

/// Options for xcodebuild's build & test actions:
public struct TestOptions {
    // MARK: - Init
    public init() {}
    
    // MARK: - Properties
    public var scheme: String? // -scheme
    public var project: String? // -project [sub-type: path]
    public var destination: Destination? // -destination
}
