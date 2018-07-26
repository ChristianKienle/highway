import Foundation
import HighwayCore
import HWKit
import Terminal
import ZFile
import Arguments
import HighwayProject
import POSIX

final class App: Highway<AppHighway> {
    // MARK: Highway Overrides
    override func setupHighways() {
        self[.initialize] ==> _init
        self[.help] ==> _showHelp
        self[.generate] ==> _generate
        self[.bootstrap] ==> _bootstrap
        self[.clean] ==> _clean
        self[.version] ==> _version
        self[.self_update] ==> _self_update
        onError = _handleError
        onEmptyCommand = _showHelp
        onUnrecognizedCommand = _fallbackCommand
    }
    
    // MARK: - Private Highways
    private func __customHighways() -> [HighwayDescription] {
        // Try to get the bundle
        // if the are not able to get it just show the help.
        guard let bundle = __currentHighwayBundle() else {
            return []
        }
        return (HighwayProjectTool(compiler: swift, bundle: bundle, context: context).availableHighways())
    }
    
    @discardableResult
    private func __ensureValidHomeBundle() throws -> HomeBundle {
        let config = HomeBundle.Configuration.standard
        let homeDir = fileSystem.currentFolder
        let highwayHomeDirectory = try homeDir.createSubfolderIfNeeded(withName: config.directoryName)
        let bootstrap = Bootstraper(homeDirectory: highwayHomeDirectory, configuration: config, git: git, context: context)
        return try bootstrap.requestHomeBundle()
    }
    
    // MARK: - Helper
    private func __currentHighwayBundle() -> HighwayBundle? {
        return try? HighwayBundle(fileSystem: fileSystem,
                                  parentUrl: FileSystem().currentFolder,
                                  configuration: .standard)
    }
    
    /// Updates the frameworks _highway is using.
    private func _updateDependencies() throws {
        guard let bundle = __currentHighwayBundle() else {
            ui.error("Update failed. No highway project found."); return
        }
        do {
            ui.message("Updating support frameworks…")
            let _highway = HighwayProjectTool(compiler: swift, bundle: bundle, context: context)
            try _highway.update()
            ui.success("Success")
        } catch {
            ui.error("Update failed. It happens…: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Custom Highways
    private func _init() throws {
        try self.__ensureValidHomeBundle()
        let projectBundle = try HighwayBundle(creatingInParent: FileSystem().currentFolder,
                                              fileSystem: fileSystem,
                                              configuration: .standard,
                                              homeConfig: .standard
        )
        ui.message("Created at: \(projectBundle.url). Try 'highway generate'.")
    }
    
    private func _generate() throws {
        ui.message("Creating Xcode project\(String.elli)")
        guard let bundle = __currentHighwayBundle() else {
            ui.error("Cannot generate an Xcode project without a highway project")
            ui.error("present in the current working directory.")
            try _showHelp()
            return
        }
        let project = try XCProjectGenerator(context: context, bundle: bundle).generate()
        ui.success("DONE. Try:")
        ui.success("  " + project.name)
    }
    
    private func _update_highway() throws -> HomeBundle {
        let homeBundle = try self.__ensureValidHomeBundle()
        try HomeBundleUpdater(homeBundle: homeBundle, context: context, git: git).update()
        return homeBundle
    }
    
    private func _bootstrap() throws {
        let _ = try self.__ensureValidHomeBundle()
    }
    
    private func _clean() throws  {
        let config = Configuration.standard
        ui.message("Cleaning \(config.directoryName)\(String.elli)")
        guard let bundle = __currentHighwayBundle() else {
            ui.message("Nothing to do")
            return
        }
        try bundle.clean()
        ui.success("DONE")
        ui.print(String.newline)
    }
    
    private func _version() throws {
        let line = Line(prompt: .normal, text: Text("highway \(CurrentVersion)"))
        ui.print(line)
        ui.print(String.newline)
    }
    
    private func _self_update() throws {
        let homeBundle = try _update_highway()
        let updater = SelfUpdater(homeBundle: homeBundle, git: git, context: context)
        try updater.update()
        exit(EXIT_SUCCESS)
    }
    
    private func _handleError(error: Swift.Error) {
        var msg: String = ""
        dump(error, to: &msg)
        ui.error(msg)
        exit(EXIT_FAILURE)
    }
    
    // Try to forward args to the highway project.
    // If it does not exist help the user.
    private func _fallbackCommand(args: Arguments) throws {
        guard let bundle = __currentHighwayBundle() else {
            ui.error("No highway project found.")
            try _showHelp()
            return
        }
        let selfInvocation = CommandLineInvocationProvider().invocation()
        let arguments = (verbose ? ["--verbose"] : []) + [selfInvocation.highway] + selfInvocation.arguments.all
        let args = Arguments(arguments)
        let projectTool = HighwayProjectTool(compiler: swift, bundle: bundle, context: context)
        _ = try projectTool.build(thenExecuteWith: args)
    }
    
    private func _showHelp() throws {
        let info = appInfo(developerProvidedDescriptions: __customHighways())
        let prolog:Text =
            .newline +
            .whitespace(3) + .text("highway", bold: true) + .newline +
            .whitespace(3) + .text("Automate development tasks.") + .newline +
            .whitespace(3) + .text("Nothing new to learn. It is just Swift") + .newline +
            .newline
        ui.print(prolog)
        ui.print(info)
    }
}
