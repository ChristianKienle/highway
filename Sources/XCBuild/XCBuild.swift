import Foundation
import Task
import FileSystem
import Url
import Arguments
import Result

/// Low-level Wrapper around xcodebuild. This is a starting point for additonal wrappers that do things like auto detection
/// of certain settings/options. However there are some things XCBuild already does which makes it a little bit more than
/// just a wrapper. It offers a nice struct around the export-plist, it interprets the results of executed commands
/// and finds generated files (ipas, ...). xcrun is also used throughout this class.
public final class XCBuild {
    // MARK: - Properties
    public let system: System
    public let fileSystem: FileSystem
    
    // MARK: - Init
    public init(system: System, fileSystem: FileSystem) {
        self.system = system
        self.fileSystem = fileSystem
    }
    
    // MARK: - Archiving
    @discardableResult
    public func archive(using options: ArchiveOptions) throws -> Archive {
        let task = try _archiveTask(using: options).dematerialize()
        try system.execute(task).assertSuccess()
        guard let archivePath = options.archivePath else {
            throw "Archive failed. No archivePath set."
        }
        let archiveUrl = Absolute(archivePath)
        
        return try Archive(url: archiveUrl, fileSystem: fileSystem)
    }
    
    private func _archiveTask(using options: ArchiveOptions) throws -> Result<Task, TaskCreationError> {
        let result = _xcodebuild()
        result.value?.arguments += options.arguments
        return result
    }
    
    // MARK: Exporting
    @discardableResult
    public func export(using options: ExportArchiveOptions) throws -> Export {
        let task = try _exportTask(using: options).dematerialize()
        try system.execute(task).assertSuccess()
        guard let exportPath = options.exportPath else {
            throw "Export failed. No archivePath set."
        }
        return try Export(url: Absolute(exportPath), fileSystem: fileSystem)
    }
    
    private func _exportTask(using options: ExportArchiveOptions) -> Result<Task, TaskCreationError> {
        let result = _xcodebuild()
        result.value?.arguments += options.arguments
        return result
    }
    
    // MARK: Testing
    @discardableResult
    public func buildAndTest(using options: TestOptionsProtocol) throws -> TestReport {
        let xcbuild = try _buildTestTask(using: options).dematerialize()
        
        if let xcpretty = system.task(named: "xcpretty").value {
            xcbuild.output = .pipe()
            xcbuild.environment["NSUnbufferedIO"] = "YES" // otherwise xcpretty might not get everything
            xcpretty.input = xcbuild.output
            try system.launch(xcbuild, wait: false).assertSuccess()
            try system.execute(xcpretty).assertSuccess()
        } else {
            try system.execute(xcbuild).assertSuccess()
        }
        return TestReport()
    }
    
    private func _buildTestTask(using options: TestOptionsProtocol) -> Result<Task, TaskCreationError> {
        let result = _xcodebuild()
        result.value?.arguments += options.arguments
        return result
    }
    
    // MARK: Helper
    private func _xcodebuild() -> Result<Task, TaskCreationError> {
        let result = system.task(named: "xcrun")
        result.value?.arguments = ["xcodebuild"]
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

fileprivate extension ArchiveOptions {
    var arguments: Arguments {
        var args = Arguments.empty
        args += _option("scheme", value: scheme)
        args += _option("project", value: project)
        args += _option("destination", value: destination.map { "\($0.asString)" })
        args += _option("archivePath", value: archivePath)
        args.append("archive")
        return args
    }
}

fileprivate extension ExportArchiveOptions {
    var arguments: Arguments {
        var args = Arguments("-exportArchive")
        args += _option("exportOptionsPlist", value: exportOptionsPlist?.url.path)
        args += _option("archivePath", value: archivePath)
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
        args.append(["build", "test"])
        return args
    }
}

