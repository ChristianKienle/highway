import Foundation
import Terminal
import Arguments

infix operator ==>

public enum PrivateHighway {
    public static let listPublicHighwaysAsJSON = "listPublicHighwaysAsJSON"
}

public typealias HighwayBody = (Invocation) throws -> Any?

open class _Highway<T: HighwayTypeProtocol> {
    // MARK: - Types
    public typealias ErrorHandler = (Error) -> ()
    public typealias EmptyHandler = () throws -> ()
    public typealias UnrecognizedCommandHandler = (_ arguments: Arguments) throws -> ()

    // MARK: - Init
    public init(_ highwayType: T.Type) throws {
        setupHighways()
    }
    
    // MARK: - Properties
    private var _highways = OrderedDictionary<String, Raw<T>>()
    public var descriptions: [HighwayDescription] {
        return _highways.values.map { $0.description }
    }
    public var onError: ErrorHandler?
    public var onEmptyCommand: EmptyHandler?
    public var onUnrecognizedCommand: UnrecognizedCommandHandler?
    public var verbose = false
    
    // MARK: - Subclasses
    open func setupHighways() {
        
    }
    // MARK: - Adding Highway
    public subscript(type: T) -> Raw<T> {
        return _highways[type.name, default: Raw(type)]
    }
    
    // MARK: Getting Results
    public func result<ObjectType>(for highway: T) throws -> ObjectType {
        guard let value = _highways[highway.name]?.result as? ObjectType else {
            throw "No result or type mismatch for \(ObjectType.self)"
        }
        return value
    }
    
    // MARK: Executing
    private func _handle(highway: Raw<T>, with arguments: Arguments) throws {
        let dependencies: [Raw<T>] = try highway.dependencies.map { dependency in
            guard let result = _highways[dependency] else {
                throw "\(highway.name) depends on \(dependency) but no such highway is registered."
            }
            return result
        }
        try dependencies.forEach {
            try self._handle(highway: $0, with: arguments)
        }
        do {
            let invocation = Invocation(highway: highway.name, arguments: arguments)
            try highway.invoke(with: invocation) // Execute and sets the result
        } catch {
            _reportError(error)
            throw error
        }
    }
    
    /// Calls the error handler with the given error.
    /// If no error handler is set the error is logged.
    ///
    /// - Parameter error: An error to be passed to the error handler
    private func _reportError(_ error: Error) {
        guard let errorHandler = onError else {
            Terminal.shared.log("ERROR: \(error.localizedDescription)")
            return
        }
        errorHandler(error)
    }
    
    private func _handleEmptyCommandOrReportError() {
        guard let emptyHandler = onEmptyCommand else {
            _reportError("No empty handler set.")
            return
        }
        do {
            try emptyHandler()
        } catch {
            _reportError(error)
        }
    }
    private func _handleUnrecognizedCommandOrReportError(arguments: Arguments) {
        guard let unrecognizedHandler = onUnrecognizedCommand else {
            _reportError("Unrecognized command detected. No highway matching \(arguments) found and no unrecognized command handler set.")
            return
        }
        do {
            try unrecognizedHandler(arguments)
        } catch {
            _reportError(error)
        }
    }
    
    public func go(_ invocationProvider: InvocationProvider = CommandLineInvocationProvider()) {
        let invocation = invocationProvider.invocation()
        verbose = invocation.verbose

        // Empty?
        if invocation.representsEmptyInvocation {
            _handleEmptyCommandOrReportError()
            return
        }
        
        // Private
        if invocation.highway == PrivateHighway.listPublicHighwaysAsJSON {
            try? _listPublicHighwaysAsJSON()
            return
        }

        // Remaining highways
        let highwayName = invocation.highway
        guard let highway = _highways[highwayName] else {
            _handleUnrecognizedCommandOrReportError(arguments: invocation.arguments)
            return
        }

        do {
            try _handle(highway: highway, with: invocation.arguments)
        } catch {
            // Do not rethrow or report the error because _handle did that already
        }
    }
    
    private func _listPublicHighwaysAsJSON() throws {
        let text = try descriptions.jsonString()
        Swift.print(text, separator: "", terminator: "\n")
        fflush(stdout)
    }
    
    public class Raw<T: HighwayTypeProtocol> {
        // MARK: - Types
        typealias HighwayBody = (Invocation) throws -> Any?
        
        // MARK: - Properties
        private let type: T
        public var name: String { return type.name }
        public var dependencies = [String]()
        var body: HighwayBody?
        public var result: Any?
        public var description: HighwayDescription {
            var result = HighwayDescription(name: type.name, usage: type.usage)
            result.examples = type.examples
            return result
        }
        
        // MARK: - Init
        init(_ highway: T) {
            self.type = highway
        }
        
        // MARK: - Setting Bodies
        public static func ==> (lhs: Raw, rhs: @escaping () throws -> ()) { lhs.execute(rhs) }
        public static func ==> (lhs: Raw, rhs: @escaping () throws -> (Any)) { lhs.execute(rhs) }
        public static func ==> (lhs: Raw, rhs: @escaping (Invocation) throws -> (Any?)) { lhs.execute(rhs) }
        public static func ==> (lhs: Raw, rhs: @escaping (Invocation) throws -> ()) { lhs.execute(rhs) }

        // MARK: - Cast Bodies
        public func execute(_ newBody: @escaping () throws -> ()) {
            body = { _ in try newBody() }
        }
        
        public func execute(_ newBody: @escaping (_ invocation: Invocation) throws -> ()) {
            body = {
                try newBody($0)
                return ()
            }
        }
        public func execute(_ newBody: @escaping (_ invocation: Invocation) throws -> (Any?)) {
            body = { try newBody($0) }
        }
        
        public func execute(_ newBody: @escaping () throws -> (Any?)) {
            body = { _ in try newBody() }
        }

        // MARK: - Set Dependencies
        public func depends(on highways: T...) -> Raw<T> {
            _setDependencies(highways)
            return self
        }
        
        private func _setDependencies(_ highways: [T]) {
            dependencies = highways.map { $0.name }
        }
        
        // MARK: - Invoke the Highway
        func invoke(with invocation: Invocation) throws {
            result = try body?(invocation)
        }
    }

}
