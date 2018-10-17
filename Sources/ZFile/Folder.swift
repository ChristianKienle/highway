//
//  Folder.swift
//  GitHooks
//
//  Created by Stijn on 10/07/2018.
//

import Foundation
import os
/**
 *  Class representing a folder that's stored by a file system
 *
 *  You initialize this class with a path, or by asking a folder to return a subfolder for a given name
 */
// sourcery:AutoMockable
// sourcery:skipPublicInit
public protocol FolderProtocol: ItemProtocol, FileSystemIterable {
    
    /// sourcery:inline:Folder.AutoGenerateSelectiveProtocol

    func mostRecentSubfolder() throws -> FolderProtocol
    func mostRecentFile() throws -> FileProtocol
    func file(named fileName: String) throws -> FileProtocol
    func file(atPath filePath: String) throws -> FileProtocol
    func containsFile(named fileName: String)-> Bool
    func firstFolder(with prefix: String) throws -> FolderProtocol
    func subfolder(named folderName: String) throws -> FolderProtocol
    func subfolder(atPath folderPath: String) throws -> FolderProtocol
    func containsSubfolder(named folderName: String)-> Bool
    func createFileIfNeeded(named fileName: String) throws -> FileProtocol
    func createFile(named fileName: String) throws -> FileProtocol
    func createFile(named fileName: String, dataContents data: Data) throws -> FileProtocol
    func createFile(named fileName: String, contents: String) throws -> FileProtocol
    func createSubfolder(named folderName: String) throws -> FolderProtocol
    func createSubfolderIfNeeded(withName folderName: String) throws -> FolderProtocol
    func makeFileSequence(recursive: Bool, includeHidden: Bool)-> FileSystemSequence<File>
    func copy(to folder: FolderProtocol) throws -> Folder
    /// sourcery:end
}

open class Folder: FileSystem.Item, FolderProtocol, CustomDebugStringConvertible {
    
    // sourcery:skipProtocol
    public var debugDescription: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .full
        formatter.dateStyle = .medium
        
        
        return """
        Folder with:
        
        • path: \(path)
        • modified: \(formatter.string(from: modificationDate))
        
        """
    }
    
    /// Error type specific to folder-related operations
    public enum Error: Swift.Error, CustomStringConvertible {
        /// Thrown when a folder couldn't be created
        case creatingFolderFailed
        case noParent
        case nofolderWithPrefix(String)
        case noSubfolders(inFolder: FolderProtocol)
        
        @available(*, deprecated: 1.4.0, renamed: "creatingFolderFailed")
        case creatingSubfolderFailed
        
        /// A string describing the error
        public var description: String {
            switch self {
            case .creatingFolderFailed:
                return "Failed to create folder"
            case .creatingSubfolderFailed:
                return "Failed to create subfolder"
            case .noParent:
                return "no parent"
            case let .nofolderWithPrefix(prefix):
                return "no folder with prefix \(prefix)"
            case let .noSubfolders(inFolder: folder):
                return "no subfolders in \(folder)"
            }
        }
    }
    
    
    /// The sequence of files that are contained within this folder (non-recursive)
    public var files: FileSystemSequence<File> {
        return makeFileSequence()
    }
    
    /// The sequence of folders that are subfolers of this folder (non-recursive)
    public var subfolders: FileSystemSequence<Folder> {
        return makeSubfolderSequence()
    }
    
    /// A reference to the folder that is the current working directory
    public static var current: Folder {
        return FileSystem(using: .default).currentFolder
    }
    
    /// A reference to the current user's home folder
    public static var home: Folder {
        return FileSystem(using: .default).homeFolder
    }
    
    /// A reference to the temporary folder used by this file system
    public static var temporary: Folder {
        return FileSystem(using: .default).temporaryFolder
    }
    
    public required init() {
        try! super.init(path: "\(Date().timeIntervalSince1970)", kind: .folder, using: .default)
    }
    
    
    /**
     *  Initialize an instance of this class with a path pointing to a folder
     *
     *  - parameter path: The path of the folder to create a representation of
     *  - parameter fileManager: Optionally give a custom file manager to use to look up the folder
     *
     *  - throws: `FileSystemItem.Error` in case an empty path was given, or if the path given doesn't
     *    point to a readable folder.
     */
    public required init(path: String) throws {
        var path = path
        
        if path.isEmpty {
            path = FileManager.default.currentDirectoryPath
        }
        
        if !path.hasSuffix("/") {
            path += "/"
        }
        
        try super.init(path: path, kind: .folder, using: .default)
    }
    
    public init(path: String, fileManager: FileManager) throws {
        var path = path
        
        if path.isEmpty {
            path = fileManager.currentDirectoryPath
        }
        
        if !path.hasSuffix("/") {
            path += "/"
        }
        
        try super.init(path: path, kind: .folder, using: fileManager)
    }
    
    /**
     Most recent folder
     */
    // sourcery:selectedForProtocol
    public func mostRecentSubfolder() throws -> FolderProtocol {
        guard let result = (makeSubfolderSequence().sorted { $0.modificationDate > $1.modificationDate }.first) else {
            throw Folder.Error.noSubfolders(inFolder: self)
        }
        return result
    }
    
    /**
     Most recent folder
     */
    // sourcery:selectedForProtocol
    public func mostRecentFile() throws -> FileProtocol {
        guard let result = (makeFileSequence().sorted { $0.modificationDate > $1.modificationDate }.first) else {
            throw Folder.Error.noSubfolders(inFolder: self)
        }
        return result
    }
    
    /**
     *  Return a file with a given name that is contained in this folder
     *
     *  - parameter fileName: The name of the file to return
     *
     *  - throws: `File.PathError.invalid` if the file couldn't be found
     */
    // sourcery:selectedForProtocol
    public func file(named fileName: String) throws -> FileProtocol {
        return try File(path: path + fileName, fileManager: fileManager)
    }
    
    /**
     *  Return a file at a given path that is contained in this folder's tree
     *
     *  - parameter filePath: The subpath of the file to return. Relative to this folder.
     *
     *  - throws: `File.PathError.invalid` if the file couldn't be found
     */
    // sourcery:selectedForProtocol
    public func file(atPath filePath: String) throws -> FileProtocol {
        return try File(path: path + filePath, fileManager: fileManager)
    }
    
    /**
     *  Return whether this folder contains a file with a given name
     *
     *  - parameter fileName: The name of the file to check for
     */
    // sourcery:selectedForProtocol
    public func containsFile(named fileName: String) -> Bool {
        return (try? file(named: fileName)) != nil
    }
    
    // sourcery:selectedForProtocol
    public func firstFolder(with prefix: String) throws -> FolderProtocol {
        guard let folder = (subfolders.filter { $0.name.hasPrefix(prefix) }.first) else {
            throw Error.creatingFolderFailed
        }
        
        return folder
    }
    
    /**
     *  Return a folder with a given name that is contained in this folder
     *
     *  - parameter folderName: The name of the folder to return
     *
     *  - throws: `Folder.PathError.invalid` if the folder couldn't be found
     */
    // sourcery:selectedForProtocol
    public func subfolder(named folderName: String) throws -> FolderProtocol {
        return try Folder(path: path + folderName, fileManager: fileManager)
    }
    
    /**
     *  Return a folder at a given path that is contained in this folder's tree
     *
     *  - parameter folderPath: The subpath of the folder to return. Relative to this folder.
     *
     *  - throws: `Folder.PathError.invalid` if the folder couldn't be found
     */
    // sourcery:selectedForProtocol
    public func subfolder(atPath folderPath: String) throws -> FolderProtocol {
        return try Folder(path: path + folderPath, fileManager: fileManager)
    }
    
    /**
     *  Return whether this folder contains a subfolder with a given name
     *
     *  - parameter folderName: The name of the folder to check for
     */
    // sourcery:selectedForProtocol
    public func containsSubfolder(named folderName: String) -> Bool {
        return (try? subfolder(named: folderName)) != nil
    }
    
    /**
     *  Create a file in this folder and return it
     *
     *  - parameter fileName: The name of the file to create
     *  - parameter data: Optionally give any data that the file should contain
     *
     *  - throws: `File.Error.writeFailed` if the file couldn't be created
     *
     *  - returns: The file that was created
     */
    // sourcery:selectedForProtocol
    @discardableResult public func createFileIfNeeded(named fileName: String) throws -> FileProtocol {
        return try FileSystem(using: .default).createFileIfNeeded(at: "\(self.path)/\(fileName)", contents: Data())
    }
    
    /**
     *  Create a file in this folder and return it
     *
     *  - parameter fileName: The name of the file to create
     *  - parameter data: Optionally give any data that the file should contain
     *
     *  - throws: `File.Error.writeFailed` if the file couldn't be created
     *
     *  - returns: The file that was created
     */
    // sourcery:selectedForProtocol
    @discardableResult public func createFile(named fileName: String) throws -> FileProtocol {
        return try createFile(named: fileName, dataContents: Data())
    }
    
    // sourcery:selectedForProtocol
    @discardableResult public func createFile(named fileName: String, dataContents data: Data) throws -> FileProtocol {
        let filePath = path + fileName
        
        guard fileManager.createFile(atPath: filePath, contents: data, attributes: nil) else {
            throw File.Error.writeFailed
        }
        
        return try File(path: filePath, fileManager: fileManager)
    }
    
    /**
     *  Create a file in this folder and return it
     *
     *  - parameter fileName: The name of the file to create
     *  - parameter contents: The string content that the file should contain
     *  - parameter encoding: The encoding that the given string content should be encoded with
     *
     *  - throws: `File.Error.writeFailed` if the file couldn't be created
     *
     *  - returns: The file that was created
     */
    // sourcery:selectedForProtocol
    @discardableResult public func createFile(named fileName: String, contents: String) throws -> FileProtocol {
        return try createFile(named: fileName, contents: contents, encoding: .utf8)
    }
    
    @discardableResult public func createFile(named fileName: String, contents: String, encoding: String.Encoding) throws -> FileProtocol {
        let file = try createFile(named: fileName)
        try file.write(string: contents, encoding: encoding)
        return file
    }
    
    /**
     *  Either return an existing file, or create a new one, for a given name
     *
     *  - parameter fileName: The name of the file to either get or create
     *  - parameter dataExpression: An expression resulting in any data that a new file should contain.
     *                              Will only be evaluated & used in case a new file is created.
     *
     *  - throws: `File.Error.writeFailed` if the file couldn't be created
     */
    
    @discardableResult public func createFileIfNeeded(withName fileName: String, contents dataExpression: @autoclosure () -> Data = .init()) throws -> FileProtocol {
        if let existingFile = try? file(named: fileName) {
            return existingFile
        }
        
        return try createFile(named: fileName, dataContents: dataExpression())
    }
    
    /**
     *  Create a subfolder of this folder and return it
     *
     *  - parameter folderName: The name of the folder to create
     *
     *  - throws: `Folder.Error.creatingFolderFailed` if the subfolder couldn't be created
     *
     *  - returns: The folder that was created
     */
    // sourcery:selectedForProtocol
    @discardableResult public func createSubfolder(named folderName: String) throws -> FolderProtocol {
        let subfolderPath = path + folderName
        
        do {
            try fileManager.createDirectory(atPath: subfolderPath, withIntermediateDirectories: false, attributes: nil)
            return try Folder(path: subfolderPath, fileManager: fileManager)
        } catch {
            throw Error.creatingFolderFailed
        }
    }
    
    /**
     *  Either return an existing subfolder, or create a new one, for a given name
     *
     *  - parameter folderName: The name of the folder to either get or create
     *
     *  - throws: `Folder.Error.creatingFolderFailed`
     */
    // sourcery:selectedForProtocol
    @discardableResult public func createSubfolderIfNeeded(withName folderName: String) throws -> FolderProtocol {
        if let existingFolder = try? subfolder(named: folderName) {
            return existingFolder
        }
        
        return try createSubfolder(named: folderName)
    }
    
    /**
     *  Create a sequence containing the files that are contained within this folder
     *
     *  - parameter recursive: Whether the files contained in all subfolders of this folder should also be included
     *  - parameter includeHidden: Whether hidden (dot) files should be included in the sequence (default: false)
     *
     *  If `recursive = true` the folder tree will be traversed depth-first
     */
    
    public func makeFileSequence() -> FileSystemSequence<File>  {
        return makeFileSequence(recursive: false, includeHidden: false)
    }
    
    // sourcery:selectedForProtocol
    public func makeFileSequence(recursive: Bool, includeHidden: Bool) -> FileSystemSequence<File> {
        return FileSystemSequence(folder: self, recursive: recursive, includeHidden: includeHidden, using: fileManager)
    }
    
    /**
     *  Create a sequence containing the folders that are subfolders of this folder
     *
     *  - parameter recursive: Whether the entire folder tree contained under this folder should also be included
     *  - parameter includeHidden: Whether hidden (dot) files should be included in the sequence (default: false)
     *
     *  If `recursive = true` the folder tree will be traversed depth-first
     */
    
    public func makeSubfolderSequence(recursive: Bool = false, includeHidden: Bool = false) -> FileSystemSequence<Folder> {
        return FileSystemSequence(folder: self, recursive: recursive, includeHidden: includeHidden, using: fileManager)
    }
    
    /**
     *  Move the contents (both files and subfolders) of this folder to a new parent folder
     *
     *  - parameter newParent: The new parent folder that the contents of this folder should be moved to
     *  - parameter includeHidden: Whether hidden (dot) files should be moved (default: false)
     */
    
    public func moveContents(to newParent: Folder, includeHidden: Bool = false) throws {
        try makeFileSequence(recursive: false, includeHidden: includeHidden).forEach { try $0.move(to: newParent) }
        try makeSubfolderSequence(includeHidden: includeHidden).forEach { try $0.move(to: newParent) }
    }
    
    /**
     *  Empty this folder, removing all of its content
     *
     *  - parameter includeHidden: Whether hidden files (dot) files contained within the folder should also be removed
     *
     *  This will still keep the folder itself on disk. If you wish to delete the folder as well, call `delete()` on it.
     */
    
    public func empty(includeHidden: Bool = false) throws {
        try makeFileSequence(recursive: false, includeHidden: includeHidden).forEach { try $0.delete() }
        try makeSubfolderSequence(includeHidden: includeHidden).forEach { try $0.delete() }
    }
    
    /**
     *  Copy this folder to a new folder
     *
     *  - parameter folder: The folder that the folder should be copy to
     *
     *  - throws: `FileSystem.Item.OperationError.copyFailed` if the folder couldn't be copied
     */
    // sourcery:selectedForProtocol
    @discardableResult public func copy(to folder: FolderProtocol) throws -> Folder {
        let newPath = folder.path + name
        
        do {
            try fileManager.copyItem(atPath: path, toPath: newPath)
            return try Folder(path: newPath)
        } catch {
            throw OperationError.copyFailed(self, error: "\(error)")
        }
    }
}

