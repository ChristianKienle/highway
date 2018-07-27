import Foundation
import HighwayCore

enum AppHighway: String, HighwayTypeProtocol {
    case initialize
    case help
    case generate
    case bootstrap
    case clean
    case version
    case self_update
    
    var name: String {
        if self == .initialize { return "init" }
        if self == .version { return "--version" }
        return rawValue
    }
    
    var usage: String {
        switch self {
        case .initialize: return "Initializes a new highway project"
        case .help: return "Displays available commands and options"
        case .generate: return "Generates an Xcode project"
        case .bootstrap: return "Bootstraps the highway home directory"
        case .clean: return "Delete build artifacts of your highway project"
        case .self_update: return "Updates highway & the supporting frameworks"
        case .version: return "Print version information and exit"
        }
    }
}

