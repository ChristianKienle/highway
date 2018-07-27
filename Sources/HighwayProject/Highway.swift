import Foundation
import ZFile
import XCBuild
import Task
import HighwayCore
import Terminal
import Deliver
import POSIX
import Git

open class Highway<T: HighwayTypeProtocol>: _Highway<T> {
    public let fileSystem: FileSystemProtocol = FileSystem()
    public let context: ContextProtocol
    public let cwd: FolderProtocol
    public let system: SystemProtocol
    public let ui: UIProtocol = Terminal.shared
    
    public override init(_ highwayType: T.Type) throws  {
        context = try Context()
        cwd = FileSystem().currentFolder
        system = try LocalSystem()
        
        try super.init(highwayType)
    }
    
    public lazy var git: GitTool = {
        return GitTool(system: system)
    }()
    
    public lazy var deliver: Deliver.Local = {
        return Deliver.Local(altool: Altool(system: system, fileSystem: fileSystem))
    }()
    public lazy var xcbuild: XCBuild = {
        return XCBuild(system: system, fileSystem: fileSystem)
    }()
    public lazy var swift: SwiftBuildSystem = {
        return SwiftBuildSystem(context: context)
    }()
}
