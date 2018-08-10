//
//  ExcecutableProtocol.swift
//  🤖
//
//  Created by Stijn on 20/07/2018.
//

import Foundation
import SourceryAutoProtocols
import Arguments
import ZFile

public protocol ExecutableProtocol: AutoMockable {
    
    func executableFile() throws -> FileProtocol
    
}

public protocol ArgumentExecutableProtocol: ExecutableProtocol {
    
    func arguments() throws -> Arguments

}
