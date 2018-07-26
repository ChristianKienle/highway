//
//  BuildResult.swift
//  highway
//
//  Created by Stijn on 26/07/2018.
//

import Foundation
import SourceryAutoProtocols
import ZFile
import HighwayCore

public protocol BuildResultProtocol: AutoMockable {
    
    /// sourcery:inline:BuildResult.AutoGenerateProtocol
    var executableUrl: FileProtocol { get }
    var artifact: SwiftBuildSystem.Artifact { get }
    /// sourcery:end
}

public struct BuildResult: AutoGenerateProtocol {
    // MARK: - Init
    public init(executableUrl: FileProtocol, artifact: SwiftBuildSystem.Artifact) {
        self.executableUrl = executableUrl
        self.artifact = artifact
    }
    // MARK: - Properties
    public let executableUrl: FileProtocol
    public let artifact: SwiftBuildSystem.Artifact
}
