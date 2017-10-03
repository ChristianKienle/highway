import Foundation
import Terminal

public typealias HighwayHandlerProducingResult = () throws -> (Any)
public typealias HighwayHandler = () throws -> ()
public typealias UnrecognizedCommandHandler = (_ arguments: [String]) throws -> ()
public typealias HighwaysResultProducingInvocationHandler = (_ invocation: Invocation) throws -> (Any)

public final class Invocation {
    // MARK: - Convenience
    public static let empty = Invocation(highwayName: "")
    
    // MARK: - Init
    public init(highwayName: String, arguments: Arguments = .empty) {
        self.highwayName = highwayName
        self.arguments = arguments
    }
    
    // MARK: - Properties
    public let highwayName: String
    public let arguments: Arguments
}

extension Invocation: Equatable {
    public static func ==(l: Invocation, r: Invocation) -> Bool {
      return l.highwayName == r.highwayName && l.arguments == r.arguments
    }
}

public class Highways<T: Highway> {
    // MARK: - Types
    public typealias ErrorHandler = (Error) -> ()
    public typealias EmptyHandler = () throws -> ()

    // MARK: - Init
    public init(_ highwayType: T.Type) {
        addPrivateHighway(PrivateHighway.listPublicHighwaysAsJSON, _listPublicHighwaysAsJSON)
    }
    
    // MARK: - Properties
    public private(set) var highways: [ManagedHighway] = []
    private var _privateHighways: [ManagedHighway] = []
    private var errorHandler: ErrorHandler?
    private var emptyHandler: EmptyHandler?
    private var unrecognizedCommandHandler: UnrecognizedCommandHandler?
    
    // MARK: - Adding Highways
    public func highway(_ highway: T, dependsOn dependencies: [T] = [], _ handler: @escaping FireAndForgetHighway.Handler) -> Highways<T> {
        let _highway = FireAndForgetHighway(highway: highway, dependencies: dependencies, handler: handler)
        highways.append(_highway)
        return self
    }
    
    public func highway(_ highway: T, dependsOn dependencies: [T] = [], _ handler: @escaping ComplexHighway.Handler) -> Highways<T> {
        let _highway = ComplexHighway(highway: highway, dependencies: dependencies, handler: handler)
        highways.append(_highway)
        return self
    }
    
    public func highwayWithResult(_ highway: T, dependsOn dependencies: [T] = [], _ handler: @escaping ResultProducingHighway.Handler) -> Highways<T> {
        let _highway = ResultProducingHighway(highway: highway, dependencies: dependencies, handler: handler)
        highways.append(_highway)
        return self
    }
    
    public func highwayWithResult(_ highway: T, dependsOn dependencies: [T] = [], _ handler: @escaping ResultProducingComplexHighway.Handler) -> Highways<T> {
        let _highway = ResultProducingComplexHighway(highway: highway, dependencies: dependencies, handler: handler)
        highways.append(_highway)
        return self
    }

    public func addPrivateHighway(_ highway: Highway, _ handler: @escaping FireAndForgetHighway.Handler) {
        let _highway = FireAndForgetHighway(highway: highway, dependencies: [], handler: handler)
        _privateHighways.append(_highway)
    }

    // MARK: Adding special Highways
    public func onUnrecognizedCommand(_ handler: @escaping UnrecognizedCommandHandler) -> Highways<T> {
        unrecognizedCommandHandler = handler
        return self
    }
    
    public func onEmptyCommand(_ handler: @escaping EmptyHandler) -> Highways<T> {
        emptyHandler = handler
        return self
    }
    
    public func onError(_ handler: @escaping ErrorHandler) -> Highways<T> {
        errorHandler = handler
        return self
    }
    
    // MARK: Getting Results
    public func result<ObjectType>(for highway: T) throws -> ObjectType {
        guard let managedHighway = highways.managedHighway(representing: highway) else {
            throw "Tried to access result for unknown highway: \(highway.highwayName)."
        }
        guard let result = managedHighway.result as? ObjectType else {
            throw "No result or type mismatch for \(ObjectType.self)"
        }
        return result
    }
    
    // MARK: Convenience
    public func done() {}
    
    // MARK: Executing
    private func _handle(highway: ManagedHighway, with arguments: Arguments) throws {
        let dependencies: [ManagedHighway] = try highway.dependencies.map {
            guard let result = self.highways.managedHighway(representing: $0) else {
                throw "\(highway.highway.highwayName) depends on \($0.highwayName) but no such highway is registered."
            }
            return result
        }
        try dependencies.forEach {
            try self._handle(highway: $0, with: arguments)
        }
        
        do {
            let name = highway.highway.highwayName
            let invocation = Invocation(highwayName: name, arguments: arguments)
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
        guard let errorHandler = errorHandler else {
            Terminal.shared.log("ERROR: \(error.localizedDescription)")
            return
        }
        errorHandler(error)
    }
    
    private func _handleEmptyCommandOrReportError() {
        guard let emptyHandler = emptyHandler else {
            _reportError("No empty handler set.")
            return
        }
        do {
            try emptyHandler()
        } catch {
            _reportError(error)
        }
    }
    private func _handleUnrecognizedCommandOrReportError(arguments: [String]) {
        guard let unrecognizedHandler = unrecognizedCommandHandler else {
            _reportError("Unrecognized command detected. No highway matching \(arguments.description) found and no unrecognized command handler set.")
            return
        }
        do {
            try unrecognizedHandler(arguments)
        } catch {
            _reportError(error)
        }
    }
    
    public func go(_ invocationProvider: HighwayInvocationProvider = CommandLineInvocationProvider()) {
        let invocation = invocationProvider.highwayInvocation()
        
        // Empty?
        if invocation == .empty {
            _handleEmptyCommandOrReportError()
            return
        }
       
        // Normal logic
        // Handle private highway
        let highwayName = invocation.highwayName
        if let privateHighway = _privateHighways.managedHighway(named: highwayName) {
            do {
                try _handle(highway: privateHighway, with: invocation.arguments)
            } catch {
                errorHandler?(error)
                return
            }
            return
        }
        
        // Handle normal highway
        guard let highway = highways.managedHighway(named: highwayName) else {
            _handleUnrecognizedCommandOrReportError(arguments: invocation.arguments.all)
            return
        }
        
        do {
            try _handle(highway: highway, with: invocation.arguments)
        } catch {
            // Do not rethrow or report the error because _handle did that already
        }
    }
    
    private func _listPublicHighwaysAsJSON() throws {
        let rawHighways = highways.map { RawHighway(name: $0.highway.highwayName, usage: $0.highway.usage) }
        let text = try rawHighways.jsonString()
        Swift.print(text, separator: "", terminator: "\n")
        fflush(stdout)
    }
}

extension Array where Iterator.Element == ManagedHighway {
    fileprivate func managedHighway(representing representation: Highway) -> ManagedHighway? {
        return first { $0.highway.highwayName == representation.highwayName }
    }
    fileprivate func managedHighway(named name: String) -> ManagedHighway? {
        return first { $0.highway.highwayName == name }
    }
}

extension Array where Iterator.Element == ManagedHighway {
    public var rawHighways: [RawHighway] {
        return map { RawHighway(name: $0.highway.highwayName, usage: $0.highway.usage) }
    }
}

public struct HighwaysList: Printable {
    public init(ownedHighways: [RawHighway], customHighways: [RawHighway]) {
        self.ownedHighways = ownedHighways
        self.customHighways = customHighways
    }
    private let ownedHighways: [RawHighway]
    private let customHighways: [RawHighway]
    public func printableString(with options: Print.Options) -> String {
        let managed = ownedHighways.map { SubText.new(rawHighway: $0) }
        let custom = customHighways.map { SubText.new(rawHighway: $0) }

        var all = managed
        all.append(contentsOf: custom)
        let withNewlines = all
        let result = withNewlines.terminalString
        return result
    }
}

private extension SubText {
    static func new(rawHighway highway: RawHighway) -> Text {
        let executableName = "highway"
        let bullet = "- "
        let line1 = SubText.new(bullet: bullet, usage: highway.usage, indentedBy: 3)
        let line2 = SubText.new(executableName: executableName, command: highway.name, indentedBy: 3 + 2)
        return Text().appending(line1).appending(.newline).appending(line2).appending(.newline).appending(.newline)
    }
    private static func new(executableName _executableName: String, command _command: String, indentedBy width: Int) -> Text {
        var result = Text()

        let executableName = SubText(_executableName, color: .cyan)
        let command = SubText(_command, color: .none, bold: false)

        result.append(.whitespace(width))
        result.append(executableName)
        result.append(.whitespace())
        result.append(command)

        return result
    }
    private static func new(bullet _bullet: String, usage _usage: String, indentedBy width: Int) -> Text {
        var result = Text()
        let indent = SubText(whitespaceWidth: width)
        let bullet = SubText(_bullet, color: .none)
        let usage = SubText(_usage + ":", color: .green)
        
        result.append(indent)
        result.append(bullet)
        result.append(usage)
        
        return result
    }
}
