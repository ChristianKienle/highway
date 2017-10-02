import HighwayCore
import FSKit

public final class Bootstraper {
    // MARK: - Init
    public init(homeBundleDirectory: AbsoluteUrl, context: Context) {
        self.homeBundleDirectory = homeBundleDirectory
        self.context = context
    }
    
    // MARK: - Properties
    public let homeBundleDirectory: AbsoluteUrl
    public let context: Context
    
    // MARK: - Command
    public func start() throws -> HomeBundle {
        let provider = HomeBundleCreator(homeDirectory: homeBundleDirectory, configuration: .standard, context: context)
        return try provider.requestHomeBundle()
    }
}
