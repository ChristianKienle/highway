import Foundation
import Task
import ZFile
import Url
import Arguments
import Result
import SourceryAutoProtocols

public protocol XCBuildProtocol: AutoMockable {
    
    /// sourcery:inline:XCBuild.AutoGenerateProtocol
    var system: SystemProtocol { get }
    var fileSystem: FileSystemProtocol { get }

    func archive(using options: ArchiveOptionsProtocol) throws -> ArchiveProtocol
    func export(using options: ExportArchiveOptionsProtocol) throws -> ExportProtocol
    func buildAndTest(using options: TestOptionsProtocol) throws -> TestReport
    /// sourcery:end
}

/// Low-level Wrapper around xcodebuild. This is a starting point for additonal wrappers that do things like auto detection
/// of certain settings/options. However there are some things XCBuild already does which makes it a little bit more than
/// just a wrapper. It offers a nice struct around the export-plist, it interprets the results of executed commands
/// and finds generated files (ipas, ...). xcrun is also used throughout this class.
public final class XCBuild: XCBuildProtocol, AutoGenerateProtocol {
    // MARK: - Properties
    public let system: SystemProtocol
    public let fileSystem: FileSystemProtocol
    
    // MARK: - Init
    public init(system: SystemProtocol, fileSystem: FileSystemProtocol) {
        self.system = system
        self.fileSystem = fileSystem
    }
    
    // MARK: - Archiving
    @discardableResult
    public func archive(using options: ArchiveOptionsProtocol) throws -> ArchiveProtocol {
        try system.execute( try _archiveTask(using: options))
        
        return try Archive(archiveFolder: try Folder(path: options.archivePath), fileSystem: fileSystem)
    }
    
    private func _archiveTask(using options: ArchiveOptionsProtocol) throws -> Task {
        let result = try _xcodebuild()
        result.arguments += options.arguments
        return result
    }
    
    // MARK: Exporting
    @discardableResult
    public func export(using options: ExportArchiveOptionsProtocol) throws -> ExportProtocol {
        let task = try _exportTask(using: options)
        guard try system.execute(task) else {
            throw "Export failed. No archivePath set."
        }
        return try Export(folder: try Folder(path: options.exportPath), fileSystem: fileSystem)
    }
    
    private func _exportTask(using options: ExportArchiveOptionsProtocol) throws -> Task {
        let result = try _xcodebuild()
        result.arguments += options.arguments
        
        return result
    }
    
    // MARK: Testing
    @discardableResult
    public func buildAndTest(using options: TestOptionsProtocol) throws -> TestReport {
        let xcbuild = try _buildTestTask(using: options)
        
        do {
            let xcpretty = try system.task(named: "xcpretty")
            xcbuild.output = .pipe()
            xcbuild.environment["NSUnbufferedIO"] = "YES" // otherwise xcpretty might not get everything
            xcpretty.input = xcbuild.output
            try system.launch(xcbuild, wait: false)
            try system.execute(xcpretty)
        } catch {
            try system.execute(xcbuild)
        }
        
        return TestReport()
    }
    
    private func _buildTestTask(using options: TestOptionsProtocol) throws -> Task {
        let result = try _xcodebuild()
        result.arguments += options.arguments
        return result
    }
    
    // MARK: Helper
    private func _xcodebuild() throws -> Task {
        let result = try system.task(named: "xcrun")
        result.arguments = ["xcodebuild"]
        return result
    }
}

fileprivate struct XCodeBuildOption {
    fileprivate init(name: String, value: String?) {
        self.name = name
        self.value = value
    }
    fileprivate let name: String
    fileprivate var value: String?
}

extension XCodeBuildOption: ArgumentsConvertible {
    func arguments() -> Arguments? {
        guard let value = value else { return nil }
        return Arguments(["-" + name, value])
    }
}

private func _option(_ name: String, value: String?) -> XCodeBuildOption {
    return XCodeBuildOption(name: name, value: value)
}

fileprivate extension ArchiveOptionsProtocol {
    // sourcery:skipProtocol
    var arguments: Arguments {
        var args = Arguments.empty
        args += _option("scheme", value: scheme)
        args += _option("project", value: project)
        args += _option("destination", value: destination.asString)
        args += _option("archivePath", value: archivePath)
        args.append("archive")
        return args
    }
}

fileprivate extension ExportArchiveOptionsProtocol {
    // sourcery:skipProtocol
    var arguments: Arguments {
       
        let exportOptionsPlistPath = "\(exportPath)/generated.plist"
        var args = Arguments("-exportArchive")
        args += _option("exportOptionsPlist", value: exportOptionsPlistPath)
        args += _option("archivePath", value: archivePath.path)
        args += _option("exportPath", value: exportPath)
        
        return args
    }
}

fileprivate extension TestOptionsProtocol {
    
    // sourcery:skipProtocol
    var arguments: Arguments {
        var args = Arguments.empty
        args += _option("scheme", value: scheme)
        args += _option("project", value: project)
        args += _option("destination", value: destination.asString)
        args += _option("resultBundlePath", value: resultBundlePath)
        args += _option("quiet", value: nil)
        args.append(["build", "test"])
        return args
    }
}

