import Foundation
import HighwayCore

enum AppHighway: String, Highway {
    case initialize
    case initialize_swift
    case help
    case generate
    case bootstrap
    case clean
    case version
    case self_update
    var highwayName: String {
        if self == .initialize_swift { return "init_swift" }
        if self == .initialize { return "init" }
        if self == .version { return "--version" }
        return rawValue
    }
    var usage: String {
        switch self {
        case .initialize: return "Initialize a new Highway project"
        case .initialize_swift: return "Initialize a new Highway project that builds a Swift project."
        case .help: return "Display available commands and options"
        case .generate: return "Generates an Xcode project"
        case .bootstrap: return "Bootstraps the Highway home directory"
        case .clean: return "Delete build artifacts of your Highway project"
        case .self_update: return "Updates Highway & the supporting frameworks"
        case .version: return "Shows the version of Highway"
        }
    }
}
