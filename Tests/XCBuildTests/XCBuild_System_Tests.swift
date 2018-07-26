import XCTest
import XCBuild
import ZFile
import Url
import HighwayCore
@testable import Task
import Deliver
import Keychain
import SourceryMocks

final class XCBuildTests: XCTestCase {
    // MARK: - XCTest
    /// We override invokeTest to disable tests in this file in case HIGHWAY_SYSTEM_TEST is not set.
    /// The system tests require a specific setup (profiles, certificates, ...) that is only present on 'my' machine.
    /// The tests also only work if there are two keychain items:
    /// - HIGHWAY_DELIVER_PASSWORD
    /// - HIGHWAY_DELIVER_USERNAME
    override func invokeTest() {
        if ProcessInfo.processInfo.environment["HIGHWAY_SYSTEM_TEST"] == nil {
            print("⚠️  HIGHWAY_SYSTEM_TEST not set: System Tests are not executed.")
        } else {
            print("✅  HIGHWAY_SYSTEM_TEST set: Executing test.\(invocation?.selector.description ?? "none")")
            guard let newCredentials = try? retrieveCredentials() else {
                XCTFail("Failed to get credentials")
                return
            }
            credentials = newCredentials
            super.invokeTest()
        }
    }
    
    // MARK: - Helper
    let fixturesDir = URL(fileURLWithPath: #file).deletingLastPathComponent().appendingPathComponent("Fixtures")
    let system = LocalSystem.local()
    let fs = FileSystemProtocolMock()
    
    var credentials: Credentials = Credentials(username: "", password: "")
    
    struct Credentials { let username: String; let password: String }
    private func retrieveCredentials() throws -> Credentials {
        let keychain = Keychain(system: LocalSystem.local())
        do {
            let password = try keychain.password(matching: .init(account: "HIGHWAY_DELIVER_PASSWORD", service: "HIGHWAY_DELIVER_PASSWORD"))
            let username = try keychain.password(matching: .init(account: "HIGHWAY_DELIVER_USERNAME", service: "HIGHWAY_DELIVER_USERNAME"))
            return Credentials(username: username, password: password)
        } catch {
            XCTFail("Failed to get username/password from the Keychain. To resolve this issue disable the system tests (default) or create two Keychain items: HIGHWAY_DELIVER_PASSWORD and HIGHWAY_DELIVER_USERNAME.")
            XCTFail(error.localizedDescription)
            throw error
        }
    }
    private func incrementBuildNumber(plistUrl: URL) throws {
        let data = try Data(contentsOf: plistUrl)
        let rawList = try PropertyListSerialization.propertyList(from: data, options: [], format: nil)
        guard let _list = rawList as? [String:Any] else {
            throw "wrong format"
        }
        var list = _list
        guard let rawBuildNumber = list["CFBundleVersion"] as? String else {
            throw "CFBundleVersion not found or no string"
        }
        
        guard let buildNumber = Int(rawBuildNumber) else {
            throw "CFBundleVersion not found or no string"
        }
        
        let newNumber = String(buildNumber + 1)
        list["CFBundleVersion"] = newNumber
        let newData = try PropertyListSerialization.data(fromPropertyList: list, format: .xml, options: 0)
        try newData.write(to: plistUrl)
        
    }
    // MARK: - Tests
    func test_test_action() throws {
        let provider = SystemExecutableProvider.local()
        provider.searchedUrls += ["/usr/local/bin/"] // a bit hacky - but that enables xcpretty
        system.executableProvider = provider
        let projectRoot = fixturesDir.appendingPathComponent("highwayiostest_objc")
        let projectUrl = projectRoot.appendingPathComponent("highwayiostest.xcodeproj")

        let options = TestOptionsProtocolMock()
        options.project = projectUrl.path
        options.destination = Destination.simulator(.iOS, name: "iPhone 7", os: .latest, id: nil)
        options.scheme = "highwayiostest"
        
        let xcbuild = XCBuild(system: system, fileSystem: fs)
        let result = try xcbuild.buildAndTest(using: options)
        print(result)
    }
    func testArchive_and_Export_using_object_plist() throws {
        let projectRoot = fixturesDir.appendingPathComponent("highwayiostest_objc")
        let infoPlistUrl = fixturesDir.appendingPathComponent("highwayiostest/highwayiostest/Info.plist")
        try incrementBuildNumber(plistUrl: infoPlistUrl)
        let projectUrl = projectRoot.appendingPathComponent("highwayiostest.xcodeproj")
        
        var options = ArchiveOptions(
            scheme: "highwayiostest",
            project: "mock highway project",
            destination: Destination.device(.iOS, name: nil, isGeneric: true, id: nil),
            archivePath: "Mock archive path"
        )
        
        let build = XCBuild(system: system, fileSystem: fs)
        try build.archive(using: options)
        
        var exportArchiveOptions = ExportArchiveOptions(
            archivePath: options.archivePath,
            exportPath: "mock export path"
        )
        
        var exportOptions = ExportOptions()
        exportOptions.method = .appStore
        exportOptions.thinning = .all
        
        var profiles = ExportOptions.ProvisioningProfiles()
        profiles.addProfile(.named("highwayiostest Prod Profile"),
                            forBundleIdentifier: "de.christian-kienle.highway.e2e.ios")
        exportOptions.provisioningProfiles = profiles
        let plist = try PlistFactory.plist(byWriting: exportOptions, to: fs)
        exportArchiveOptions.exportOptionsPlist = plist
        let export = try build.export(using: exportArchiveOptions)
        print("ipaUrl: \(export.ipaUrl)")
        let deliver = Deliver.Local(altool: Altool(system: system, fileSystem: fs))
        try deliver.now(with: Deliver.Options(ipaUrl: export.ipaUrl, username: credentials.username, password: .plain(credentials.password), platform: .iOS))
        print("DONE")
    }
    
    func testArchive_and_Export_using_file_plist() throws {
        let projectRoot = fixturesDir.appendingPathComponent("highwayiostest_objc")
        let infoPlistUrl = fixturesDir.appendingPathComponent("highwayiostest/highwayiostest/Info.plist")
        try incrementBuildNumber(plistUrl: infoPlistUrl)
        let projectUrl = projectRoot.appendingPathComponent("highwayiostest.xcodeproj")
        
        var options = ArchiveOptions(
            scheme: "highwayiostest",
            project: projectUrl.path,
            destination: Destinationpr,
        options.archivePath = try fs.uniqueTemporaryDirectoryUrl().appending("uud.xcarchive").path
        
        let build = XCBuild(system: system, fileSystem: fs)
        try build.archive(using: options)
        
        var exportArchiveOptions = ExportArchiveOptions()
        exportArchiveOptions.archivePath = options.archivePath
        exportArchiveOptions.exportPath = try fs.uniqueTemporaryDirectoryUrl().path
        
        
        let plistUrl = Absolute(URL(fileURLWithPath: #file)
            .deletingLastPathComponent()
            .appendingPathComponent("Fixtures")
            .appendingPathComponent("highwayiostest_export.plist"))
        
        exportArchiveOptions.exportOptionsPlist = try? PlistFactory.plist(byReading: plistUrl, in: fs)
        
        let export = try build.export(using: exportArchiveOptions)
        print("ipaUrl: \(export.ipaUrl)")
        let deliver = Deliver.Local(altool: Altool(system: system, fileSystem: fs))
        try deliver.now(with: Deliver.Options(ipaUrl: export.ipaUrl, username: credentials.username, password: .plain(credentials.password), platform: .iOS))
        print("DONE")
    }
}
