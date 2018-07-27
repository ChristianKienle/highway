//
//  DecoderMock.swift
//  XCBuild
//
//  Created by Stijn on 27/07/2018.
//

import Foundation
import SourceryAutoProtocols


// MARK: - DecoderMockMock

public class DecoderMock<_Key>: Decoder where _Key: CodingKey {
    
    public init() {}
    
    public var codingPath: [CodingKey] = []
    public var userInfo: [CodingUserInfoKey : Any] = [:]
    
    //MARK: - container<Key>
    
    public  var containerKeyedByThrowableError: Error?
    public var containerKeyedByCallsCount = 0
    public var containerKeyedByCalled: Bool {
        return containerKeyedByCallsCount > 0
    }
    public var containerKeyedByReceivedType: _Key.Type?
    public var containerKeyedByReturnValue: KeyedDecodingContainer<_Key>?
    public var containerKeyedByClosure: ((_Key.Type) throws -> KeyedDecodingContainer<_Key>)? = nil
    
    public func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key : CodingKey {
        return try _container(keyedBy: type)
    }
    
    private func _container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> {
        
        guard let _type = type as? _Key.Type else {
            throw SourceryMockError.implementErrorCaseFor("type conversion failed")
        }
        
        if let error = containerKeyedByThrowableError {
            throw error
        }
        
        
        containerKeyedByCallsCount += 1
        containerKeyedByReceivedType = _type
        
        
        guard let closureReturn = containerKeyedByClosure else {
            guard let returnValue = containerKeyedByReturnValue else {
                let message = """
                🧙‍♂️ 🔥asked to return a value for name parameters:
                    containerKeyedBy
                    but this case(s) is(are) not implemented in
                    DecoderMock for method containerKeyedByClosure.
                """
                let error = SourceryMockError.implementErrorCaseFor(message)
                throw error
            }
            return returnValue as! KeyedDecodingContainer<Key>
        }
        
        return try closureReturn(_type) as! KeyedDecodingContainer<Key>
    }
    
    //MARK: - unkeyedContainer
    
    public  var unkeyedContainerThrowableError: Error?
    public var unkeyedContainerCallsCount = 0
    public var unkeyedContainerCalled: Bool {
        return unkeyedContainerCallsCount > 0
    }
    public var unkeyedContainerReturnValue: UnkeyedDecodingContainer?
    public var unkeyedContainerClosure: (() throws -> UnkeyedDecodingContainer)? = nil
    
    public func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        
        if let error = unkeyedContainerThrowableError {
            throw error
        }
        
        
        unkeyedContainerCallsCount += 1
        
        
        guard let closureReturn = unkeyedContainerClosure else {
            guard let returnValue = unkeyedContainerReturnValue else {
                let message = """
                🧙‍♂️ 🔥asked to return a value for name parameters:
                    unkeyedContainer
                    but this case(s) is(are) not implemented in
                    DecoderMock for method unkeyedContainerClosure.
                """
                let error = SourceryMockError.implementErrorCaseFor(message)
                throw error
            }
            return returnValue
        }
        
        return try closureReturn()
    }
    
    //MARK: - singleValueContainer
    
    public  var singleValueContainerThrowableError: Error?
    public var singleValueContainerCallsCount = 0
    public var singleValueContainerCalled: Bool {
        return singleValueContainerCallsCount > 0
    }
    public var singleValueContainerReturnValue: SingleValueDecodingContainer?
    public var singleValueContainerClosure: (() throws -> SingleValueDecodingContainer)? = nil
    
    public func singleValueContainer() throws -> SingleValueDecodingContainer {
        
        if let error = singleValueContainerThrowableError {
            throw error
        }
        
        
        singleValueContainerCallsCount += 1
        
        
        guard let closureReturn = singleValueContainerClosure else {
            guard let returnValue = singleValueContainerReturnValue else {
                let message = """
                🧙‍♂️ 🔥asked to return a value for name parameters:
                    singleValueContainer
                    but this case(s) is(are) not implemented in
                    DecoderMock for method singleValueContainerClosure.
                """
                let error = SourceryMockError.implementErrorCaseFor(message)
                throw error
            }
            return returnValue
        }
        
        return try closureReturn()
    }
    
}
// Just used to generate the mock once and than manualy altered
//
//public protocol DecoderMock: Decoder, AutoMockable {
//
//    /// The path of coding keys taken to get to this point in decoding.
//    var codingPath: [CodingKey] { get }
//
//    /// Any contextual information set by the user for decoding.
//    var userInfo: [CodingUserInfoKey : Any] { get }
//
//    /// Returns the data stored in this decoder as represented in a container
//    /// keyed by the given key type.
//    ///
//    /// - parameter type: The key type to use for the container.
//    /// - returns: A keyed decoding container view into this decoder.
//    /// - throws: `DecodingError.typeMismatch` if the encountered stored value is
//    ///   not a keyed container.
//    func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key : CodingKey
//
//    /// Returns the data stored in this decoder as represented in a container
//    /// appropriate for holding values with no keys.
//    ///
//    /// - returns: An unkeyed container view into this decoder.
//    /// - throws: `DecodingError.typeMismatch` if the encountered stored value is
//    ///   not an unkeyed container.
//    func unkeyedContainer() throws -> UnkeyedDecodingContainer
//
//    /// Returns the data stored in this decoder as represented in a container
//    /// appropriate for holding a single primitive value.
//    ///
//    /// - returns: A single value container view into this decoder.
//    /// - throws: `DecodingError.typeMismatch` if the encountered stored value is
//    ///   not a single value container.
//    func singleValueContainer() throws -> SingleValueDecodingContainer
//}
