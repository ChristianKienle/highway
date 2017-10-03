import Foundation
import HighwayCore
import HWKit
import Terminal
import FSKit

final class App {
    // MARK: Properties
    private let fileSystem: FileSystem
    private let context = Context.local()
    private let highways = Highways(AppHighway.self)
    private lazy var swift_build:SwiftBuildSystem = {
        return SwiftBuildSystem(context: context)
    }()
    private let terminal = Terminal.shared

    // MARK: Creating
    init(fileSystem: FileSystem) {
        self.fileSystem = fileSystem
        highways.addPrivateHighway(PrivateHighway.bootstrapAndUpdate, _private_bootstrapAndUpdate)
    }
    
    // MARK: - Private Highways
    private func _private_bootstrapAndUpdate() throws {
        try _bootstrap()
        let _ = try _update_highway()
    }
    
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
        let parentUrl = getabscwd()
        return try? HighwayBundle(fileSystem: fileSystem,
                                  parentUrl: parentUrl,
                                  configuration: .standard)
    }
    
    /// Updates the frameworks _highway is using.
    private func _updateDependencies() throws {
        guard let bundle = __currentHighwayBundle() else {
            terminal.log("Update failed. No highway project found."); return
        }
        do {
            terminal.log("Updating support frameworks…")
            let _highway = try HighwayProjectTool(compiler: swift_build, bundle: bundle, context: context)
            try _highway.update()
            terminal.log("Success")
        } catch {
            terminal.log("Update failed. It happens…: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Custom Highways
    private func _init() throws {
        try self.__ensureValidHomeBundle()
        let projectBundle = try HighwayBundle(creatingInParent: getabscwd(), fileSystem: fileSystem, configuration: .standard, homeBundleConfiguration: .standard)
        terminal.log("Created at: \(projectBundle.url). Try 'highway generate'.")
        try self._updateDependencies()
    }
    
    // HACK
    private func _init_swift(_ invocation: Invocation) throws {
        try self.__ensureValidHomeBundle()
        let projectBundle = try HighwayBundle(creatingInParent: getabscwd(), fileSystem: fileSystem, configuration: .standard, homeBundleConfiguration: .standard)
        let main_swift_data = mainSwiftSubtypeSwiftTemplate.data(using: .utf8)!
        try projectBundle.write(mainSwiftData: main_swift_data)
        let swift_package = SwiftPackageTool(context: context)
        try swift_package.package(arguments: ["init", "--type", "executable"], currentDirectoryUrl: getabscwd())
        terminal.log("Created at: \(projectBundle.url). Try 'highway generate'.")
        try self._updateDependencies()
    }
    
    private func _generate() throws {
        terminal.log("Creating Xcode project\(String.elli)")
        guard let bundle = __currentHighwayBundle() else {
            terminal.log("Cannot generate an Xcode project without a highway project")
            terminal.log("present in the current working directory.")
            try _showHelp()
            return
        }
        
        do {
            let project = try XCProjectGenerator(context: context, bundle: bundle).generate()
            terminal.log("DONE. Try:")
            terminal.log("  " + project.openCommand)
        } catch {
            terminal.log(error.localizedDescription)
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
        terminal.log("Cleaning \(config.directoryName)\(String.elli)")
        guard let bundle = __currentHighwayBundle() else {
            terminal.log("Nothing to do")
            return
        }
        let result = try bundle.clean()
        terminal.log("DONE")
        let lines = result.deletedFiles.map { "Deleted '\($0.path)'" }
        let list = List(lines: lines)
        terminal.write(list)
        terminal.write(String.newline)
    }
    
    private func _version() throws {
        let line = Line(prompt: .normal, text: Text("highway \(CurrentVersion)"))
        terminal.write(line)
        terminal.write(String.newline)
    }
    
    private func _self_update() throws {
        let homeBundle = try _update_highway()
        let updater = SelfUpdater(homeBundle: homeBundle, context: context)
        try updater.update()
        exit(EXIT_SUCCESS)
    }
    
    private func _handleError(error: Swift.Error) {
        terminal.log(error.localizedDescription)
        exit(EXIT_FAILURE)
    }

    // Try to forward args to the highway project.
    // If it does not exist help the user.
    private func _fallbackCommand(args: [String]) throws {
        guard let bundle = __currentHighwayBundle() else {
            terminal.log("No highway project found.")
            try _showHelp()
            return
        }
        let args = Array(CommandLine.arguments.dropFirst())
        let projectTool = try HighwayProjectTool(compiler: swift_build, bundle: bundle, context: context)
        _ = try projectTool.build(thenExecuteWith: args)
    }
    
    private func _showHelp() throws {
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

    func run(with arguments: [String]) {
        highways
            .highway(.initialize_swift, _init_swift)
            .highway(.initialize, _init)
            .highway(.help, _showHelp)
            .highway(.generate, _generate)
            .highway(.bootstrap, _bootstrap)
            .highway(.clean, _clean)
            .highway(.version, _version)
            .highway(.self_update, _self_update)
            .onError(_handleError)
            .onEmptyCommand(_showHelp)
            .onUnrecognizedCommand(_fallbackCommand)
            .go()
        exit(EXIT_SUCCESS)
    }
}
