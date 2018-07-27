//
//  PlistProtocol.swift
//  XCBuild
//
//  Created by Stijn on 26/07/2018.
//

import Foundation
import SourceryAutoProtocols

public protocol ArchivePlistProtocol: Codable, AutoMockable {
    
    /// sourcery:inline:ArchivePlist.AutoGenerateProtocol
    var applicationProperties: String { get }
    var applicationPath: String { get }
    /// sourcery:end
    
}

public struct ArchivePlist: ArchivePlistProtocol, Codable, AutoGenerateProtocol {
    public let applicationProperties: String
    public let applicationPath: String
    
    enum CodingKeys: String, CodingKey {
        case applicationProperties = "ApplicationProperties"
        case applicationPath = "ApplicationPath"
    }
    
}
