import Foundation

public func env(_ name: String, defaultValue: String) -> String {
    return ProcessInfo.processInfo.environment[name] ?? defaultValue
}
