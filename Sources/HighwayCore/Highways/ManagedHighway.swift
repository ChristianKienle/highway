import Foundation

protocol Invokeable: class {
    func invoke(with invocation: Invocation) throws
}

public class ManagedHighway: Invokeable {
    // MARK: - Init
    init(highway: Highway, dependencies: [Highway]) {
        self.highway = highway
        self.dependencies = dependencies
    }

    // MARK: - Properties
    let dependencies: [Highway]
    let highway: Highway
    var result: Any?
    
    // MARK: - Invokeable
    func invoke(with invocation: Invocation) throws {
    }
}

public class FireAndForgetHighway: ManagedHighway {
    // MARK: - Types
    public typealias Handler = () throws -> ()
    
    // MARK: - Init
    init(highway: Highway, dependencies: [Highway], handler: @escaping Handler) {
        self.handler = handler
        super.init(highway: highway, dependencies: dependencies)
    }
    
    // MARK: - Properties
    private let handler: Handler
    
    // MARK: - ManagedHighway
    override func invoke(with invocation: Invocation) throws {
        try handler()
    }
}


public class ResultProducingHighway: ManagedHighway {
    // MARK: - Types
    public typealias Handler = () throws -> (Any)

    // MARK: - Init
    init(highway: Highway, dependencies: [Highway], handler: @escaping Handler) {
        self.handler = handler
        super.init(highway: highway, dependencies: dependencies)
    }

    // MARK: - Properties
    private let handler: Handler

    // MARK: - ManagedHighway
    override func invoke(with invocation: Invocation) throws {
        result = try handler()
    }
}

public class ResultProducingComplexHighway: ManagedHighway {
    // MARK: - Types
    public typealias Handler = (_ invocation: Invocation) throws -> (Any)
    
    // MARK: - Init
    init(highway: Highway, dependencies: [Highway], handler: @escaping Handler) {
        self.handler = handler
        super.init(highway: highway, dependencies: dependencies)
    }
    
    // MARK: - Properties
    private let handler: Handler
    
    // MARK: - ManagedHighway
    override func invoke(with invocation: Invocation) throws {
        result = try handler(invocation)
    }
}

public class ComplexHighway: ManagedHighway {
    // MARK: - Types
    public typealias Handler = (_ invocation: Invocation) throws -> ()
    
    // MARK: - Init
    init(highway: Highway, dependencies: [Highway], handler: @escaping Handler) {
        self.handler = handler
        super.init(highway: highway, dependencies: dependencies)
    }
    
    // MARK: - Properties
    private let handler: Handler
    
    // MARK: - ManagedHighway
    override func invoke(with invocation: Invocation) throws {
        try handler(invocation)
    }
}

