// Generated using Sourcery 0.13.1 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

// swiftlint:disable line_length
// swiftlint:disable variable_name

import Foundation
import os
import XCBuild

#if os(iOS) || os(tvOS) || os(watchOS)
import UIKit
#elseif os(OSX)
import AppKit
#endif

import XCBuild
import ZFile
import ZFile
import Deliver
import Task
import Git
import Keychain
import SourceryAutoProtocols
import Terminal
import HighwayCore
import HWKit
import Arguments















// MARK: - ArchiveOptionsProtocolMock

open class ArchiveOptionsProtocolMock: ArchiveOptionsProtocol {

    public init() {}

    public var scheme: String {
        get { return underlyingScheme }
        set(value) { underlyingScheme = value }
    }
    public var underlyingScheme: String = "AutoMockable filled value"
    public var project: String {
        get { return underlyingProject }
        set(value) { underlyingProject = value }
    }
    public var underlyingProject: String = "AutoMockable filled value"
    public var destination: DestinationProtocol {
        get { return underlyingDestination }
        set(value) { underlyingDestination = value }
    }
    public var underlyingDestination: DestinationProtocol!
    public var archivePath: String {
        get { return underlyingArchivePath }
        set(value) { underlyingArchivePath = value }
    }
    public var underlyingArchivePath: String = "AutoMockable filled value"

}


// MARK: - ArchivePlistProtocolMock

open class ArchivePlistProtocolMock: ArchivePlistProtocol {

    public init() {}

    public var applicationProperties: String {
        get { return underlyingApplicationProperties }
        set(value) { underlyingApplicationProperties = value }
    }
    public var underlyingApplicationProperties: String = "AutoMockable filled value"
    public var applicationPath: String {
        get { return underlyingApplicationPath }
        set(value) { underlyingApplicationPath = value }
    }
    public var underlyingApplicationPath: String = "AutoMockable filled value"

}


// MARK: - ArchiveProtocolMock

open class ArchiveProtocolMock: ArchiveProtocol {

    public init() {}

    public var archiveFolder: FolderProtocol {
        get { return underlyingArchiveFolder }
        set(value) { underlyingArchiveFolder = value }
    }
    public var underlyingArchiveFolder: FolderProtocol!
    public var appFolder: FolderProtocol {
        get { return underlyingAppFolder }
        set(value) { underlyingAppFolder = value }
    }
    public var underlyingAppFolder: FolderProtocol!
    public var plist: ArchivePlistProtocol {
        get { return underlyingPlist }
        set(value) { underlyingPlist = value }
    }
    public var underlyingPlist: ArchivePlistProtocol!

}


// MARK: - BuildResultProtocolMock

open class BuildResultProtocolMock: BuildResultProtocol {

    public init() {}

    public var executableUrl: FileProtocol {
        get { return underlyingExecutableUrl }
        set(value) { underlyingExecutableUrl = value }
    }
    public var underlyingExecutableUrl: FileProtocol!
    public var artifact: SwiftBuildSystem.Artifact {
        get { return underlyingArtifact }
        set(value) { underlyingArtifact = value }
    }
    public var underlyingArtifact: SwiftBuildSystem.Artifact!

}


// MARK: - DeliverProtocolMock

open class DeliverProtocolMock: DeliverProtocol {

    public init() {}


    //MARK: - now

    public  var nowWithThrowableError: Error?
    public var nowWithCallsCount = 0
    public var nowWithCalled: Bool {
        return nowWithCallsCount > 0
    }
    public var nowWithReceivedOptions: Deliver.Options?
    public var nowWithReturnValue: Bool?
    public var nowWithClosure: ((Deliver.Options) throws -> Bool)? = nil

    open func now(with options: Deliver.Options) throws -> Bool {

        if let error = nowWithThrowableError {
            throw error
        }


      nowWithCallsCount += 1
        nowWithReceivedOptions = options


      guard let closureReturn = nowWithClosure else {
          guard let returnValue = nowWithReturnValue else {
              let message = """
                🧙‍♂️ 🔥asked to return a value for name parameters:
                    nowWith
                    but this case(s) is(are) not implemented in
                    DeliverProtocol for method nowWithClosure.
                """
              let error = SourceryMockError.implementErrorCaseFor(message)
                 throw error
          }
          return returnValue
      }

      return try closureReturn(options)
    }

}


// MARK: - DestinationFactoryProtocolMock

open class DestinationFactoryProtocolMock: DestinationFactoryProtocol {

    public init() {}


    //MARK: - macOS

    public var macOSArchitectureCallsCount = 0
    public var macOSArchitectureCalled: Bool {
        return macOSArchitectureCallsCount > 0
    }
    public var macOSArchitectureReceivedArchitecture: Destination.Architecture?
    public var macOSArchitectureReturnValue: Destination?
    public var macOSArchitectureClosure: ((Destination.Architecture) -> Destination)? = nil

    open func macOS(architecture: Destination.Architecture) -> Destination {

      macOSArchitectureCallsCount += 1
        macOSArchitectureReceivedArchitecture = architecture


      guard let closureReturn = macOSArchitectureClosure else {
          guard let returnValue = macOSArchitectureReturnValue else {
              let message = """
                🧙‍♂️ 🔥asked to return a value for name parameters:
                    macOSArchitecture
                    but this case(s) is(are) not implemented in
                    DestinationFactoryProtocol for method macOSArchitectureClosure.
                """
              let error = SourceryMockError.implementErrorCaseFor(message)
              os_log("🧙‍♂️ 🔥 %@", type: .error, "\(error)")
              return macOSArchitectureReturnValue!
          }
          return returnValue
      }

      return closureReturn(architecture)
    }

    //MARK: - device

    public var deviceNameIsGenericIdCallsCount = 0
    public var deviceNameIsGenericIdCalled: Bool {
        return deviceNameIsGenericIdCallsCount > 0
    }
    public var deviceNameIsGenericIdReceivedArguments: (device: Destination.Device, name: String?, isGeneric: Bool, id: String?)?
    public var deviceNameIsGenericIdReturnValue: Destination?
    public var deviceNameIsGenericIdClosure: ((Destination.Device, String?, Bool, String?) -> Destination)? = nil

    open func device(_ device: Destination.Device, name: String?, isGeneric: Bool, id: String?) -> Destination {

      deviceNameIsGenericIdCallsCount += 1
        deviceNameIsGenericIdReceivedArguments = (device: device, name: name, isGeneric: isGeneric, id: id)


      guard let closureReturn = deviceNameIsGenericIdClosure else {
          guard let returnValue = deviceNameIsGenericIdReturnValue else {
              let message = """
                🧙‍♂️ 🔥asked to return a value for name parameters:
                    deviceNameIsGenericId
                    but this case(s) is(are) not implemented in
                    DestinationFactoryProtocol for method deviceNameIsGenericIdClosure.
                """
              let error = SourceryMockError.implementErrorCaseFor(message)
              os_log("🧙‍♂️ 🔥 %@", type: .error, "\(error)")
              return deviceNameIsGenericIdReturnValue!
          }
          return returnValue
      }

      return closureReturn(device, name, isGeneric, id)
    }

    //MARK: - simulator

    public var simulatorNameOsIdCallsCount = 0
    public var simulatorNameOsIdCalled: Bool {
        return simulatorNameOsIdCallsCount > 0
    }
    public var simulatorNameOsIdReceivedArguments: (simulator: Destination.Simulator, name: String, os: Destination.OS, id: String?)?
    public var simulatorNameOsIdReturnValue: Destination?
    public var simulatorNameOsIdClosure: ((Destination.Simulator, String, Destination.OS, String?) -> Destination)? = nil

    open func simulator(_ simulator: Destination.Simulator, name: String, os: Destination.OS, id: String?) -> Destination {

      simulatorNameOsIdCallsCount += 1
        simulatorNameOsIdReceivedArguments = (simulator: simulator, name: name, os: os, id: id)


      guard let closureReturn = simulatorNameOsIdClosure else {
          guard let returnValue = simulatorNameOsIdReturnValue else {
              let message = """
                🧙‍♂️ 🔥asked to return a value for name parameters:
                    simulatorNameOsId
                    but this case(s) is(are) not implemented in
                    DestinationFactoryProtocol for method simulatorNameOsIdClosure.
                """
              let error = SourceryMockError.implementErrorCaseFor(message)
              os_log("🧙‍♂️ 🔥 %@", type: .error, "\(error)")
              return simulatorNameOsIdReturnValue!
          }
          return returnValue
      }

      return closureReturn(simulator, name, os, id)
    }

}


// MARK: - DestinationProtocolMock

open class DestinationProtocolMock: DestinationProtocol {

    public init() {}

    public var raw: [String: String] = [:]
    public var asString: String {
        get { return underlyingAsString }
        set(value) { underlyingAsString = value }
    }
    public var underlyingAsString: String = "AutoMockable filled value"

}


// MARK: - ExecutableProviderMock

open class ExecutableProviderMock: ExecutableProvider {

    public init() {}


    //MARK: - executable

    public  var executableWithThrowableError: Error?
    public var executableWithCallsCount = 0
    public var executableWithCalled: Bool {
        return executableWithCallsCount > 0
    }
    public var executableWithReceivedName: String?
    public var executableWithReturnValue: FileProtocol?
    public var executableWithClosure: ((String) throws -> FileProtocol)? = nil

    open func executable(with name: String) throws -> FileProtocol {

        if let error = executableWithThrowableError {
            throw error
        }


      executableWithCallsCount += 1
        executableWithReceivedName = name


      guard let closureReturn = executableWithClosure else {
          guard let returnValue = executableWithReturnValue else {
              let message = """
                🧙‍♂️ 🔥asked to return a value for name parameters:
                    executableWith
                    but this case(s) is(are) not implemented in
                    ExecutableProvider for method executableWithClosure.
                """
              let error = SourceryMockError.implementErrorCaseFor(message)
                 throw error
          }
          return returnValue
      }

      return try closureReturn(name)
    }

}


// MARK: - ExportArchiveOptionsProtocolMock

open class ExportArchiveOptionsProtocolMock: ExportArchiveOptionsProtocol {

    public init() {}

    public var archivePath: FolderProtocol {
        get { return underlyingArchivePath }
        set(value) { underlyingArchivePath = value }
    }
    public var underlyingArchivePath: FolderProtocol!
    public var exportPath: String {
        get { return underlyingExportPath }
        set(value) { underlyingExportPath = value }
    }
    public var underlyingExportPath: String = "AutoMockable filled value"

    public required init(from decoder: Decoder) throws {
        
    }
    
    public func encode(to encoder: Encoder) throws {
        
    }
}


// MARK: - ExportProtocolMock

open class ExportProtocolMock: ExportProtocol {

    public init() {}

    public var folder: FolderProtocol {
        get { return underlyingFolder }
        set(value) { underlyingFolder = value }
    }
    public var underlyingFolder: FolderProtocol!
    public var ipa: FileProtocol {
        get { return underlyingIpa }
        set(value) { underlyingIpa = value }
    }
    public var underlyingIpa: FileProtocol!

}


// MARK: - FileProtocolMock

open class FileProtocolMock: FileProtocol {


    public var localizedDate: String {
        get { return underlyingLocalizedDate }
        set(value) { underlyingLocalizedDate = value }
    }
    public var underlyingLocalizedDate: String = "AutoMockable filled value"
    public var path: String {
        get { return underlyingPath }
        set(value) { underlyingPath = value }
    }
    public var underlyingPath: String = "AutoMockable filled value"
    public var name: String {
        get { return underlyingName }
        set(value) { underlyingName = value }
    }
    public var underlyingName: String = "AutoMockable filled value"
    public var nameExcludingExtension: String {
        get { return underlyingNameExcludingExtension }
        set(value) { underlyingNameExcludingExtension = value }
    }
    public var underlyingNameExcludingExtension: String = "AutoMockable filled value"
    public var `extension`: String?
    public var modificationDate: Date {
        get { return underlyingModificationDate }
        set(value) { underlyingModificationDate = value }
    }
    public var underlyingModificationDate: Date = Date()
    public var description: String {
        get { return underlyingDescription }
        set(value) { underlyingDescription = value }
    }
    public var underlyingDescription: String = "AutoMockable filled value"

    //MARK: - readAllLines

    public  var readAllLinesThrowableError: Error?
    public var readAllLinesCallsCount = 0
    public var readAllLinesCalled: Bool {
        return readAllLinesCallsCount > 0
    }
    public var readAllLinesReturnValue: [String]?
    public var readAllLinesClosure: (() throws -> [String])? = nil

    open func readAllLines() throws -> [String] {

        if let error = readAllLinesThrowableError {
            throw error
        }


      readAllLinesCallsCount += 1


      guard let closureReturn = readAllLinesClosure else {
          guard let returnValue = readAllLinesReturnValue else {
              let message = """
                🧙‍♂️ 🔥asked to return a value for name parameters:
                    readAllLines
                    but this case(s) is(are) not implemented in
                    FileProtocol for method readAllLinesClosure.
                """
              let error = SourceryMockError.implementErrorCaseFor(message)
                 throw error
          }
          return returnValue
      }

      return try closureReturn()
    }

    //MARK: - read

    public  var readThrowableError: Error?
    public var readCallsCount = 0
    public var readCalled: Bool {
        return readCallsCount > 0
    }
    public var readReturnValue: Data?
    public var readClosure: (() throws -> Data)? = nil

    open func read() throws -> Data {

        if let error = readThrowableError {
            throw error
        }


      readCallsCount += 1


      guard let closureReturn = readClosure else {
          guard let returnValue = readReturnValue else {
              let message = """
                🧙‍♂️ 🔥asked to return a value for name parameters:
                    read
                    but this case(s) is(are) not implemented in
                    FileProtocol for method readClosure.
                """
              let error = SourceryMockError.implementErrorCaseFor(message)
                 throw error
          }
          return returnValue
      }

      return try closureReturn()
    }

    //MARK: - readAsString

    public  var readAsStringThrowableError: Error?
    public var readAsStringCallsCount = 0
    public var readAsStringCalled: Bool {
        return readAsStringCallsCount > 0
    }
    public var readAsStringReturnValue: String?
    public var readAsStringClosure: (() throws -> String)? = nil

    open func readAsString() throws -> String {

        if let error = readAsStringThrowableError {
            throw error
        }


      readAsStringCallsCount += 1


      guard let closureReturn = readAsStringClosure else {
          guard let returnValue = readAsStringReturnValue else {
              let message = """
                🧙‍♂️ 🔥asked to return a value for name parameters:
                    readAsString
                    but this case(s) is(are) not implemented in
                    FileProtocol for method readAsStringClosure.
                """
              let error = SourceryMockError.implementErrorCaseFor(message)
                 throw error
          }
          return returnValue
      }

      return try closureReturn()
    }

    //MARK: - write

    public  var writeDataThrowableError: Error?
    public var writeDataCallsCount = 0
    public var writeDataCalled: Bool {
        return writeDataCallsCount > 0
    }
    public var writeDataReceivedData: Data?
    public var writeDataClosure: ((Data) throws -> Void)? = nil

    open func write(data: Data) throws {

        if let error = writeDataThrowableError {
            throw error
        }


      writeDataCallsCount += 1
        writeDataReceivedData = data


      try writeDataClosure?(data)

    }

    //MARK: - write

    public  var writeStringEncodingThrowableError: Error?
    public var writeStringEncodingCallsCount = 0
    public var writeStringEncodingCalled: Bool {
        return writeStringEncodingCallsCount > 0
    }
    public var writeStringEncodingReceivedArguments: (string: String, encoding: String.Encoding)?
    public var writeStringEncodingClosure: ((String, String.Encoding) throws -> Void)? = nil

    open func write(string: String, encoding: String.Encoding) throws {

        if let error = writeStringEncodingThrowableError {
            throw error
        }


      writeStringEncodingCallsCount += 1
        writeStringEncodingReceivedArguments = (string: string, encoding: encoding)


      try writeStringEncodingClosure?(string, encoding)

    }

    //MARK: - copy

    public  var copyToThrowableError: Error?
    public var copyToCallsCount = 0
    public var copyToCalled: Bool {
        return copyToCallsCount > 0
    }
    public var copyToReceivedFolder: Folder?
    public var copyToReturnValue: FileProtocol?
    public var copyToClosure: ((Folder) throws -> FileProtocol)? = nil

    open func copy(to folder: Folder) throws -> FileProtocol {

        if let error = copyToThrowableError {
            throw error
        }


      copyToCallsCount += 1
        copyToReceivedFolder = folder


      guard let closureReturn = copyToClosure else {
          guard let returnValue = copyToReturnValue else {
              let message = """
                🧙‍♂️ 🔥asked to return a value for name parameters:
                    copyTo
                    but this case(s) is(are) not implemented in
                    FileProtocol for method copyToClosure.
                """
              let error = SourceryMockError.implementErrorCaseFor(message)
                 throw error
          }
          return returnValue
      }

      return try closureReturn(folder)
    }

    //MARK: - parentFolder

    public  var parentFolderThrowableError: Error?
    public var parentFolderCallsCount = 0
    public var parentFolderCalled: Bool {
        return parentFolderCallsCount > 0
    }
    public var parentFolderReturnValue: FolderProtocol?
    public var parentFolderClosure: (() throws -> FolderProtocol)? = nil

    open func parentFolder() throws -> FolderProtocol {

        if let error = parentFolderThrowableError {
            throw error
        }


      parentFolderCallsCount += 1


      guard let closureReturn = parentFolderClosure else {
          guard let returnValue = parentFolderReturnValue else {
              let message = """
                🧙‍♂️ 🔥asked to return a value for name parameters:
                    parentFolder
                    but this case(s) is(are) not implemented in
                    ItemProtocol for method parentFolderClosure.
                """
              let error = SourceryMockError.implementErrorCaseFor(message)
                 throw error
          }
          return returnValue
      }

      return try closureReturn()
    }

    //MARK: - rename

    public  var renameToThrowableError: Error?
    public var renameToCallsCount = 0
    public var renameToCalled: Bool {
        return renameToCallsCount > 0
    }
    public var renameToReceivedNewName: String?
    public var renameToClosure: ((String) throws -> Void)? = nil

    open func rename(to newName: String) throws {

        if let error = renameToThrowableError {
            throw error
        }


      renameToCallsCount += 1
        renameToReceivedNewName = newName


      try renameToClosure?(newName)

    }

    //MARK: - rename

    public  var renameToKeepExtensionThrowableError: Error?
    public var renameToKeepExtensionCallsCount = 0
    public var renameToKeepExtensionCalled: Bool {
        return renameToKeepExtensionCallsCount > 0
    }
    public var renameToKeepExtensionReceivedArguments: (newName: String, keepExtension: Bool)?
    public var renameToKeepExtensionClosure: ((String, Bool) throws -> Void)? = nil

    open func rename(to newName: String, keepExtension: Bool) throws {

        if let error = renameToKeepExtensionThrowableError {
            throw error
        }


      renameToKeepExtensionCallsCount += 1
        renameToKeepExtensionReceivedArguments = (newName: newName, keepExtension: keepExtension)


      try renameToKeepExtensionClosure?(newName, keepExtension)

    }

    //MARK: - move

    public  var moveToThrowableError: Error?
    public var moveToCallsCount = 0
    public var moveToCalled: Bool {
        return moveToCallsCount > 0
    }
    public var moveToReceivedNewParent: Folder?
    public var moveToClosure: ((Folder) throws -> Void)? = nil

    open func move(to newParent: Folder) throws {

        if let error = moveToThrowableError {
            throw error
        }


      moveToCallsCount += 1
        moveToReceivedNewParent = newParent


      try moveToClosure?(newParent)

    }

    //MARK: - delete

    public  var deleteThrowableError: Error?
    public var deleteCallsCount = 0
    public var deleteCalled: Bool {
        return deleteCallsCount > 0
    }
    public var deleteClosure: (() throws -> Void)? = nil

    open func delete() throws {

        if let error = deleteThrowableError {
            throw error
        }


      deleteCallsCount += 1


      try deleteClosure?()

    }

    //MARK: - init

    public var initClosure: (() -> Void)? = nil

    public required init() {
        initClosure?()
    }
    //MARK: - init

    public  var initPathThrowableError: Error?
    public var initPathReceivedPath: String?
    public var initPathClosure: ((String) throws -> Void)? = nil

    public required init(path: String) throws {
        initPathReceivedPath = path
         try? initPathClosure?(path)
    }
}


// MARK: - FileSystemProtocolMock

open class FileSystemProtocolMock: FileSystemProtocol {


    public var temporaryFolder: Folder {
        get { return underlyingTemporaryFolder }
        set(value) { underlyingTemporaryFolder = value }
    }
    public var underlyingTemporaryFolder: Folder!
    public var homeFolder: Folder {
        get { return underlyingHomeFolder }
        set(value) { underlyingHomeFolder = value }
    }
    public var underlyingHomeFolder: Folder!
    public var currentFolder: Folder {
        get { return underlyingCurrentFolder }
        set(value) { underlyingCurrentFolder = value }
    }
    public var underlyingCurrentFolder: Folder!

    //MARK: - init

    public var initClosure: (() -> Void)? = nil

    public required init() {
        initClosure?()
    }
    //MARK: - init

    public var initUsingReceivedFileManager: FileManager?
    public var initUsingClosure: ((FileManager) -> Void)? = nil

    public required init(using fileManager: FileManager) {
        initUsingReceivedFileManager = fileManager
        initUsingClosure?(fileManager)
    }
    //MARK: - createFile

    public  var createFileAtThrowableError: Error?
    public var createFileAtCallsCount = 0
    public var createFileAtCalled: Bool {
        return createFileAtCallsCount > 0
    }
    public var createFileAtReceivedPath: String?
    public var createFileAtReturnValue: FileProtocol?
    public var createFileAtClosure: ((String) throws -> FileProtocol)? = nil

    open func createFile(at path: String) throws -> FileProtocol {

        if let error = createFileAtThrowableError {
            throw error
        }


      createFileAtCallsCount += 1
        createFileAtReceivedPath = path


      guard let closureReturn = createFileAtClosure else {
          guard let returnValue = createFileAtReturnValue else {
              let message = """
                🧙‍♂️ 🔥asked to return a value for name parameters:
                    createFileAt
                    but this case(s) is(are) not implemented in
                    FileSystemProtocol for method createFileAtClosure.
                """
              let error = SourceryMockError.implementErrorCaseFor(message)
                 throw error
          }
          return returnValue
      }

      return try closureReturn(path)
    }

    //MARK: - createFile

    public  var createFileAtDataContentsThrowableError: Error?
    public var createFileAtDataContentsCallsCount = 0
    public var createFileAtDataContentsCalled: Bool {
        return createFileAtDataContentsCallsCount > 0
    }
    public var createFileAtDataContentsReceivedArguments: (path: String, dataContents: Data)?
    public var createFileAtDataContentsReturnValue: FileProtocol?
    public var createFileAtDataContentsClosure: ((String, Data) throws -> FileProtocol)? = nil

    open func createFile(at path: String, dataContents: Data) throws -> FileProtocol {

        if let error = createFileAtDataContentsThrowableError {
            throw error
        }


      createFileAtDataContentsCallsCount += 1
        createFileAtDataContentsReceivedArguments = (path: path, dataContents: dataContents)


      guard let closureReturn = createFileAtDataContentsClosure else {
          guard let returnValue = createFileAtDataContentsReturnValue else {
              let message = """
                🧙‍♂️ 🔥asked to return a value for name parameters:
                    createFileAtDataContents
                    but this case(s) is(are) not implemented in
                    FileSystemProtocol for method createFileAtDataContentsClosure.
                """
              let error = SourceryMockError.implementErrorCaseFor(message)
                 throw error
          }
          return returnValue
      }

      return try closureReturn(path, dataContents)
    }

    //MARK: - createFileIfNeeded

    public  var createFileIfNeededAtThrowableError: Error?
    public var createFileIfNeededAtCallsCount = 0
    public var createFileIfNeededAtCalled: Bool {
        return createFileIfNeededAtCallsCount > 0
    }
    public var createFileIfNeededAtReceivedPath: String?
    public var createFileIfNeededAtReturnValue: FileProtocol?
    public var createFileIfNeededAtClosure: ((String) throws -> FileProtocol)? = nil

    open func createFileIfNeeded(at path: String) throws -> FileProtocol {

        if let error = createFileIfNeededAtThrowableError {
            throw error
        }


      createFileIfNeededAtCallsCount += 1
        createFileIfNeededAtReceivedPath = path


      guard let closureReturn = createFileIfNeededAtClosure else {
          guard let returnValue = createFileIfNeededAtReturnValue else {
              let message = """
                🧙‍♂️ 🔥asked to return a value for name parameters:
                    createFileIfNeededAt
                    but this case(s) is(are) not implemented in
                    FileSystemProtocol for method createFileIfNeededAtClosure.
                """
              let error = SourceryMockError.implementErrorCaseFor(message)
                 throw error
          }
          return returnValue
      }

      return try closureReturn(path)
    }

    //MARK: - createFileIfNeeded

    public  var createFileIfNeededAtContentsThrowableError: Error?
    public var createFileIfNeededAtContentsCallsCount = 0
    public var createFileIfNeededAtContentsCalled: Bool {
        return createFileIfNeededAtContentsCallsCount > 0
    }
    public var createFileIfNeededAtContentsReceivedArguments: (path: String, contents: Data)?
    public var createFileIfNeededAtContentsReturnValue: FileProtocol?
    public var createFileIfNeededAtContentsClosure: ((String, Data) throws -> FileProtocol)? = nil

    open func createFileIfNeeded(at path: String, contents: Data) throws -> FileProtocol {

        if let error = createFileIfNeededAtContentsThrowableError {
            throw error
        }


      createFileIfNeededAtContentsCallsCount += 1
        createFileIfNeededAtContentsReceivedArguments = (path: path, contents: contents)


      guard let closureReturn = createFileIfNeededAtContentsClosure else {
          guard let returnValue = createFileIfNeededAtContentsReturnValue else {
              let message = """
                🧙‍♂️ 🔥asked to return a value for name parameters:
                    createFileIfNeededAtContents
                    but this case(s) is(are) not implemented in
                    FileSystemProtocol for method createFileIfNeededAtContentsClosure.
                """
              let error = SourceryMockError.implementErrorCaseFor(message)
                 throw error
          }
          return returnValue
      }

      return try closureReturn(path, contents)
    }

    //MARK: - createFolder

    public  var createFolderAtThrowableError: Error?
    public var createFolderAtCallsCount = 0
    public var createFolderAtCalled: Bool {
        return createFolderAtCallsCount > 0
    }
    public var createFolderAtReceivedPath: String?
    public var createFolderAtReturnValue: FolderProtocol?
    public var createFolderAtClosure: ((String) throws -> FolderProtocol)? = nil

    open func createFolder(at path: String) throws -> FolderProtocol {

        if let error = createFolderAtThrowableError {
            throw error
        }


      createFolderAtCallsCount += 1
        createFolderAtReceivedPath = path


      guard let closureReturn = createFolderAtClosure else {
          guard let returnValue = createFolderAtReturnValue else {
              let message = """
                🧙‍♂️ 🔥asked to return a value for name parameters:
                    createFolderAt
                    but this case(s) is(are) not implemented in
                    FileSystemProtocol for method createFolderAtClosure.
                """
              let error = SourceryMockError.implementErrorCaseFor(message)
                 throw error
          }
          return returnValue
      }

      return try closureReturn(path)
    }

    //MARK: - createFolderIfNeeded

    public  var createFolderIfNeededAtThrowableError: Error?
    public var createFolderIfNeededAtCallsCount = 0
    public var createFolderIfNeededAtCalled: Bool {
        return createFolderIfNeededAtCallsCount > 0
    }
    public var createFolderIfNeededAtReceivedPath: String?
    public var createFolderIfNeededAtReturnValue: FolderProtocol?
    public var createFolderIfNeededAtClosure: ((String) throws -> FolderProtocol)? = nil

    open func createFolderIfNeeded(at path: String) throws -> FolderProtocol {

        if let error = createFolderIfNeededAtThrowableError {
            throw error
        }


      createFolderIfNeededAtCallsCount += 1
        createFolderIfNeededAtReceivedPath = path


      guard let closureReturn = createFolderIfNeededAtClosure else {
          guard let returnValue = createFolderIfNeededAtReturnValue else {
              let message = """
                🧙‍♂️ 🔥asked to return a value for name parameters:
                    createFolderIfNeededAt
                    but this case(s) is(are) not implemented in
                    FileSystemProtocol for method createFolderIfNeededAtClosure.
                """
              let error = SourceryMockError.implementErrorCaseFor(message)
                 throw error
          }
          return returnValue
      }

      return try closureReturn(path)
    }

    //MARK: - itemKind

    public var itemKindAtCallsCount = 0
    public var itemKindAtCalled: Bool {
        return itemKindAtCallsCount > 0
    }
    public var itemKindAtReceivedPath: String?
    public var itemKindAtReturnValue: FileSystem.Item.Kind??
    public var itemKindAtClosure: ((String) -> FileSystem.Item.Kind?)? = nil

    open func itemKind(at path: String) -> FileSystem.Item.Kind? {

      itemKindAtCallsCount += 1
        itemKindAtReceivedPath = path


      guard let closureReturn = itemKindAtClosure else {
          guard let returnValue = itemKindAtReturnValue else {
              let message = """
                🧙‍♂️ 🔥asked to return a value for name parameters:
                    itemKindAt
                    but this case(s) is(are) not implemented in
                    FileSystemProtocol for method itemKindAtClosure.
                """
              let error = SourceryMockError.implementErrorCaseFor(message)
              os_log("🧙‍♂️ 🔥 %@", type: .error, "\(error)")
              return itemKindAtReturnValue!
          }
          return returnValue
      }

      return closureReturn(path)
    }

}


// MARK: - FolderProtocolMock

open class FolderProtocolMock: FolderProtocol {


    public var path: String {
        get { return underlyingPath }
        set(value) { underlyingPath = value }
    }
    public var underlyingPath: String = "AutoMockable filled value"
    public var name: String {
        get { return underlyingName }
        set(value) { underlyingName = value }
    }
    public var underlyingName: String = "AutoMockable filled value"
    public var nameExcludingExtension: String {
        get { return underlyingNameExcludingExtension }
        set(value) { underlyingNameExcludingExtension = value }
    }
    public var underlyingNameExcludingExtension: String = "AutoMockable filled value"
    public var `extension`: String?
    public var modificationDate: Date {
        get { return underlyingModificationDate }
        set(value) { underlyingModificationDate = value }
    }
    public var underlyingModificationDate: Date = Date()
    public var description: String {
        get { return underlyingDescription }
        set(value) { underlyingDescription = value }
    }
    public var underlyingDescription: String = "AutoMockable filled value"

    //MARK: - mostRecentSubfolder

    public  var mostRecentSubfolderThrowableError: Error?
    public var mostRecentSubfolderCallsCount = 0
    public var mostRecentSubfolderCalled: Bool {
        return mostRecentSubfolderCallsCount > 0
    }
    public var mostRecentSubfolderReturnValue: FolderProtocol?
    public var mostRecentSubfolderClosure: (() throws -> FolderProtocol)? = nil

    open func mostRecentSubfolder() throws -> FolderProtocol {

        if let error = mostRecentSubfolderThrowableError {
            throw error
        }


      mostRecentSubfolderCallsCount += 1


      guard let closureReturn = mostRecentSubfolderClosure else {
          guard let returnValue = mostRecentSubfolderReturnValue else {
              let message = """
                🧙‍♂️ 🔥asked to return a value for name parameters:
                    mostRecentSubfolder
                    but this case(s) is(are) not implemented in
                    FolderProtocol for method mostRecentSubfolderClosure.
                """
              let error = SourceryMockError.implementErrorCaseFor(message)
                 throw error
          }
          return returnValue
      }

      return try closureReturn()
    }

    //MARK: - mostRecentFile

    public  var mostRecentFileThrowableError: Error?
    public var mostRecentFileCallsCount = 0
    public var mostRecentFileCalled: Bool {
        return mostRecentFileCallsCount > 0
    }
    public var mostRecentFileReturnValue: FileProtocol?
    public var mostRecentFileClosure: (() throws -> FileProtocol)? = nil

    open func mostRecentFile() throws -> FileProtocol {

        if let error = mostRecentFileThrowableError {
            throw error
        }


      mostRecentFileCallsCount += 1


      guard let closureReturn = mostRecentFileClosure else {
          guard let returnValue = mostRecentFileReturnValue else {
              let message = """
                🧙‍♂️ 🔥asked to return a value for name parameters:
                    mostRecentFile
                    but this case(s) is(are) not implemented in
                    FolderProtocol for method mostRecentFileClosure.
                """
              let error = SourceryMockError.implementErrorCaseFor(message)
                 throw error
          }
          return returnValue
      }

      return try closureReturn()
    }

    //MARK: - file

    public  var fileNamedThrowableError: Error?
    public var fileNamedCallsCount = 0
    public var fileNamedCalled: Bool {
        return fileNamedCallsCount > 0
    }
    public var fileNamedReceivedFileName: String?
    public var fileNamedReturnValue: FileProtocol?
    public var fileNamedClosure: ((String) throws -> FileProtocol)? = nil

    open func file(named fileName: String) throws -> FileProtocol {

        if let error = fileNamedThrowableError {
            throw error
        }


      fileNamedCallsCount += 1
        fileNamedReceivedFileName = fileName


      guard let closureReturn = fileNamedClosure else {
          guard let returnValue = fileNamedReturnValue else {
              let message = """
                🧙‍♂️ 🔥asked to return a value for name parameters:
                    fileNamed
                    but this case(s) is(are) not implemented in
                    FolderProtocol for method fileNamedClosure.
                """
              let error = SourceryMockError.implementErrorCaseFor(message)
                 throw error
          }
          return returnValue
      }

      return try closureReturn(fileName)
    }

    //MARK: - file

    public  var fileAtPathThrowableError: Error?
    public var fileAtPathCallsCount = 0
    public var fileAtPathCalled: Bool {
        return fileAtPathCallsCount > 0
    }
    public var fileAtPathReceivedFilePath: String?
    public var fileAtPathReturnValue: FileProtocol?
    public var fileAtPathClosure: ((String) throws -> FileProtocol)? = nil

    open func file(atPath filePath: String) throws -> FileProtocol {

        if let error = fileAtPathThrowableError {
            throw error
        }


      fileAtPathCallsCount += 1
        fileAtPathReceivedFilePath = filePath


      guard let closureReturn = fileAtPathClosure else {
          guard let returnValue = fileAtPathReturnValue else {
              let message = """
                🧙‍♂️ 🔥asked to return a value for name parameters:
                    fileAtPath
                    but this case(s) is(are) not implemented in
                    FolderProtocol for method fileAtPathClosure.
                """
              let error = SourceryMockError.implementErrorCaseFor(message)
                 throw error
          }
          return returnValue
      }

      return try closureReturn(filePath)
    }

    //MARK: - containsFile

    public var containsFileNamedCallsCount = 0
    public var containsFileNamedCalled: Bool {
        return containsFileNamedCallsCount > 0
    }
    public var containsFileNamedReceivedFileName: String?
    public var containsFileNamedReturnValue: Bool?
    public var containsFileNamedClosure: ((String) -> Bool)? = nil

    open func containsFile(named fileName: String) -> Bool {

      containsFileNamedCallsCount += 1
        containsFileNamedReceivedFileName = fileName


      guard let closureReturn = containsFileNamedClosure else {
          guard let returnValue = containsFileNamedReturnValue else {
              let message = """
                🧙‍♂️ 🔥asked to return a value for name parameters:
                    containsFileNamed
                    but this case(s) is(are) not implemented in
                    FolderProtocol for method containsFileNamedClosure.
                """
              let error = SourceryMockError.implementErrorCaseFor(message)
              os_log("🧙‍♂️ 🔥 %@", type: .error, "\(error)")
              return false
          }
          return returnValue
      }

      return closureReturn(fileName)
    }

    //MARK: - firstFolder

    public  var firstFolderWithThrowableError: Error?
    public var firstFolderWithCallsCount = 0
    public var firstFolderWithCalled: Bool {
        return firstFolderWithCallsCount > 0
    }
    public var firstFolderWithReceivedPrefix: String?
    public var firstFolderWithReturnValue: FolderProtocol?
    public var firstFolderWithClosure: ((String) throws -> FolderProtocol)? = nil

    open func firstFolder(with prefix: String) throws -> FolderProtocol {

        if let error = firstFolderWithThrowableError {
            throw error
        }


      firstFolderWithCallsCount += 1
        firstFolderWithReceivedPrefix = prefix


      guard let closureReturn = firstFolderWithClosure else {
          guard let returnValue = firstFolderWithReturnValue else {
              let message = """
                🧙‍♂️ 🔥asked to return a value for name parameters:
                    firstFolderWith
                    but this case(s) is(are) not implemented in
                    FolderProtocol for method firstFolderWithClosure.
                """
              let error = SourceryMockError.implementErrorCaseFor(message)
                 throw error
          }
          return returnValue
      }

      return try closureReturn(prefix)
    }

    //MARK: - subfolder

    public  var subfolderNamedThrowableError: Error?
    public var subfolderNamedCallsCount = 0
    public var subfolderNamedCalled: Bool {
        return subfolderNamedCallsCount > 0
    }
    public var subfolderNamedReceivedFolderName: String?
    public var subfolderNamedReturnValue: FolderProtocol?
    public var subfolderNamedClosure: ((String) throws -> FolderProtocol)? = nil

    open func subfolder(named folderName: String) throws -> FolderProtocol {

        if let error = subfolderNamedThrowableError {
            throw error
        }


      subfolderNamedCallsCount += 1
        subfolderNamedReceivedFolderName = folderName


      guard let closureReturn = subfolderNamedClosure else {
          guard let returnValue = subfolderNamedReturnValue else {
              let message = """
                🧙‍♂️ 🔥asked to return a value for name parameters:
                    subfolderNamed
                    but this case(s) is(are) not implemented in
                    FolderProtocol for method subfolderNamedClosure.
                """
              let error = SourceryMockError.implementErrorCaseFor(message)
                 throw error
          }
          return returnValue
      }

      return try closureReturn(folderName)
    }

    //MARK: - subfolder

    public  var subfolderAtPathThrowableError: Error?
    public var subfolderAtPathCallsCount = 0
    public var subfolderAtPathCalled: Bool {
        return subfolderAtPathCallsCount > 0
    }
    public var subfolderAtPathReceivedFolderPath: String?
    public var subfolderAtPathReturnValue: FolderProtocol?
    public var subfolderAtPathClosure: ((String) throws -> FolderProtocol)? = nil

    open func subfolder(atPath folderPath: String) throws -> FolderProtocol {

        if let error = subfolderAtPathThrowableError {
            throw error
        }


      subfolderAtPathCallsCount += 1
        subfolderAtPathReceivedFolderPath = folderPath


      guard let closureReturn = subfolderAtPathClosure else {
          guard let returnValue = subfolderAtPathReturnValue else {
              let message = """
                🧙‍♂️ 🔥asked to return a value for name parameters:
                    subfolderAtPath
                    but this case(s) is(are) not implemented in
                    FolderProtocol for method subfolderAtPathClosure.
                """
              let error = SourceryMockError.implementErrorCaseFor(message)
                 throw error
          }
          return returnValue
      }

      return try closureReturn(folderPath)
    }

    //MARK: - containsSubfolder

    public var containsSubfolderNamedCallsCount = 0
    public var containsSubfolderNamedCalled: Bool {
        return containsSubfolderNamedCallsCount > 0
    }
    public var containsSubfolderNamedReceivedFolderName: String?
    public var containsSubfolderNamedReturnValue: Bool?
    public var containsSubfolderNamedClosure: ((String) -> Bool)? = nil

    open func containsSubfolder(named folderName: String) -> Bool {

      containsSubfolderNamedCallsCount += 1
        containsSubfolderNamedReceivedFolderName = folderName


      guard let closureReturn = containsSubfolderNamedClosure else {
          guard let returnValue = containsSubfolderNamedReturnValue else {
              let message = """
                🧙‍♂️ 🔥asked to return a value for name parameters:
                    containsSubfolderNamed
                    but this case(s) is(are) not implemented in
                    FolderProtocol for method containsSubfolderNamedClosure.
                """
              let error = SourceryMockError.implementErrorCaseFor(message)
              os_log("🧙‍♂️ 🔥 %@", type: .error, "\(error)")
              return false
          }
          return returnValue
      }

      return closureReturn(folderName)
    }

    //MARK: - createFileIfNeeded

    public  var createFileIfNeededNamedThrowableError: Error?
    public var createFileIfNeededNamedCallsCount = 0
    public var createFileIfNeededNamedCalled: Bool {
        return createFileIfNeededNamedCallsCount > 0
    }
    public var createFileIfNeededNamedReceivedFileName: String?
    public var createFileIfNeededNamedReturnValue: FileProtocol?
    public var createFileIfNeededNamedClosure: ((String) throws -> FileProtocol)? = nil

    open func createFileIfNeeded(named fileName: String) throws -> FileProtocol {

        if let error = createFileIfNeededNamedThrowableError {
            throw error
        }


      createFileIfNeededNamedCallsCount += 1
        createFileIfNeededNamedReceivedFileName = fileName


      guard let closureReturn = createFileIfNeededNamedClosure else {
          guard let returnValue = createFileIfNeededNamedReturnValue else {
              let message = """
                🧙‍♂️ 🔥asked to return a value for name parameters:
                    createFileIfNeededNamed
                    but this case(s) is(are) not implemented in
                    FolderProtocol for method createFileIfNeededNamedClosure.
                """
              let error = SourceryMockError.implementErrorCaseFor(message)
                 throw error
          }
          return returnValue
      }

      return try closureReturn(fileName)
    }

    //MARK: - createFile

    public  var createFileNamedThrowableError: Error?
    public var createFileNamedCallsCount = 0
    public var createFileNamedCalled: Bool {
        return createFileNamedCallsCount > 0
    }
    public var createFileNamedReceivedFileName: String?
    public var createFileNamedReturnValue: FileProtocol?
    public var createFileNamedClosure: ((String) throws -> FileProtocol)? = nil

    open func createFile(named fileName: String) throws -> FileProtocol {

        if let error = createFileNamedThrowableError {
            throw error
        }


      createFileNamedCallsCount += 1
        createFileNamedReceivedFileName = fileName


      guard let closureReturn = createFileNamedClosure else {
          guard let returnValue = createFileNamedReturnValue else {
              let message = """
                🧙‍♂️ 🔥asked to return a value for name parameters:
                    createFileNamed
                    but this case(s) is(are) not implemented in
                    FolderProtocol for method createFileNamedClosure.
                """
              let error = SourceryMockError.implementErrorCaseFor(message)
                 throw error
          }
          return returnValue
      }

      return try closureReturn(fileName)
    }

    //MARK: - createFile

    public  var createFileNamedDataContentsThrowableError: Error?
    public var createFileNamedDataContentsCallsCount = 0
    public var createFileNamedDataContentsCalled: Bool {
        return createFileNamedDataContentsCallsCount > 0
    }
    public var createFileNamedDataContentsReceivedArguments: (fileName: String, data: Data)?
    public var createFileNamedDataContentsReturnValue: FileProtocol?
    public var createFileNamedDataContentsClosure: ((String, Data) throws -> FileProtocol)? = nil

    open func createFile(named fileName: String, dataContents data: Data) throws -> FileProtocol {

        if let error = createFileNamedDataContentsThrowableError {
            throw error
        }


      createFileNamedDataContentsCallsCount += 1
        createFileNamedDataContentsReceivedArguments = (fileName: fileName, data: data)


      guard let closureReturn = createFileNamedDataContentsClosure else {
          guard let returnValue = createFileNamedDataContentsReturnValue else {
              let message = """
                🧙‍♂️ 🔥asked to return a value for name parameters:
                    createFileNamedDataContents
                    but this case(s) is(are) not implemented in
                    FolderProtocol for method createFileNamedDataContentsClosure.
                """
              let error = SourceryMockError.implementErrorCaseFor(message)
                 throw error
          }
          return returnValue
      }

      return try closureReturn(fileName, data)
    }

    //MARK: - createFile

    public  var createFileNamedContentsThrowableError: Error?
    public var createFileNamedContentsCallsCount = 0
    public var createFileNamedContentsCalled: Bool {
        return createFileNamedContentsCallsCount > 0
    }
    public var createFileNamedContentsReceivedArguments: (fileName: String, contents: String)?
    public var createFileNamedContentsReturnValue: FileProtocol?
    public var createFileNamedContentsClosure: ((String, String) throws -> FileProtocol)? = nil

    open func createFile(named fileName: String, contents: String) throws -> FileProtocol {

        if let error = createFileNamedContentsThrowableError {
            throw error
        }


      createFileNamedContentsCallsCount += 1
        createFileNamedContentsReceivedArguments = (fileName: fileName, contents: contents)


      guard let closureReturn = createFileNamedContentsClosure else {
          guard let returnValue = createFileNamedContentsReturnValue else {
              let message = """
                🧙‍♂️ 🔥asked to return a value for name parameters:
                    createFileNamedContents
                    but this case(s) is(are) not implemented in
                    FolderProtocol for method createFileNamedContentsClosure.
                """
              let error = SourceryMockError.implementErrorCaseFor(message)
                 throw error
          }
          return returnValue
      }

      return try closureReturn(fileName, contents)
    }

    //MARK: - createSubfolder

    public  var createSubfolderNamedThrowableError: Error?
    public var createSubfolderNamedCallsCount = 0
    public var createSubfolderNamedCalled: Bool {
        return createSubfolderNamedCallsCount > 0
    }
    public var createSubfolderNamedReceivedFolderName: String?
    public var createSubfolderNamedReturnValue: FolderProtocol?
    public var createSubfolderNamedClosure: ((String) throws -> FolderProtocol)? = nil

    open func createSubfolder(named folderName: String) throws -> FolderProtocol {

        if let error = createSubfolderNamedThrowableError {
            throw error
        }


      createSubfolderNamedCallsCount += 1
        createSubfolderNamedReceivedFolderName = folderName


      guard let closureReturn = createSubfolderNamedClosure else {
          guard let returnValue = createSubfolderNamedReturnValue else {
              let message = """
                🧙‍♂️ 🔥asked to return a value for name parameters:
                    createSubfolderNamed
                    but this case(s) is(are) not implemented in
                    FolderProtocol for method createSubfolderNamedClosure.
                """
              let error = SourceryMockError.implementErrorCaseFor(message)
                 throw error
          }
          return returnValue
      }

      return try closureReturn(folderName)
    }

    //MARK: - createSubfolderIfNeeded

    public  var createSubfolderIfNeededWithNameThrowableError: Error?
    public var createSubfolderIfNeededWithNameCallsCount = 0
    public var createSubfolderIfNeededWithNameCalled: Bool {
        return createSubfolderIfNeededWithNameCallsCount > 0
    }
    public var createSubfolderIfNeededWithNameReceivedFolderName: String?
    public var createSubfolderIfNeededWithNameReturnValue: FolderProtocol?
    public var createSubfolderIfNeededWithNameClosure: ((String) throws -> FolderProtocol)? = nil

    open func createSubfolderIfNeeded(withName folderName: String) throws -> FolderProtocol {

        if let error = createSubfolderIfNeededWithNameThrowableError {
            throw error
        }


      createSubfolderIfNeededWithNameCallsCount += 1
        createSubfolderIfNeededWithNameReceivedFolderName = folderName


      guard let closureReturn = createSubfolderIfNeededWithNameClosure else {
          guard let returnValue = createSubfolderIfNeededWithNameReturnValue else {
              let message = """
                🧙‍♂️ 🔥asked to return a value for name parameters:
                    createSubfolderIfNeededWithName
                    but this case(s) is(are) not implemented in
                    FolderProtocol for method createSubfolderIfNeededWithNameClosure.
                """
              let error = SourceryMockError.implementErrorCaseFor(message)
                 throw error
          }
          return returnValue
      }

      return try closureReturn(folderName)
    }

    //MARK: - makeFileSequence

    public var makeFileSequenceRecursiveIncludeHiddenCallsCount = 0
    public var makeFileSequenceRecursiveIncludeHiddenCalled: Bool {
        return makeFileSequenceRecursiveIncludeHiddenCallsCount > 0
    }
    public var makeFileSequenceRecursiveIncludeHiddenReceivedArguments: (recursive: Bool, includeHidden: Bool)?
    public var makeFileSequenceRecursiveIncludeHiddenReturnValue: FileSystemSequence<File>?
    public var makeFileSequenceRecursiveIncludeHiddenClosure: ((Bool, Bool) -> FileSystemSequence<File>)? = nil

    open func makeFileSequence(recursive: Bool, includeHidden: Bool) -> FileSystemSequence<File> {

      makeFileSequenceRecursiveIncludeHiddenCallsCount += 1
        makeFileSequenceRecursiveIncludeHiddenReceivedArguments = (recursive: recursive, includeHidden: includeHidden)


      guard let closureReturn = makeFileSequenceRecursiveIncludeHiddenClosure else {
          guard let returnValue = makeFileSequenceRecursiveIncludeHiddenReturnValue else {
              let message = """
                🧙‍♂️ 🔥asked to return a value for name parameters:
                    makeFileSequenceRecursiveIncludeHidden
                    but this case(s) is(are) not implemented in
                    FolderProtocol for method makeFileSequenceRecursiveIncludeHiddenClosure.
                """
              let error = SourceryMockError.implementErrorCaseFor(message)
              os_log("🧙‍♂️ 🔥 %@", type: .error, "\(error)")
              return makeFileSequenceRecursiveIncludeHiddenReturnValue!
          }
          return returnValue
      }

      return closureReturn(recursive, includeHidden)
    }

    //MARK: - copy

    public  var copyToThrowableError: Error?
    public var copyToCallsCount = 0
    public var copyToCalled: Bool {
        return copyToCallsCount > 0
    }
    public var copyToReceivedFolder: FolderProtocol?
    public var copyToReturnValue: Folder?
    public var copyToClosure: ((FolderProtocol) throws -> Folder)? = nil

    open func copy(to folder: FolderProtocol) throws -> Folder {

        if let error = copyToThrowableError {
            throw error
        }


      copyToCallsCount += 1
        copyToReceivedFolder = folder


      guard let closureReturn = copyToClosure else {
          guard let returnValue = copyToReturnValue else {
              let message = """
                🧙‍♂️ 🔥asked to return a value for name parameters:
                    copyTo
                    but this case(s) is(are) not implemented in
                    FolderProtocol for method copyToClosure.
                """
              let error = SourceryMockError.implementErrorCaseFor(message)
                 throw error
          }
          return returnValue
      }

      return try closureReturn(folder)
    }

    //MARK: - parentFolder

    public  var parentFolderThrowableError: Error?
    public var parentFolderCallsCount = 0
    public var parentFolderCalled: Bool {
        return parentFolderCallsCount > 0
    }
    public var parentFolderReturnValue: FolderProtocol?
    public var parentFolderClosure: (() throws -> FolderProtocol)? = nil

    open func parentFolder() throws -> FolderProtocol {

        if let error = parentFolderThrowableError {
            throw error
        }


      parentFolderCallsCount += 1


      guard let closureReturn = parentFolderClosure else {
          guard let returnValue = parentFolderReturnValue else {
              let message = """
                🧙‍♂️ 🔥asked to return a value for name parameters:
                    parentFolder
                    but this case(s) is(are) not implemented in
                    ItemProtocol for method parentFolderClosure.
                """
              let error = SourceryMockError.implementErrorCaseFor(message)
                 throw error
          }
          return returnValue
      }

      return try closureReturn()
    }

    //MARK: - rename

    public  var renameToThrowableError: Error?
    public var renameToCallsCount = 0
    public var renameToCalled: Bool {
        return renameToCallsCount > 0
    }
    public var renameToReceivedNewName: String?
    public var renameToClosure: ((String) throws -> Void)? = nil

    open func rename(to newName: String) throws {

        if let error = renameToThrowableError {
            throw error
        }


      renameToCallsCount += 1
        renameToReceivedNewName = newName


      try renameToClosure?(newName)

    }

    //MARK: - rename

    public  var renameToKeepExtensionThrowableError: Error?
    public var renameToKeepExtensionCallsCount = 0
    public var renameToKeepExtensionCalled: Bool {
        return renameToKeepExtensionCallsCount > 0
    }
    public var renameToKeepExtensionReceivedArguments: (newName: String, keepExtension: Bool)?
    public var renameToKeepExtensionClosure: ((String, Bool) throws -> Void)? = nil

    open func rename(to newName: String, keepExtension: Bool) throws {

        if let error = renameToKeepExtensionThrowableError {
            throw error
        }


      renameToKeepExtensionCallsCount += 1
        renameToKeepExtensionReceivedArguments = (newName: newName, keepExtension: keepExtension)


      try renameToKeepExtensionClosure?(newName, keepExtension)

    }

    //MARK: - move

    public  var moveToThrowableError: Error?
    public var moveToCallsCount = 0
    public var moveToCalled: Bool {
        return moveToCallsCount > 0
    }
    public var moveToReceivedNewParent: Folder?
    public var moveToClosure: ((Folder) throws -> Void)? = nil

    open func move(to newParent: Folder) throws {

        if let error = moveToThrowableError {
            throw error
        }


      moveToCallsCount += 1
        moveToReceivedNewParent = newParent


      try moveToClosure?(newParent)

    }

    //MARK: - delete

    public  var deleteThrowableError: Error?
    public var deleteCallsCount = 0
    public var deleteCalled: Bool {
        return deleteCallsCount > 0
    }
    public var deleteClosure: (() throws -> Void)? = nil

    open func delete() throws {

        if let error = deleteThrowableError {
            throw error
        }


      deleteCallsCount += 1


      try deleteClosure?()

    }

    //MARK: - init

    public var initClosure: (() -> Void)? = nil

    public required init() {
        initClosure?()
    }
    //MARK: - init

    public  var initPathThrowableError: Error?
    public var initPathReceivedPath: String?
    public var initPathClosure: ((String) throws -> Void)? = nil

    public required init(path: String) throws {
        initPathReceivedPath = path
         try? initPathClosure?(path)
    }
}


// MARK: - GitToolProtocolMock

open class GitToolProtocolMock: GitToolProtocol {

    public init() {}


    //MARK: - addAll

    public  var addAllAtThrowableError: Error?
    public var addAllAtCallsCount = 0
    public var addAllAtCalled: Bool {
        return addAllAtCallsCount > 0
    }
    public var addAllAtReceivedUrl: FolderProtocol?
    public var addAllAtClosure: ((FolderProtocol) throws -> Void)? = nil

    open func addAll(at url: FolderProtocol) throws {

        if let error = addAllAtThrowableError {
            throw error
        }


      addAllAtCallsCount += 1
        addAllAtReceivedUrl = url


      try addAllAtClosure?(url)

    }

    //MARK: - commit

    public  var commitAtMessageThrowableError: Error?
    public var commitAtMessageCallsCount = 0
    public var commitAtMessageCalled: Bool {
        return commitAtMessageCallsCount > 0
    }
    public var commitAtMessageReceivedArguments: (url: FolderProtocol, message: String)?
    public var commitAtMessageClosure: ((FolderProtocol, String) throws -> Void)? = nil

    open func commit(at url: FolderProtocol, message: String) throws {

        if let error = commitAtMessageThrowableError {
            throw error
        }


      commitAtMessageCallsCount += 1
        commitAtMessageReceivedArguments = (url: url, message: message)


      try commitAtMessageClosure?(url, message)

    }

    //MARK: - pushToMaster

    public  var pushToMasterAtThrowableError: Error?
    public var pushToMasterAtCallsCount = 0
    public var pushToMasterAtCalled: Bool {
        return pushToMasterAtCallsCount > 0
    }
    public var pushToMasterAtReceivedUrl: FolderProtocol?
    public var pushToMasterAtClosure: ((FolderProtocol) throws -> Void)? = nil

    open func pushToMaster(at url: FolderProtocol) throws {

        if let error = pushToMasterAtThrowableError {
            throw error
        }


      pushToMasterAtCallsCount += 1
        pushToMasterAtReceivedUrl = url


      try pushToMasterAtClosure?(url)

    }

    //MARK: - pushTagsToMaster

    public  var pushTagsToMasterAtThrowableError: Error?
    public var pushTagsToMasterAtCallsCount = 0
    public var pushTagsToMasterAtCalled: Bool {
        return pushTagsToMasterAtCallsCount > 0
    }
    public var pushTagsToMasterAtReceivedUrl: FolderProtocol?
    public var pushTagsToMasterAtClosure: ((FolderProtocol) throws -> Void)? = nil

    open func pushTagsToMaster(at url: FolderProtocol) throws {

        if let error = pushTagsToMasterAtThrowableError {
            throw error
        }


      pushTagsToMasterAtCallsCount += 1
        pushTagsToMasterAtReceivedUrl = url


      try pushTagsToMasterAtClosure?(url)

    }

    //MARK: - pull

    public  var pullAtThrowableError: Error?
    public var pullAtCallsCount = 0
    public var pullAtCalled: Bool {
        return pullAtCallsCount > 0
    }
    public var pullAtReceivedUrl: FolderProtocol?
    public var pullAtClosure: ((FolderProtocol) throws -> Void)? = nil

    open func pull(at url: FolderProtocol) throws {

        if let error = pullAtThrowableError {
            throw error
        }


      pullAtCallsCount += 1
        pullAtReceivedUrl = url


      try pullAtClosure?(url)

    }

    //MARK: - currentTag

    public  var currentTagAtThrowableError: Error?
    public var currentTagAtCallsCount = 0
    public var currentTagAtCalled: Bool {
        return currentTagAtCallsCount > 0
    }
    public var currentTagAtReceivedUrl: FolderProtocol?
    public var currentTagAtReturnValue: String?
    public var currentTagAtClosure: ((FolderProtocol) throws -> String)? = nil

    open func currentTag(at url: FolderProtocol) throws -> String {

        if let error = currentTagAtThrowableError {
            throw error
        }


      currentTagAtCallsCount += 1
        currentTagAtReceivedUrl = url


      guard let closureReturn = currentTagAtClosure else {
          guard let returnValue = currentTagAtReturnValue else {
              let message = """
                🧙‍♂️ 🔥asked to return a value for name parameters:
                    currentTagAt
                    but this case(s) is(are) not implemented in
                    GitToolProtocol for method currentTagAtClosure.
                """
              let error = SourceryMockError.implementErrorCaseFor(message)
                 throw error
          }
          return returnValue
      }

      return try closureReturn(url)
    }

    //MARK: - clone

    public  var cloneWithThrowableError: Error?
    public var cloneWithCallsCount = 0
    public var cloneWithCalled: Bool {
        return cloneWithCallsCount > 0
    }
    public var cloneWithReceivedOptions: CloneOptions?
    public var cloneWithClosure: ((CloneOptions) throws -> Void)? = nil

    open func clone(with options: CloneOptions) throws {

        if let error = cloneWithThrowableError {
            throw error
        }


      cloneWithCallsCount += 1
        cloneWithReceivedOptions = options


      try cloneWithClosure?(options)

    }

}


// MARK: - HighwayBundleProtocolMock

open class HighwayBundleProtocolMock: HighwayBundleProtocol {

    public init() {}

    public var url: FolderProtocol {
        get { return underlyingUrl }
        set(value) { underlyingUrl = value }
    }
    public var underlyingUrl: FolderProtocol!
    public var fileSystem: FileSystemProtocol {
        get { return underlyingFileSystem }
        set(value) { underlyingFileSystem = value }
    }
    public var underlyingFileSystem: FileSystemProtocol!
    public var configuration: Configuration {
        get { return underlyingConfiguration }
        set(value) { underlyingConfiguration = value }
    }
    public var underlyingConfiguration: Configuration!
    public var xcodeprojectParent: FolderProtocol {
        get { return underlyingXcodeprojectParent }
        set(value) { underlyingXcodeprojectParent = value }
    }
    public var underlyingXcodeprojectParent: FolderProtocol!

    //MARK: - xcodeprojectUrl

    public  var xcodeprojectUrlThrowableError: Error?
    public var xcodeprojectUrlCallsCount = 0
    public var xcodeprojectUrlCalled: Bool {
        return xcodeprojectUrlCallsCount > 0
    }
    public var xcodeprojectUrlReturnValue: FolderProtocol?
    public var xcodeprojectUrlClosure: (() throws -> FolderProtocol)? = nil

    open func xcodeprojectUrl() throws -> FolderProtocol {

        if let error = xcodeprojectUrlThrowableError {
            throw error
        }


      xcodeprojectUrlCallsCount += 1


      guard let closureReturn = xcodeprojectUrlClosure else {
          guard let returnValue = xcodeprojectUrlReturnValue else {
              let message = """
                🧙‍♂️ 🔥asked to return a value for name parameters:
                    xcodeprojectUrl
                    but this case(s) is(are) not implemented in
                    HighwayBundleProtocol for method xcodeprojectUrlClosure.
                """
              let error = SourceryMockError.implementErrorCaseFor(message)
                 throw error
          }
          return returnValue
      }

      return try closureReturn()
    }

    //MARK: - xcconfigFile

    public  var xcconfigFileThrowableError: Error?
    public var xcconfigFileCallsCount = 0
    public var xcconfigFileCalled: Bool {
        return xcconfigFileCallsCount > 0
    }
    public var xcconfigFileReturnValue: FileProtocol?
    public var xcconfigFileClosure: (() throws -> FileProtocol)? = nil

    open func xcconfigFile() throws -> FileProtocol {

        if let error = xcconfigFileThrowableError {
            throw error
        }


      xcconfigFileCallsCount += 1


      guard let closureReturn = xcconfigFileClosure else {
          guard let returnValue = xcconfigFileReturnValue else {
              let message = """
                🧙‍♂️ 🔥asked to return a value for name parameters:
                    xcconfigFile
                    but this case(s) is(are) not implemented in
                    HighwayBundleProtocol for method xcconfigFileClosure.
                """
              let error = SourceryMockError.implementErrorCaseFor(message)
                 throw error
          }
          return returnValue
      }

      return try closureReturn()
    }

    //MARK: - gitignore

    public  var gitignoreThrowableError: Error?
    public var gitignoreCallsCount = 0
    public var gitignoreCalled: Bool {
        return gitignoreCallsCount > 0
    }
    public var gitignoreReturnValue: FileProtocol?
    public var gitignoreClosure: (() throws -> FileProtocol)? = nil

    open func gitignore() throws -> FileProtocol {

        if let error = gitignoreThrowableError {
            throw error
        }


      gitignoreCallsCount += 1


      guard let closureReturn = gitignoreClosure else {
          guard let returnValue = gitignoreReturnValue else {
              let message = """
                🧙‍♂️ 🔥asked to return a value for name parameters:
                    gitignore
                    but this case(s) is(are) not implemented in
                    HighwayBundleProtocol for method gitignoreClosure.
                """
              let error = SourceryMockError.implementErrorCaseFor(message)
                 throw error
          }
          return returnValue
      }

      return try closureReturn()
    }

    //MARK: - mainSwiftFile

    public  var mainSwiftFileThrowableError: Error?
    public var mainSwiftFileCallsCount = 0
    public var mainSwiftFileCalled: Bool {
        return mainSwiftFileCallsCount > 0
    }
    public var mainSwiftFileReturnValue: FileProtocol?
    public var mainSwiftFileClosure: (() throws -> FileProtocol)? = nil

    open func mainSwiftFile() throws -> FileProtocol {

        if let error = mainSwiftFileThrowableError {
            throw error
        }


      mainSwiftFileCallsCount += 1


      guard let closureReturn = mainSwiftFileClosure else {
          guard let returnValue = mainSwiftFileReturnValue else {
              let message = """
                🧙‍♂️ 🔥asked to return a value for name parameters:
                    mainSwiftFile
                    but this case(s) is(are) not implemented in
                    HighwayBundleProtocol for method mainSwiftFileClosure.
                """
              let error = SourceryMockError.implementErrorCaseFor(message)
                 throw error
          }
          return returnValue
      }

      return try closureReturn()
    }

    //MARK: - package

    public  var packageThrowableError: Error?
    public var packageCallsCount = 0
    public var packageCalled: Bool {
        return packageCallsCount > 0
    }
    public var packageReturnValue: FileProtocol?
    public var packageClosure: (() throws -> FileProtocol)? = nil

    open func package() throws -> FileProtocol {

        if let error = packageThrowableError {
            throw error
        }


      packageCallsCount += 1


      guard let closureReturn = packageClosure else {
          guard let returnValue = packageReturnValue else {
              let message = """
                🧙‍♂️ 🔥asked to return a value for name parameters:
                    package
                    but this case(s) is(are) not implemented in
                    HighwayBundleProtocol for method packageClosure.
                """
              let error = SourceryMockError.implementErrorCaseFor(message)
                 throw error
          }
          return returnValue
      }

      return try closureReturn()
    }

    //MARK: - pinsFileUrl

    public  var pinsFileUrlThrowableError: Error?
    public var pinsFileUrlCallsCount = 0
    public var pinsFileUrlCalled: Bool {
        return pinsFileUrlCallsCount > 0
    }
    public var pinsFileUrlReturnValue: FileProtocol?
    public var pinsFileUrlClosure: (() throws -> FileProtocol)? = nil

    open func pinsFileUrl() throws -> FileProtocol {

        if let error = pinsFileUrlThrowableError {
            throw error
        }


      pinsFileUrlCallsCount += 1


      guard let closureReturn = pinsFileUrlClosure else {
          guard let returnValue = pinsFileUrlReturnValue else {
              let message = """
                🧙‍♂️ 🔥asked to return a value for name parameters:
                    pinsFileUrl
                    but this case(s) is(are) not implemented in
                    HighwayBundleProtocol for method pinsFileUrlClosure.
                """
              let error = SourceryMockError.implementErrorCaseFor(message)
                 throw error
          }
          return returnValue
      }

      return try closureReturn()
    }

    //MARK: - buildDirectory

    public  var buildDirectoryThrowableError: Error?
    public var buildDirectoryCallsCount = 0
    public var buildDirectoryCalled: Bool {
        return buildDirectoryCallsCount > 0
    }
    public var buildDirectoryReturnValue: FolderProtocol?
    public var buildDirectoryClosure: (() throws -> FolderProtocol)? = nil

    open func buildDirectory() throws -> FolderProtocol {

        if let error = buildDirectoryThrowableError {
            throw error
        }


      buildDirectoryCallsCount += 1


      guard let closureReturn = buildDirectoryClosure else {
          guard let returnValue = buildDirectoryReturnValue else {
              let message = """
                🧙‍♂️ 🔥asked to return a value for name parameters:
                    buildDirectory
                    but this case(s) is(are) not implemented in
                    HighwayBundleProtocol for method buildDirectoryClosure.
                """
              let error = SourceryMockError.implementErrorCaseFor(message)
                 throw error
          }
          return returnValue
      }

      return try closureReturn()
    }

    //MARK: - clean

    public  var cleanThrowableError: Error?
    public var cleanCallsCount = 0
    public var cleanCalled: Bool {
        return cleanCallsCount > 0
    }
    public var cleanReturnValue: Bool?
    public var cleanClosure: (() throws -> Bool)? = nil

    open func clean() throws -> Bool {

        if let error = cleanThrowableError {
            throw error
        }


      cleanCallsCount += 1


      guard let closureReturn = cleanClosure else {
          guard let returnValue = cleanReturnValue else {
              let message = """
                🧙‍♂️ 🔥asked to return a value for name parameters:
                    clean
                    but this case(s) is(are) not implemented in
                    HighwayBundleProtocol for method cleanClosure.
                """
              let error = SourceryMockError.implementErrorCaseFor(message)
                 throw error
          }
          return returnValue
      }

      return try closureReturn()
    }

    //MARK: - executableUrl

    public  var executableUrlSwiftBinUrlThrowableError: Error?
    public var executableUrlSwiftBinUrlCallsCount = 0
    public var executableUrlSwiftBinUrlCalled: Bool {
        return executableUrlSwiftBinUrlCallsCount > 0
    }
    public var executableUrlSwiftBinUrlReceivedSwiftBinUrl: FolderProtocol?
    public var executableUrlSwiftBinUrlReturnValue: FileProtocol?
    public var executableUrlSwiftBinUrlClosure: ((FolderProtocol) throws -> FileProtocol)? = nil

    open func executableUrl(swiftBinUrl: FolderProtocol) throws -> FileProtocol {

        if let error = executableUrlSwiftBinUrlThrowableError {
            throw error
        }


      executableUrlSwiftBinUrlCallsCount += 1
        executableUrlSwiftBinUrlReceivedSwiftBinUrl = swiftBinUrl


      guard let closureReturn = executableUrlSwiftBinUrlClosure else {
          guard let returnValue = executableUrlSwiftBinUrlReturnValue else {
              let message = """
                🧙‍♂️ 🔥asked to return a value for name parameters:
                    executableUrlSwiftBinUrl
                    but this case(s) is(are) not implemented in
                    HighwayBundleProtocol for method executableUrlSwiftBinUrlClosure.
                """
              let error = SourceryMockError.implementErrorCaseFor(message)
                 throw error
          }
          return returnValue
      }

      return try closureReturn(swiftBinUrl)
    }

}


// MARK: - ItemProtocolMock

open class ItemProtocolMock: ItemProtocol {


    public var path: String {
        get { return underlyingPath }
        set(value) { underlyingPath = value }
    }
    public var underlyingPath: String = "AutoMockable filled value"
    public var name: String {
        get { return underlyingName }
        set(value) { underlyingName = value }
    }
    public var underlyingName: String = "AutoMockable filled value"
    public var nameExcludingExtension: String {
        get { return underlyingNameExcludingExtension }
        set(value) { underlyingNameExcludingExtension = value }
    }
    public var underlyingNameExcludingExtension: String = "AutoMockable filled value"
    public var `extension`: String?
    public var modificationDate: Date {
        get { return underlyingModificationDate }
        set(value) { underlyingModificationDate = value }
    }
    public var underlyingModificationDate: Date = Date()
    public var description: String {
        get { return underlyingDescription }
        set(value) { underlyingDescription = value }
    }
    public var underlyingDescription: String = "AutoMockable filled value"

    //MARK: - parentFolder

    public  var parentFolderThrowableError: Error?
    public var parentFolderCallsCount = 0
    public var parentFolderCalled: Bool {
        return parentFolderCallsCount > 0
    }
    public var parentFolderReturnValue: FolderProtocol?
    public var parentFolderClosure: (() throws -> FolderProtocol)? = nil

    open func parentFolder() throws -> FolderProtocol {

        if let error = parentFolderThrowableError {
            throw error
        }


      parentFolderCallsCount += 1


      guard let closureReturn = parentFolderClosure else {
          guard let returnValue = parentFolderReturnValue else {
              let message = """
                🧙‍♂️ 🔥asked to return a value for name parameters:
                    parentFolder
                    but this case(s) is(are) not implemented in
                    ItemProtocol for method parentFolderClosure.
                """
              let error = SourceryMockError.implementErrorCaseFor(message)
                 throw error
          }
          return returnValue
      }

      return try closureReturn()
    }

    //MARK: - rename

    public  var renameToThrowableError: Error?
    public var renameToCallsCount = 0
    public var renameToCalled: Bool {
        return renameToCallsCount > 0
    }
    public var renameToReceivedNewName: String?
    public var renameToClosure: ((String) throws -> Void)? = nil

    open func rename(to newName: String) throws {

        if let error = renameToThrowableError {
            throw error
        }


      renameToCallsCount += 1
        renameToReceivedNewName = newName


      try renameToClosure?(newName)

    }

    //MARK: - rename

    public  var renameToKeepExtensionThrowableError: Error?
    public var renameToKeepExtensionCallsCount = 0
    public var renameToKeepExtensionCalled: Bool {
        return renameToKeepExtensionCallsCount > 0
    }
    public var renameToKeepExtensionReceivedArguments: (newName: String, keepExtension: Bool)?
    public var renameToKeepExtensionClosure: ((String, Bool) throws -> Void)? = nil

    open func rename(to newName: String, keepExtension: Bool) throws {

        if let error = renameToKeepExtensionThrowableError {
            throw error
        }


      renameToKeepExtensionCallsCount += 1
        renameToKeepExtensionReceivedArguments = (newName: newName, keepExtension: keepExtension)


      try renameToKeepExtensionClosure?(newName, keepExtension)

    }

    //MARK: - move

    public  var moveToThrowableError: Error?
    public var moveToCallsCount = 0
    public var moveToCalled: Bool {
        return moveToCallsCount > 0
    }
    public var moveToReceivedNewParent: Folder?
    public var moveToClosure: ((Folder) throws -> Void)? = nil

    open func move(to newParent: Folder) throws {

        if let error = moveToThrowableError {
            throw error
        }


      moveToCallsCount += 1
        moveToReceivedNewParent = newParent


      try moveToClosure?(newParent)

    }

    //MARK: - delete

    public  var deleteThrowableError: Error?
    public var deleteCallsCount = 0
    public var deleteCalled: Bool {
        return deleteCallsCount > 0
    }
    public var deleteClosure: (() throws -> Void)? = nil

    open func delete() throws {

        if let error = deleteThrowableError {
            throw error
        }


      deleteCallsCount += 1


      try deleteClosure?()

    }

}


// MARK: - KeychainProtocolMock

open class KeychainProtocolMock: KeychainProtocol {

    public init() {}

    public var system: SystemProtocol {
        get { return underlyingSystem }
        set(value) { underlyingSystem = value }
    }
    public var underlyingSystem: SystemProtocol!

    //MARK: - password

    public  var passwordMatchingThrowableError: Error?
    public var passwordMatchingCallsCount = 0
    public var passwordMatchingCalled: Bool {
        return passwordMatchingCallsCount > 0
    }
    public var passwordMatchingReceivedQuery: Keychain.PasswordQuery?
    public var passwordMatchingReturnValue: String?
    public var passwordMatchingClosure: ((Keychain.PasswordQuery) throws -> String)? = nil

    open func password(matching query: Keychain.PasswordQuery) throws -> String {

        if let error = passwordMatchingThrowableError {
            throw error
        }


      passwordMatchingCallsCount += 1
        passwordMatchingReceivedQuery = query


      guard let closureReturn = passwordMatchingClosure else {
          guard let returnValue = passwordMatchingReturnValue else {
              let message = """
                🧙‍♂️ 🔥asked to return a value for name parameters:
                    passwordMatching
                    but this case(s) is(are) not implemented in
                    KeychainProtocol for method passwordMatchingClosure.
                """
              let error = SourceryMockError.implementErrorCaseFor(message)
                 throw error
          }
          return returnValue
      }

      return try closureReturn(query)
    }

}


// MARK: - SystemProtocolMock

open class SystemProtocolMock: SystemProtocol {

    public init() {}


    //MARK: - task

    public  var taskNamedThrowableError: Error?
    public var taskNamedCallsCount = 0
    public var taskNamedCalled: Bool {
        return taskNamedCallsCount > 0
    }
    public var taskNamedReceivedName: String?
    public var taskNamedReturnValue: Task?
    public var taskNamedClosure: ((String) throws -> Task)? = nil

    open func task(named name: String) throws -> Task {

        if let error = taskNamedThrowableError {
            throw error
        }


      taskNamedCallsCount += 1
        taskNamedReceivedName = name


      guard let closureReturn = taskNamedClosure else {
          guard let returnValue = taskNamedReturnValue else {
              let message = """
                🧙‍♂️ 🔥asked to return a value for name parameters:
                    taskNamed
                    but this case(s) is(are) not implemented in
                    SystemProtocol for method taskNamedClosure.
                """
              let error = SourceryMockError.implementErrorCaseFor(message)
                 throw error
          }
          return returnValue
      }

      return try closureReturn(name)
    }

    //MARK: - execute

    public  var executeThrowableError: Error?
    public var executeCallsCount = 0
    public var executeCalled: Bool {
        return executeCallsCount > 0
    }
    public var executeReceivedTask: Task?
    public var executeReturnValue: Bool?
    public var executeClosure: ((Task) throws -> Bool)? = nil

    open func execute(_ task: Task) throws -> Bool {

        if let error = executeThrowableError {
            throw error
        }


      executeCallsCount += 1
        executeReceivedTask = task


      guard let closureReturn = executeClosure else {
          guard let returnValue = executeReturnValue else {
              let message = """
                🧙‍♂️ 🔥asked to return a value for name parameters:
                    execute
                    but this case(s) is(are) not implemented in
                    SystemProtocol for method executeClosure.
                """
              let error = SourceryMockError.implementErrorCaseFor(message)
                 throw error
          }
          return returnValue
      }

      return try closureReturn(task)
    }

    //MARK: - launch

    public  var launchWaitThrowableError: Error?
    public var launchWaitCallsCount = 0
    public var launchWaitCalled: Bool {
        return launchWaitCallsCount > 0
    }
    public var launchWaitReceivedArguments: (task: Task, wait: Bool)?
    public var launchWaitReturnValue: Bool?
    public var launchWaitClosure: ((Task, Bool) throws -> Bool)? = nil

    open func launch(_ task: Task, wait: Bool) throws -> Bool {

        if let error = launchWaitThrowableError {
            throw error
        }


      launchWaitCallsCount += 1
        launchWaitReceivedArguments = (task: task, wait: wait)


      guard let closureReturn = launchWaitClosure else {
          guard let returnValue = launchWaitReturnValue else {
              let message = """
                🧙‍♂️ 🔥asked to return a value for name parameters:
                    launchWait
                    but this case(s) is(are) not implemented in
                    SystemProtocol for method launchWaitClosure.
                """
              let error = SourceryMockError.implementErrorCaseFor(message)
                 throw error
          }
          return returnValue
      }

      return try closureReturn(task, wait)
    }

}


// MARK: - TaskExecutorProtocolMock

open class TaskExecutorProtocolMock: TaskExecutorProtocol {

    public init() {}

    public var ui: UIProtocol {
        get { return underlyingUi }
        set(value) { underlyingUi = value }
    }
    public var underlyingUi: UIProtocol!

    //MARK: - execute

    public  var executeTaskThrowableError: Error?
    public var executeTaskCallsCount = 0
    public var executeTaskCalled: Bool {
        return executeTaskCallsCount > 0
    }
    public var executeTaskReceivedTask: Task?
    public var executeTaskClosure: ((Task) throws -> Void)? = nil

    open func execute(task: Task) throws {

        if let error = executeTaskThrowableError {
            throw error
        }


      executeTaskCallsCount += 1
        executeTaskReceivedTask = task


      try executeTaskClosure?(task)

    }

    //MARK: - launch

    public  var launchTaskWaitThrowableError: Error?
    public var launchTaskWaitCallsCount = 0
    public var launchTaskWaitCalled: Bool {
        return launchTaskWaitCallsCount > 0
    }
    public var launchTaskWaitReceivedArguments: (task: Task, wait: Bool)?
    public var launchTaskWaitClosure: ((Task, Bool) throws -> Void)? = nil

    open func launch(task: Task, wait: Bool) throws {

        if let error = launchTaskWaitThrowableError {
            throw error
        }


      launchTaskWaitCallsCount += 1
        launchTaskWaitReceivedArguments = (task: task, wait: wait)


      try launchTaskWaitClosure?(task, wait)

    }

}


// MARK: - TaskProtocolMock

open class TaskProtocolMock: TaskProtocol {

    public init() {}

    public var name: String {
        get { return underlyingName }
        set(value) { underlyingName = value }
    }
    public var underlyingName: String = "AutoMockable filled value"
    public var executable: FileProtocol {
        get { return underlyingExecutable }
        set(value) { underlyingExecutable = value }
    }
    public var underlyingExecutable: FileProtocol!
    public var arguments: Arguments {
        get { return underlyingArguments }
        set(value) { underlyingArguments = value }
    }
    public var underlyingArguments: Arguments!
    public var environment: [String : String] = [:]
    public var currentDirectoryUrl: FolderProtocol?
    public var input: Channel {
        get { return underlyingInput }
        set(value) { underlyingInput = value }
    }
    public var underlyingInput: Channel!
    public var output: Channel {
        get { return underlyingOutput }
        set(value) { underlyingOutput = value }
    }
    public var underlyingOutput: Channel!
    public var state: State {
        get { return underlyingState }
        set(value) { underlyingState = value }
    }
    public var underlyingState: State!
    public var capturedOutputData: Data?
    public var readOutputString: String?
    public var trimmedOutput: String?
    public var capturedOutputString: String?
    public var successfullyFinished: Bool {
        get { return underlyingSuccessfullyFinished }
        set(value) { underlyingSuccessfullyFinished = value }
    }
    public var underlyingSuccessfullyFinished: Bool = false
    public var description: String {
        get { return underlyingDescription }
        set(value) { underlyingDescription = value }
    }
    public var underlyingDescription: String = "AutoMockable filled value"

    //MARK: - enableReadableOutputDataCapturing

    public var enableReadableOutputDataCapturingCallsCount = 0
    public var enableReadableOutputDataCapturingCalled: Bool {
        return enableReadableOutputDataCapturingCallsCount > 0
    }
    public var enableReadableOutputDataCapturingClosure: (() -> Void)? = nil

    open func enableReadableOutputDataCapturing() {

      enableReadableOutputDataCapturingCallsCount += 1


      enableReadableOutputDataCapturingClosure?()

    }

    //MARK: - throwIfNotSuccess

    public  var throwIfNotSuccessThrowableError: Error?
    public var throwIfNotSuccessCallsCount = 0
    public var throwIfNotSuccessCalled: Bool {
        return throwIfNotSuccessCallsCount > 0
    }
    public var throwIfNotSuccessReceivedError: Swift.Error?
    public var throwIfNotSuccessClosure: ((Swift.Error) throws -> Void)? = nil

    open func throwIfNotSuccess(_ error: Swift.Error) throws {

        if let error = throwIfNotSuccessThrowableError {
            throw error
        }


      throwIfNotSuccessCallsCount += 1
        throwIfNotSuccessReceivedError = error


      try throwIfNotSuccessClosure?(error)

    }

}


// MARK: - TestOptionsProtocolMock

open class TestOptionsProtocolMock: TestOptionsProtocol {

    public init() {}

    public var scheme: String {
        get { return underlyingScheme }
        set(value) { underlyingScheme = value }
    }
    public var underlyingScheme: String = "AutoMockable filled value"
    public var project: String {
        get { return underlyingProject }
        set(value) { underlyingProject = value }
    }
    public var underlyingProject: String = "AutoMockable filled value"
    public var destination: DestinationProtocol {
        get { return underlyingDestination }
        set(value) { underlyingDestination = value }
    }
    public var underlyingDestination: DestinationProtocol!
    public var resultBundlePath: String {
        get { return underlyingResultBundlePath }
        set(value) { underlyingResultBundlePath = value }
    }
    public var underlyingResultBundlePath: String = "AutoMockable filled value"

}


// MARK: - UIProtocolMock

open class UIProtocolMock: UIProtocol {

    public init() {}


    //MARK: - message

    public var messageCallsCount = 0
    public var messageCalled: Bool {
        return messageCallsCount > 0
    }
    public var messageReceivedText: String?
    public var messageClosure: ((String) -> Void)? = nil

    open func message(_ text: String) {

      messageCallsCount += 1
        messageReceivedText = text


      messageClosure?(text)

    }

    //MARK: - success

    public var successCallsCount = 0
    public var successCalled: Bool {
        return successCallsCount > 0
    }
    public var successReceivedText: String?
    public var successClosure: ((String) -> Void)? = nil

    open func success(_ text: String) {

      successCallsCount += 1
        successReceivedText = text


      successClosure?(text)

    }

    //MARK: - verbose

    public var verboseCallsCount = 0
    public var verboseCalled: Bool {
        return verboseCallsCount > 0
    }
    public var verboseReceivedText: String?
    public var verboseClosure: ((String) -> Void)? = nil

    open func verbose(_ text: String) {

      verboseCallsCount += 1
        verboseReceivedText = text


      verboseClosure?(text)

    }

    //MARK: - error

    public var errorCallsCount = 0
    public var errorCalled: Bool {
        return errorCallsCount > 0
    }
    public var errorReceivedText: String?
    public var errorClosure: ((String) -> Void)? = nil

    open func error(_ text: String) {

      errorCallsCount += 1
        errorReceivedText = text


      errorClosure?(text)

    }

    //MARK: - print

    public var printCallsCount = 0
    public var printCalled: Bool {
        return printCallsCount > 0
    }
    public var printReceivedPrintable: Printable?
    public var printClosure: ((Printable) -> Void)? = nil

    open func print(_ printable: Printable) {

      printCallsCount += 1
        printReceivedPrintable = printable


      printClosure?(printable)

    }

    //MARK: - verbosePrint

    public var verbosePrintCallsCount = 0
    public var verbosePrintCalled: Bool {
        return verbosePrintCallsCount > 0
    }
    public var verbosePrintReceivedPrintable: Printable?
    public var verbosePrintClosure: ((Printable) -> Void)? = nil

    open func verbosePrint(_ printable: Printable) {

      verbosePrintCallsCount += 1
        verbosePrintReceivedPrintable = printable


      verbosePrintClosure?(printable)

    }

}


// MARK: - XCBuildProtocolMock

open class XCBuildProtocolMock: XCBuildProtocol {

    public init() {}

    public var system: SystemProtocol {
        get { return underlyingSystem }
        set(value) { underlyingSystem = value }
    }
    public var underlyingSystem: SystemProtocol!
    public var fileSystem: FileSystemProtocol {
        get { return underlyingFileSystem }
        set(value) { underlyingFileSystem = value }
    }
    public var underlyingFileSystem: FileSystemProtocol!

    //MARK: - archive

    public  var archiveUsingThrowableError: Error?
    public var archiveUsingCallsCount = 0
    public var archiveUsingCalled: Bool {
        return archiveUsingCallsCount > 0
    }
    public var archiveUsingReceivedOptions: ArchiveOptionsProtocol?
    public var archiveUsingReturnValue: ArchiveProtocol?
    public var archiveUsingClosure: ((ArchiveOptionsProtocol) throws -> ArchiveProtocol)? = nil

    open func archive(using options: ArchiveOptionsProtocol) throws -> ArchiveProtocol {

        if let error = archiveUsingThrowableError {
            throw error
        }


      archiveUsingCallsCount += 1
        archiveUsingReceivedOptions = options


      guard let closureReturn = archiveUsingClosure else {
          guard let returnValue = archiveUsingReturnValue else {
              let message = """
                🧙‍♂️ 🔥asked to return a value for name parameters:
                    archiveUsing
                    but this case(s) is(are) not implemented in
                    XCBuildProtocol for method archiveUsingClosure.
                """
              let error = SourceryMockError.implementErrorCaseFor(message)
                 throw error
          }
          return returnValue
      }

      return try closureReturn(options)
    }

    //MARK: - export

    public  var exportUsingThrowableError: Error?
    public var exportUsingCallsCount = 0
    public var exportUsingCalled: Bool {
        return exportUsingCallsCount > 0
    }
    public var exportUsingReceivedOptions: ExportArchiveOptionsProtocol?
    public var exportUsingReturnValue: ExportProtocol?
    public var exportUsingClosure: ((ExportArchiveOptionsProtocol) throws -> ExportProtocol)? = nil

    open func export(using options: ExportArchiveOptionsProtocol) throws -> ExportProtocol {

        if let error = exportUsingThrowableError {
            throw error
        }


      exportUsingCallsCount += 1
        exportUsingReceivedOptions = options


      guard let closureReturn = exportUsingClosure else {
          guard let returnValue = exportUsingReturnValue else {
              let message = """
                🧙‍♂️ 🔥asked to return a value for name parameters:
                    exportUsing
                    but this case(s) is(are) not implemented in
                    XCBuildProtocol for method exportUsingClosure.
                """
              let error = SourceryMockError.implementErrorCaseFor(message)
                 throw error
          }
          return returnValue
      }

      return try closureReturn(options)
    }

    //MARK: - buildAndTest

    public  var buildAndTestUsingThrowableError: Error?
    public var buildAndTestUsingCallsCount = 0
    public var buildAndTestUsingCalled: Bool {
        return buildAndTestUsingCallsCount > 0
    }
    public var buildAndTestUsingReceivedOptions: TestOptionsProtocol?
    public var buildAndTestUsingReturnValue: TestReport?
    public var buildAndTestUsingClosure: ((TestOptionsProtocol) throws -> TestReport)? = nil

    open func buildAndTest(using options: TestOptionsProtocol) throws -> TestReport {

        if let error = buildAndTestUsingThrowableError {
            throw error
        }


      buildAndTestUsingCallsCount += 1
        buildAndTestUsingReceivedOptions = options


      guard let closureReturn = buildAndTestUsingClosure else {
          guard let returnValue = buildAndTestUsingReturnValue else {
              let message = """
                🧙‍♂️ 🔥asked to return a value for name parameters:
                    buildAndTestUsing
                    but this case(s) is(are) not implemented in
                    XCBuildProtocol for method buildAndTestUsingClosure.
                """
              let error = SourceryMockError.implementErrorCaseFor(message)
                 throw error
          }
          return returnValue
      }

      return try closureReturn(options)
    }

}

