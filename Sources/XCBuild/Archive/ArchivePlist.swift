//
//  PlistProtocol.swift
//  XCBuild
//
//  Created by Stijn on 26/07/2018.
//

import Foundation
import SourceryAutoProtocols

public protocol ArchivePlistProtocol: AutoMockable {
    
    // sourcery:inline:Plist.AutoGenerateProtocol
    // sourcery:end
    
}

public struct ArchivePlist: ArchivePlistProtocol, Decodable, AutoGenerateProtocol {
    let applicationProperties: String
    let applicationPath: String
    
    enum CodingKeys: String, CodingKey {
        case applicationProperties = "ApplicationProperties"
        case applicationPath = "ApplicationPath"
    }
    
}
