import Foundation
import ZFile
import XCBuild
import Task
import HighwayCore
import Terminal
import Deliver
import POSIX
import Git

open class Highway<T: HighwayType>: _Highway<T> {
    public let fileSystem: FileSystemProtocol = FileSystem()
    public let context = Context.local()
    public let cwd = abscwd()
    public let system = LocalSystem.local()
    public let ui: UIProtocol = Terminal.shared
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
