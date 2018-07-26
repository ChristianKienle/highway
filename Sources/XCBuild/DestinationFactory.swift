//
//  DestinationFactory.swift
//  XCBuild
//
//  Created by Stijn on 26/07/2018.
//

import Foundation

import Foundation
import os
import SourceryAutoProtocols

public protocol DestinationFactoryProtocol: AutoMockable {
    
    /// sourcery:inline:DestinationFactory.AutoGenerateProtocol

    func macOS(architecture: Destination.Architecture)-> Destination
    func device(_ device: Destination.Device, name: String?, isGeneric: Bool, id: String?)-> Destination
    func simulator(_ simulator: Destination.Simulator, name: String, os: Destination.OS, id: String?)-> Destination
    
    /// sourcery:end
    
}

public struct DestinationFactory: AutoGenerateProtocol {
    
    public func macOS(architecture: Destination.Architecture) -> Destination {
        return Destination(
            [
                "platform" : Destination.PlatformType.macOS.rawValue,
                "arch" : architecture.rawValue
            ]
        )
    }
    
    public func device(_ device: Destination.Device, name: String?, isGeneric: Bool = true, id: String?) -> Destination {
        var properties = [String: String]()
        properties["\(isGeneric ? "generic/" : "")platform"] = device.name
        if let name = name {
            properties["name"] = name
        }
        if let id = id {
            properties["id"] = id
        }
        return Destination(properties)
    }
    
    public func simulator(_ simulator: Destination.Simulator, name: String, os: Destination.OS, id: String?) -> Destination {
        var properties = [String: String]()
        
        properties["platform"] = simulator.name
        properties["OS"] = os.name
        properties["name"] = name
        if let id = id {
            properties["id"] = id
        }
        return Destination(properties)
    }
    
    // MARK: - Error
    
    enum Error: Swift.Error, Equatable, RawRepresentable, CustomDebugStringConvertible {
        
        typealias RawValue = String
        
        var rawValue: String {
            switch self {
            case .message(_):
                return "message"
            }
        }
        
        init?(rawValue: String) {
            switch rawValue {
            case "message":
                self = .message("general")
            default:
                return nil
            }
        }
        
        var debugDescription: String {
            
            switch self {
            case let .message(message):
                return """
                
                \(DestinationFactory.Error.self) encountered an error:
                \(message)
                
                """
            }
            
        }
        
        case message(String)
        
    }
}
