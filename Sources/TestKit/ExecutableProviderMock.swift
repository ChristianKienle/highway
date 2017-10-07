import Foundation
import Url
import Task

public class ExecutableProviderMock: ExecutableProvider {
    public init() {
        
    }
    private var _mapping = [Absolute : [String]]()
    public subscript(directory: Absolute) -> [String]? {
        get { return _mapping[directory] }
        set {
            if let newValue = newValue {
                _mapping[directory] = newValue
            } else {
                _mapping.removeValue(forKey: directory)
            }
        }
    }
    public func urlForExecuable(_ executableName: String) -> Absolute? {
        return _mapping.first { (key, value) -> Bool in
            return value.contains(executableName)
            }?.key.appending(executableName)
    }
}
