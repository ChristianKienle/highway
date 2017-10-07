import Foundation

class OrderedDictionary<Key, Value> where Key : Hashable {
    // MARK: - Properties
    private var keys = [Key]()
    private(set) var values = [Value]()
    
    // MARK: - Appending Keys and Values
    func append(_ value: Value, forKey key: Key) { // FIXME: Replace
        keys.append(key)
        values.append(value)
    }
    
    // MARK: - Removing Pairs
    func removeValue(forKey key: Key) {
        guard let index = keys.index(of: key) else { return }
        
        keys.remove(at: index)
        values.remove(at: index)
    }
    
    // MARK: - Getting Values
    func value(forKey key: Key) -> Value? {
        guard let index = keys.index(of: key) else { return nil }
        return values[index]
    }
    
    subscript(key: Key) -> Value? {
        get {
            return value(forKey: key)
        }
    }
    
    // Adds defaultValue to the dictionary if it does not contain the key.
    subscript(key: Key, default defaultValue: @autoclosure () -> Value) -> Value {
        get {
            if let value = self[key] {
                return value
            }
            let fallbackValue = defaultValue()
            append(fallbackValue, forKey: key)
            return fallbackValue
        }
    }
}
