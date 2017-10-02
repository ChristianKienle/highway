import Foundation
import HighwayCore

enum PrivateHighway: String, Highway {
    case bootstrapAndUpdate
    
    var usage: String {
        return "Bootstraps and updates the home bundle."
    }
}
