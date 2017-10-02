import Foundation

public final class ManagedHighway {
    // MARK: Creating
    convenience init(highway: Highway, dependencies: [Highway] = [], _ noResultHandler: @escaping HighwayHandler) {
        let wrappingHandler: HighwayHandlerProducingResult = {
            try noResultHandler()
            return ()
        }
        self.init(highway: highway, dependencies: dependencies, handler: wrappingHandler)
    }
    
    init(highway: Highway, dependencies: [Highway], handler: @escaping HighwayHandlerProducingResult) {
        self.highway = highway
        self.dependencies = dependencies
        self.handler = handler
    }

    // MARK: Properties
    let handler: HighwayHandlerProducingResult
    let dependencies: [Highway]
    let highway: Highway
    var result: Any?
    
    // MARK: Convenience
    func execute() throws {
        result = try handler()
    }
}
