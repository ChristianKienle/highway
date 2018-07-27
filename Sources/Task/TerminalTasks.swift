//
//  Commands.swift
//
//  Created by Stijn on 29/05/2018.
//

import Foundation
import os
import SourceryAutoProtocols

public enum TerminalTask: RawRepresentable, Equatable, AutoCases {
   
    case git(ArgumentExecutableProtocol)
    case cat(ArgumentExecutableProtocol)
    case sourcery(ArgumentExecutableProtocol)
    
    case xcodebuild(ArgumentExecutableProtocol)
    case xcodebuildTests(ArgumentExecutableProtocol)

    // MARK: - Executable
    
    public var executable: ArgumentExecutableProtocol {
        switch self {
        case let .xcodebuild(exec):
            return exec
        case let .git(exec):
            return exec
        case let .sourcery(exec):
            return exec
        case let .cat(exec):
            return exec
        case let .xcodebuildTests(testOptions):
           return testOptions
        }
    }
    
    // MARK: - Equatable
    public static func == (lhs: TerminalTask, rhs: TerminalTask) -> Bool {
        switch (lhs, rhs) {
        case (.xcodebuild, .xcodebuild):
            return true
        case (.git, .git):
            return true
        case (.sourcery, .sourcery ):
            return true
        default:
            return false
        }
    }
    
    // MARK: - RawRepresentable
    
    public typealias RawValue = String
    
    public var rawValue: String {
        switch self {
        case .xcodebuild:
            return "xcodebuild"
        case .sourcery:
            return "sourcery"
        case .cat:
            return "cat"
        case .git:
            return "git"
        case .xcodebuildTests:
            return "xcodebuild"
        }
    }
    
    public init?(rawValue: String) {
        switch rawValue {
        default:
            os_log("not possible %@", type: .error, rawValue)
            return nil
        
        }
    }
}
