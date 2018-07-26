// Generated using Sourcery 0.13.1 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

// swiftlint:disable line_length
// swiftlint:disable variable_name

import Foundation
import os

#if os(iOS) || os(tvOS) || os(watchOS)
import UIKit
#elseif os(OSX)
import AppKit
#endif

import XCBuild















// MARK: - FileProtocolMock

public class FileProtocolMock: FileProtocol {

    public init() {}

    public var localizedDate: String {
        get { return underlyingLocalizedDate }
        set(value) { underlyingLocalizedDate = value }
    }
    var underlyingLocalizedDate: String = "AutoMockable filled value"
    public var path: String {
        get { return underlyingPath }
        set(value) { underlyingPath = value }
    }
    var underlyingPath: String = "AutoMockable filled value"
    public var name: String {
        get { return underlyingName }
        set(value) { underlyingName = value }
    }
    var underlyingName: String = "AutoMockable filled value"
    public var nameExcludingExtension: String {
        get { return underlyingNameExcludingExtension }
        set(value) { underlyingNameExcludingExtension = value }
    }
    var underlyingNameExcludingExtension: String = "AutoMockable filled value"
    public var `extension`: String?
    public var modificationDate: Date {
        get { return underlyingModificationDate }
        set(value) { underlyingModificationDate = value }
    }
    var underlyingModificationDate: Date = Date()
    public var description: String {
        get { return underlyingDescription }
        set(value) { underlyingDescription = value }
    }
    var underlyingDescription: String = "AutoMockable filled value"

    //MARK: - readAllLines

    public  var readAllLinesThrowableError: Error?
    public var readAllLinesCallsCount = 0
    public var readAllLinesCalled: Bool {
        return readAllLinesCallsCount > 0
    }
    public var readAllLinesReturnValue: [String]?
    public var readAllLinesClosure: (() throws -> [String])? = nil

    public func readAllLines() throws -> [String] {

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

    public func read() throws -> Data {

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

    public func readAsString() throws -> String {

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

    public func write(data: Data) throws {

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

    public func write(string: String, encoding: String.Encoding) throws {

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

    public func copy(to folder: Folder) throws -> FileProtocol {

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

    public func parentFolder() throws -> FolderProtocol {

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

    public func rename(to newName: String) throws {

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

    public func rename(to newName: String, keepExtension: Bool) throws {

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

    public func move(to newParent: Folder) throws {

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

    public func delete() throws {

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

public class FileSystemProtocolMock: FileSystemProtocol {

    public init() {}

    public var temporaryFolder: Folder {
        get { return underlyingTemporaryFolder }
        set(value) { underlyingTemporaryFolder = value }
    }
    var underlyingTemporaryFolder: Folder!
    public var homeFolder: Folder {
        get { return underlyingHomeFolder }
        set(value) { underlyingHomeFolder = value }
    }
    var underlyingHomeFolder: Folder!
    public var currentFolder: Folder {
        get { return underlyingCurrentFolder }
        set(value) { underlyingCurrentFolder = value }
    }
    var underlyingCurrentFolder: Folder!

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

    public func createFile(at path: String) throws -> FileProtocol {

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

    public func createFile(at path: String, dataContents: Data) throws -> FileProtocol {

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

    public func createFileIfNeeded(at path: String) throws -> FileProtocol {

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

    public func createFileIfNeeded(at path: String, contents: Data) throws -> FileProtocol {

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

    public func createFolder(at path: String) throws -> FolderProtocol {

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

    public func createFolderIfNeeded(at path: String) throws -> FolderProtocol {

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

}


// MARK: - FolderProtocolMock

public class FolderProtocolMock: FolderProtocol {

    public init() {}

    public var path: String {
        get { return underlyingPath }
        set(value) { underlyingPath = value }
    }
    var underlyingPath: String = "AutoMockable filled value"
    public var name: String {
        get { return underlyingName }
        set(value) { underlyingName = value }
    }
    var underlyingName: String = "AutoMockable filled value"
    public var nameExcludingExtension: String {
        get { return underlyingNameExcludingExtension }
        set(value) { underlyingNameExcludingExtension = value }
    }
    var underlyingNameExcludingExtension: String = "AutoMockable filled value"
    public var `extension`: String?
    public var modificationDate: Date {
        get { return underlyingModificationDate }
        set(value) { underlyingModificationDate = value }
    }
    var underlyingModificationDate: Date = Date()
    public var description: String {
        get { return underlyingDescription }
        set(value) { underlyingDescription = value }
    }
    var underlyingDescription: String = "AutoMockable filled value"

    //MARK: - mostRecentSubfolder

    public  var mostRecentSubfolderThrowableError: Error?
    public var mostRecentSubfolderCallsCount = 0
    public var mostRecentSubfolderCalled: Bool {
        return mostRecentSubfolderCallsCount > 0
    }
    public var mostRecentSubfolderReturnValue: FolderProtocol?
    public var mostRecentSubfolderClosure: (() throws -> FolderProtocol)? = nil

    public func mostRecentSubfolder() throws -> FolderProtocol {

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

    public func mostRecentFile() throws -> FileProtocol {

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

    public func file(named fileName: String) throws -> FileProtocol {

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

    public func file(atPath filePath: String) throws -> FileProtocol {

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

    public func containsFile(named fileName: String) -> Bool {

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

    public func firstFolder(with prefix: String) throws -> FolderProtocol {

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

    public func subfolder(named folderName: String) throws -> FolderProtocol {

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

    public func subfolder(atPath folderPath: String) throws -> FolderProtocol {

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

    public func containsSubfolder(named folderName: String) -> Bool {

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

    public func createFileIfNeeded(named fileName: String) throws -> FileProtocol {

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

    public func createFile(named fileName: String) throws -> FileProtocol {

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

    public func createFile(named fileName: String, dataContents data: Data) throws -> FileProtocol {

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

    public func createFile(named fileName: String, contents: String) throws -> FileProtocol {

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

    public func createSubfolder(named folderName: String) throws -> FolderProtocol {

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

    public func createSubfolderIfNeeded(withName folderName: String) throws -> FolderProtocol {

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

    public func makeFileSequence(recursive: Bool, includeHidden: Bool) -> FileSystemSequence<File> {

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

    public func copy(to folder: FolderProtocol) throws -> Folder {

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

    public func parentFolder() throws -> FolderProtocol {

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

    public func rename(to newName: String) throws {

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

    public func rename(to newName: String, keepExtension: Bool) throws {

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

    public func move(to newParent: Folder) throws {

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

    public func delete() throws {

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


// MARK: - ItemProtocolMock

public class ItemProtocolMock: ItemProtocol {

    public init() {}

    public var path: String {
        get { return underlyingPath }
        set(value) { underlyingPath = value }
    }
    var underlyingPath: String = "AutoMockable filled value"
    public var name: String {
        get { return underlyingName }
        set(value) { underlyingName = value }
    }
    var underlyingName: String = "AutoMockable filled value"
    public var nameExcludingExtension: String {
        get { return underlyingNameExcludingExtension }
        set(value) { underlyingNameExcludingExtension = value }
    }
    var underlyingNameExcludingExtension: String = "AutoMockable filled value"
    public var `extension`: String?
    public var modificationDate: Date {
        get { return underlyingModificationDate }
        set(value) { underlyingModificationDate = value }
    }
    var underlyingModificationDate: Date = Date()
    public var description: String {
        get { return underlyingDescription }
        set(value) { underlyingDescription = value }
    }
    var underlyingDescription: String = "AutoMockable filled value"

    //MARK: - parentFolder

    public  var parentFolderThrowableError: Error?
    public var parentFolderCallsCount = 0
    public var parentFolderCalled: Bool {
        return parentFolderCallsCount > 0
    }
    public var parentFolderReturnValue: FolderProtocol?
    public var parentFolderClosure: (() throws -> FolderProtocol)? = nil

    public func parentFolder() throws -> FolderProtocol {

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

    public func rename(to newName: String) throws {

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

    public func rename(to newName: String, keepExtension: Bool) throws {

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

    public func move(to newParent: Folder) throws {

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

    public func delete() throws {

        if let error = deleteThrowableError {
            throw error
        }


      deleteCallsCount += 1


      try deleteClosure?()

    }

}


// MARK: - TestOptionsProtocolMock

public class TestOptionsProtocolMock: TestOptionsProtocol {

    public init() {}

    public var scheme: String {
        get { return underlyingScheme }
        set(value) { underlyingScheme = value }
    }
    var underlyingScheme: String = "AutoMockable filled value"
    public var project: String {
        get { return underlyingProject }
        set(value) { underlyingProject = value }
    }
    var underlyingProject: String = "AutoMockable filled value"
    public var destination: Destination {
        get { return underlyingDestination }
        set(value) { underlyingDestination = value }
    }
    var underlyingDestination: Destination!

}

