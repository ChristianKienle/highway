import Foundation
import HighwayCore
import Terminal

struct AppInfo: Printable {
    // MARK: - Init
    init(_ infos:[HighwayDescription]) {
        self.infos = infos
    }
    
    // MARK: - Properties
    private let infos: [HighwayDescription]
    
    // MARK: - Printing
    func printableString(with options: Print.Options) -> String {
        return infos.printableString(with: options)
    }
}

extension _Highway {
    func appInfo(developerProvidedDescriptions: [HighwayDescription]) -> AppInfo {
        let all = descriptions + developerProvidedDescriptions
        return AppInfo(all)
    }
}
