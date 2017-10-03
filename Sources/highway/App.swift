import Foundation
import HighwayCore
import HWKit
import Terminal
import FSKit

final class App {
    // MARK: Properties
    private let fileSystem: FileSystem
    private let bundleConfiguration = HighwayBundle.Configuration.standard
    private let context = Context.local()
    private let highways = Highways(AppHighway.self)
    private lazy var swift_build:SwiftBuildSystem = {
        return SwiftBuildSystem(context: context)
    }()
    private let terminal = Terminal.shared
    
    private func _updateDependenciesIfNeeded() throws {
        let package = SwiftPackageTool(context: self.context)
        let bundle = HighwayBundle.Configuration.standard
        let cwd = context.currentWorkingUrl
        let bundleUrl = cwd.appending(bundle.directoryName)
        guard context.fileSystem.directory(at: bundleUrl).isExistingDirectory else {
            return
        }
        Terminal.shared.log("Updating support frameworks…")
        do {
            try package.package(arguments: ["update"], currentDirectoryUrl: bundleUrl)
            Terminal.shared.log("OK")
        } catch {
            Terminal.shared.log("Update failed. It happens…")
        }
    }
    // MARK: Creating
    init(fileSystem: FileSystem) {
        self.fileSystem = fileSystem
        highways.addPrivateHighway(PrivateHighway.bootstrapAndUpdate, _private_bootstrapAndUpdate)
    }
    
    private func _init() throws {
        try self._updateDependenciesIfNeeded()
        try self.__ensureValidHomeBundle()
        let projectBundle = try HighwayBundle(creatingInParent: getabscwd(), fileSystem: fileSystem, configuration: .standard, homeBundleConfiguration: .standard)
        
        terminal.log("Created at: \(projectBundle.url). Try 'highway generate'.")
    }
    
    // MARK: - Private Highways
    private func _private_bootstrapAndUpdate() throws {
        try _bootstrap()
        let _ = try _update_highway()
    }
    
    // MARK: - Helper
    private func __customHighways() -> [RawHighway] {
        // Try to get the bundle
        // if the are not able to get it just show the help.
        guard let bundle = __currentHighwayBundle() else {
            return []
        }
        return (try? HighwayProjectTool(compiler: swift_build, bundle: bundle, context: context).availableHighways()) ?? []
    }

    @discardableResult
    private func __ensureValidHomeBundle() throws -> HomeBundle {
        let config = HomeBundle.Configuration.standard
        let homeDir = try fileSystem.homeDirectoryUrl()
        let highwayHomeDirectory = homeDir.appending(config.directoryName)
        let git = try GitTool(context: context)
        let bootstrap = Bootstraper(homeDirectory: highwayHomeDirectory, configuration: config, git: git, context: context)
        return try bootstrap.requestHomeBundle()
    }
    
    // MARK: - Helper
    private func __currentHighwayBundle() -> HighwayBundle? {
        let parentUrl = context.currentWorkingUrl
        return try? HighwayBundle(fileSystem: fileSystem,
                                  parentUrl: parentUrl,
                                  configuration: .standard)
    }
    
    // MARK: - Custom Highways
    private func _generate() throws {
        Terminal.shared.log("Creating Xcode project\(String.elli)")
        do {
            let bundle = HighwayBundle.Configuration.standard
            let project = try XCProjectGenerator(context: .local(), bundleConfiguration: bundle).generate()
            let openCommand = project.openProjectCommand(with: bundle)
            Terminal.shared.log("DONE. Try: \(openCommand)")
        } catch {
            Terminal.shared.log(error.localizedDescription)
            throw error
        }
    }
    
    private func _update_highway() throws -> HomeBundle {
        let homeBundle = try self.__ensureValidHomeBundle()
        try HomeBundleUpdater(homeBundle: homeBundle, context: context).update()
        return homeBundle
    }
    
    private func _bootstrap() throws {
        let _ = try self.__ensureValidHomeBundle()
    }
    
    private func _clean() throws  {
        let config = HighwayBundle.Configuration.standard
        Terminal.shared.log("Cleaning \(config.directoryName)\(String.elli)")
        
        guard let bundle = __currentHighwayBundle() else {
            Terminal.shared.log("Nothing to do")
            return
        }
        
        let result = try bundle.clean()
        Terminal.shared.log("DONE")
        let lines = result.deletedFiles.map { "Deleted '\($0.path)'" }
        let list = List(lines: lines)
        Terminal.shared.write(list)
        Terminal.shared.write(String.newline)
    }
    
    private func _version() throws {
        let line = Line(prompt: .normal, text: Text("highway \(CurrentVersion)"))
        Terminal.shared.write(line)
        Terminal.shared.write(String.newline)
    }
    
    private func _handleError(error: Swift.Error) {
        Terminal.shared.log(error.localizedDescription)
        exit(EXIT_FAILURE)
    }

    // Try to forward args to the highway project.
    // If it does not exist help the user.
    private func _fallbackCommand(args: [String]) throws {
        guard let bundle = __currentHighwayBundle() else {
            Terminal.shared.log("No highway project found.")
            try _showAllHighways()
            return
        }
        let args = Array(CommandLine.arguments.dropFirst())
        let projectTool = try HighwayProjectTool(compiler: swift_build, bundle: bundle, context: context)
        _ = try projectTool.build(thenExecuteWith: args, currentDirectoryUrl: context.currentWorkingUrl)
    }
    
    private func _showAllHighways() throws {
        let customHighways = __customHighways()
        let ownedHighways = highways.highways.rawHighways
        let list = HighwaysList(ownedHighways: ownedHighways, customHighways: customHighways)
        let t = Terminal.shared
        t.write("\n")
        t.write(SubText(String.whitespace(3) + "highway\n", bold: true))
        t.write(String.whitespace(3) + "Automate development tasks.\n")
        t.write(String.whitespace(3) + "Nothing new to learn. It is just Swift.\n")
        t.write("\n")
        t.write(list)
    }
    
    private func _self_update() throws {
        let homeBundle = try _update_highway()
        let updater = SelfUpdater(homeBundle: homeBundle, context: context)
        try updater.update()
        exit(EXIT_SUCCESS)
    }

    func run(with arguments: [String]) {
        highways
            .highway(.initialize, _init)
            .highway(.help, _showAllHighways)
            .highway(.generate, _generate)
            .highway(.bootstrap, _bootstrap)
            .highway(.clean, _clean)
            .highway(.version, _version)
            .highway(.self_update, _self_update)
            .onError(_handleError)
            .onEmptyCommand(_showAllHighways)
            .onUnrecognizedCommand(_fallbackCommand)
            .go()
        exit(EXIT_SUCCESS)
    }
}
