public enum Color: String {
    case none = ""
    case red = "31m"
    case green = "32m"
    case yellow = "33m"
    case cyan = "36m"
    case white = "37m"
    case black = "30m"
    case grey = "30;1m"
    
    // MARK: - Properties
    var terminalString: String {
        if case .none = self {
            return ""
        }
        return String.Ansi.CSI + rawValue
    }
}
