//
//  FileSystem.swift
//  GitHooks
//
//  Created by Stijn on 10/07/2018.
//

import Foundation

#if ZFile
import SourceryAutoProtocols
#endif

// MARK: - FileSystemProtocol

// sourcery:AutoMockable
// sourcery:skipPublicInit
public protocol FileSystemProtocol {
    
    /// sourcery:inline:FileSystem.AutoGenerateSelectiveProtocol
    var temporaryFolder: Folder {  get }
    var homeFolder: Folder {  get }
    var currentFolder: Folder {  get }

    init()
    init(using fileManager: FileManager)
    func createFile(at path: String) throws -> FileProtocol
    func createFile(at path: String, dataContents: Data) throws -> FileProtocol
    func createFileIfNeeded(at path: String) throws -> FileProtocol
    func createFileIfNeeded(at path: String, contents: Data) throws -> FileProtocol
    func createFolder(at path: String) throws -> FolderProtocol
    func createFolderIfNeeded(at path: String) throws -> FolderProtocol
    func itemKind(at path: String)-> FileSystem.Item.Kind?
    
    /// sourcery:end
    
}

// MARK: - FileSystemIterable

/// Protocol adopted by file system types that may be iterated over (this protocol is an implementation detail)
public protocol FileSystemIterable {
    /// Initialize an instance with a path that is the date and a file manager that is the default. Creates if needed.
    init()
    /// Initialize an instance with a path and a file manager
    init(path: String) throws
}

// MARK: - ItemProtocol

// sourcery:AutoMockable
// sourcery:skipPublicInit
public protocol ItemProtocol {
    
    /// sourcery:inline:FileSystem.Item.AutoGenerateSelectiveProtocol
    var path: String {   get }
    var name: String {   get }
    var nameExcludingExtension: String {   get }
    var `extension`: String? {  get }
    var modificationDate: Date {   get }
    var description: String {   get }

    func parentFolder() throws -> FolderProtocol
    func rename(to newName: String) throws 
    func rename(to newName: String, keepExtension: Bool) throws 
    func move(to newParent: Folder) throws 
    func delete() throws 
    
    /// sourcery:end
}

/**
 *  Class that represents a file system
 *
 *  You only have to interact with this class in case you want to get a reference
 *  to a system folder (like the temporary cache folder, or the user's home folder).
 *
 *  To open other files & folders, use the `File` and `Folder` class respectively.
 */
public class FileSystem: FileSystemProtocol, AutoGenerateSelectiveProtocol {
    let fileManager: FileManager
    
    /**
     *  Class that represents an item that's stored by a file system
     *
     *  This is an abstract base class, that has two publically initializable concrete
     *  implementations, `File` and `Folder`. You can use the APIs available on this class
     *  to perform operations that are supported by both files & folders.
     */
    open class Item: Equatable, CustomStringConvertible, ItemProtocol, AutoGenerateSelectiveProtocol {
        /// Errror type used for invalid paths for files or folders
        public enum PathError: Error, Equatable, CustomStringConvertible {
            /// Thrown when an empty path was given when initializing a file
            case empty
            /// Thrown when an item of the expected type wasn't found for a given path (contains the path)
            case invalid(String)
            case nonMatchingKind(expectedKind: Kind, gotKind: Kind, path: String)
            
            /// Operator used to compare two instances for equality
            public static func == (lhs: PathError, rhs: PathError) -> Bool {
                switch (lhs, rhs) {
                case (.empty, .empty):
                    return true
                case let (.invalid(pathA), .invalid(pathB)):
                    return pathA == pathB
                case (.nonMatchingKind, .nonMatchingKind):
                    return true
                default:
                    return false
                }
            }
            
            /// A string describing the error
            public var description: String {
                switch self {
                case .empty:
                    return "Empty path given"
                case let .invalid(path):
                    return "Invalid path given: \(path)"
                case let .nonMatchingKind(expectedKind: expected, gotKind: actual, path: path):
                    return "Expected path to lead \(expected) but got \(actual) @\(path)"
                }
            }
        }
        
        /// Error type used for failed operations run on files or folders
        public enum OperationError: Error, Equatable, CustomStringConvertible {
            /// Thrown when a file or folder couldn't be renamed (contains the item)
            case renameFailed(Item)
            /// Thrown when a file or folder couldn't be moved (contains the item)
            case moveFailed(Item)
            /// Thrown when a file or folder couldn't be copied (contains the item)
            case copyFailed(Item)
            /// Thrown when a file or folder couldn't be deleted (contains the item)
            case deleteFailed(Item)
            
            /// Operator used to compare two instances for equality
            public static func == (lhs: OperationError, rhs: OperationError) -> Bool {
                switch lhs {
                case let .renameFailed(itemA):
                    switch rhs {
                    case let .renameFailed(itemB):
                        return itemA == itemB
                    case .moveFailed:
                        return false
                    case .copyFailed:
                        return false
                    case .deleteFailed:
                        return false
                    }
                case let .moveFailed(itemA):
                    switch rhs {
                    case .renameFailed:
                        return false
                    case let .moveFailed(itemB):
                        return itemA == itemB
                    case .copyFailed:
                        return false
                    case .deleteFailed:
                        return false
                    }
                case let .copyFailed(itemA):
                    switch rhs {
                    case .renameFailed:
                        return false
                    case .moveFailed:
                        return false
                    case let .copyFailed(itemB):
                        return itemA == itemB
                    case .deleteFailed:
                        return false
                    }
                case let .deleteFailed(itemA):
                    switch rhs {
                    case .renameFailed:
                        return false
                    case .moveFailed:
                        return false
                    case .copyFailed:
                        return false
                    case let .deleteFailed(itemB):
                        return itemA == itemB
                    }
                }
            }
            
            /// A string describing the error
            public var description: String {
                switch self {
                case let .renameFailed(item):
                    return "Failed to rename item: \(item)"
                case let .moveFailed(item):
                    return "Failed to move item: \(item)"
                case let .copyFailed(item):
                    return "Failed to copy item: \(item)"
                case let .deleteFailed(item):
                    return "Failed to delete item: \(item)"
                }
            }
        }
        
        /// Operator used to compare two instances for equality
        public static func == (lhs: Item, rhs: Item) -> Bool {
            guard lhs.kind == rhs.kind else {
                return false
            }
            
            return lhs.path == rhs.path
        }
        
        /// The path of the item, relative to the root of the file system
        // sourcery:selectedForProtocol
        // sourcery:onlyGet
        public private(set) var path: String
        
        /// The name of the item (including any extension)
        // sourcery:selectedForProtocol
        // sourcery:onlyGet
        public private(set) var name: String
        
        /// The name of the item (excluding any extension)
        // sourcery:selectedForProtocol
        // sourcery:onlyGet
        public var nameExcludingExtension: String {
            guard let `extension` = `extension` else {
                return name
            }
            
            let endIndex = name.index(name.endIndex, offsetBy: -`extension`.count - 1)
            return String(name[..<endIndex])
        }
        
        /// Any extension that the item has
        // sourcery:selectedForProtocol
        public var `extension`: String? {
            let components = name.components(separatedBy: ".")
            
            guard components.count > 1 else {
                return nil
            }
            
            return components.last
        }
        
        /// The date when the item was last modified
        // sourcery:selectedForProtocol
        // sourcery:onlyGet
        public private(set) lazy var modificationDate: Date = self.loadModificationDate()
        
        /// The folder that the item is contained in, or `nil` if this item is the root folder of the file system
        // sourcery:skipProtocol
        public var parent: Folder? {
            return fileManager.parentPath(for: path).flatMap { parentPath in
                try? Folder(path: parentPath, fileManager: fileManager)
            }
        }
        
        // sourcery:selectedForProtocol
        public func parentFolder() throws -> FolderProtocol {
            guard let parent = self.parent else {
                throw Folder.Error.creatingFolderFailed
            }
            
            return parent
        }
        
        /// A string describing the item
        // sourcery:selectedForProtocol
        // sourcery:onlyGet
        public var description: String {
            return "\(kind)(name: \(name), path: \(path))"
        }
        
        let kind: Kind
        let fileManager: FileManager
        
        init(path: String, kind: Kind, using fileManager: FileManager) throws {
            guard !path.isEmpty else {
                throw PathError.empty
            }
            
            let path = try fileManager.absolutePath(for: path)
            
            guard fileManager.itemKind(atPath: path) == kind else {
                throw PathError.invalid(path)
            }
            
            self.path = path
            self.fileManager = fileManager
            self.kind = kind
            
            let pathComponents = path.pathComponents
            
            switch kind {
            case .file:
                name = pathComponents.last!
            case .folder:
                name = pathComponents[pathComponents.count - 2]
            }
        }
        
        /**
         *  Rename the item
         *
         *  - parameter newName: The new name that the item should have
         *  - parameter keepExtension: Whether the file should keep the same extension as it had before (defaults to `true`)
         *
         *  - throws: `FileSystem.Item.OperationError.renameFailed` if the item couldn't be renamed
         */
        // sourcery:selectedForProtocol
        public func rename(to newName: String) throws {
            try rename(to: newName, keepExtension: true)
        }
        
        // sourcery:selectedForProtocol
        public func rename(to newName: String, keepExtension: Bool) throws {
            guard let parent = parent else {
                throw OperationError.renameFailed(self)
            }
            
            var newName = newName
            
            if keepExtension {
                if let `extension` = `extension` {
                    let extensionString = ".\(`extension`)"
                    
                    if !newName.hasSuffix(extensionString) {
                        newName += extensionString
                    }
                }
            }
            
            var newPath = parent.path + newName
            
            if kind == .folder && !newPath.hasSuffix("/") {
                newPath += "/"
            }
            
            do {
                try fileManager.moveItem(atPath: path, toPath: newPath)
                
                name = newName
                path = newPath
            } catch {
                throw OperationError.renameFailed(self)
            }
        }
        
        /**
         *  Move this item to a new folder
         *
         *  - parameter newParent: The new parent folder that the item should be moved to
         *
         *  - throws: `FileSystem.Item.OperationError.moveFailed` if the item couldn't be moved
         */
        // sourcery:selectedForProtocol
        public func move(to newParent: Folder) throws {
            var newPath = newParent.path + name
            
            if kind == .folder && !newPath.hasSuffix("/") {
                newPath += "/"
            }
            
            do {
                try fileManager.moveItem(atPath: path, toPath: newPath)
                path = newPath
            } catch {
                throw OperationError.moveFailed(self)
            }
        }
        
        /**
         *  Delete the item from disk
         *
         *  The item will be immediately deleted. If this is a folder, all of its contents will also be deleted.
         *
         *  - throws: `FileSystem.Item.OperationError.deleteFailed` if the item coudn't be deleted
         */
        // sourcery:selectedForProtocol
        public func delete() throws {
            do {
                try fileManager.removeItem(atPath: path)
            } catch {
                throw OperationError.deleteFailed(self)
            }
        }
    }
    
    /// A reference to the temporary folder used by this file system
    // sourcery:selectedForProtocol
    public var temporaryFolder: Folder {
        return try! Folder(path: NSTemporaryDirectory(), fileManager: fileManager)
    }
    
    /// A reference to the current user's home folder
    // sourcery:selectedForProtocol
    public var homeFolder: Folder {
        return try! Folder(path: ProcessInfo.processInfo.homeFolderPath, fileManager: fileManager)
    }
    
    // A reference to the folder that is the current working directory
    // sourcery:selectedForProtocol
    public var currentFolder: Folder {
        return try! Folder(path: "")
    }
    
    /**
     *  Initialize an instance of this class
     *
     *  - parameter fileManager: Optionally give a custom file manager to use to perform operations
     */
    // sourcery:selectedForProtocol
    public required init() {
        self.fileManager = .default
    }
    
    // sourcery:selectedForProtocol
    public required init(using fileManager: FileManager) {
        self.fileManager = fileManager
    }
    
    /**
     *  Create a new file at a given path
     *
     *  - parameter path: The path at which a file should be created. If the path is missing intermediate
     *                    parent folders, those will be created as well.
     *
     *  - throws: `File.Error.writeFailed`
     *
     *  - returns: The file that was created
     */
    // sourcery:selectedForProtocol
    @discardableResult public func createFile(at path: String) throws -> FileProtocol {
        return try createFile(at: path, dataContents: Data())
    }
    
    // sourcery:selectedForProtocol
    @discardableResult public func createFile(at path: String, dataContents: Data) throws -> FileProtocol {
        let path = try fileManager.absolutePath(for: path)
        
        guard let parentPath = fileManager.parentPath(for: path) else {
            throw File.Error.writeFailed
        }
        
        do {
            let index = path.index(path.startIndex, offsetBy: parentPath.count + 1)
            let name = String(path[index...])
            return try createFolder(at: parentPath).createFile(named: name, dataContents: dataContents)
        } catch {
            throw File.Error.writeFailed
        }
    }
    
    /**
     *  Either return an existing file, or create a new one, at a given path.
     *
     *  - parameter path: The path for which a file should either be returned or created at. If the folder
     *                    is missing, any intermediate parent folders will also be created.
     *
     *  - throws: `File.Error.writeFailed`
     *
     *  - returns: The file that was either created or found.
     */
    // sourcery:selectedForProtocol
    @discardableResult public func createFileIfNeeded(at path: String) throws -> FileProtocol  {
        return try createFileIfNeeded(at: path, contents: Data())
    }
    // sourcery:selectedForProtocol
    @discardableResult public func createFileIfNeeded(at path: String, contents: Data) throws -> FileProtocol {
        if let existingFile = try? File(path: path, fileManager: fileManager) {
            return existingFile
        }
        
        return try createFile(at: path, dataContents: contents)
    }
    
    /**
     *  Create a new folder at a given path
     *
     *  - parameter path: The path at which a folder should be created. If the path is missing intermediate
     *                    parent folders, those will be created as well.
     *
     *  - throws: `Folder.Error.creatingFolderFailed`
     *
     *  - returns: The folder that was created
     */
    // sourcery:selectedForProtocol
    @discardableResult public func createFolder(at path: String) throws -> FolderProtocol {
        do {
            let path = try fileManager.absolutePath(for: path)
            try fileManager.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
            return try Folder(path: path, fileManager: fileManager)
        } catch {
            throw Folder.Error.creatingFolderFailed
        }
    }
    
    /**
     *  Either return an existing folder, or create a new one, at a given path
     *
     *  - parameter path: The path for which a folder should either be returned or created at. If the folder
     *                    is missing, any intermediate parent folders will also be created.
     *
     *  - throws: `Folder.Error.creatingFolderFailed`
     */
    // sourcery:selectedForProtocol
    @discardableResult public func createFolderIfNeeded(at path: String) throws -> FolderProtocol {
        if let existingFolder = try? Folder(path: path, fileManager: fileManager) {
            return existingFolder
        }
        
        return try createFolder(at: path)
    }
    
    // sourcery:selectedForProtocol
    public func itemKind(at path: String) -> FileSystem.Item.Kind? {
        return fileManager.itemKind(atPath: path)
    }
}


// MARK: - Extensions



// MARK: - FileManager

extension FileManager {
    func itemKind(atPath path: String) -> FileSystem.Item.Kind? {
        var objCBool: ObjCBool = false
        
        guard fileExists(atPath: path, isDirectory: &objCBool) else {
            return nil
        }
        
        if objCBool.boolValue {
            return .folder
        }
        
        return .file
    }
    
    func itemNames(inFolderAtPath path: String) -> [String] {
        do {
            return try contentsOfDirectory(atPath: path).sorted()
        } catch {
            return []
        }
    }
    
    func absolutePath(for path: String) throws -> String {
        if path.hasPrefix("/") {
            return try pathByFillingInParentReferences(for: path)
        }
        
        if path.hasPrefix("~") {
            let prefixEndIndex = path.index(after: path.startIndex)
            
            let path = path.replacingCharacters(
                in: path.startIndex ..< prefixEndIndex,
                with: ProcessInfo.processInfo.homeFolderPath
            )
            
            return try pathByFillingInParentReferences(for: path)
        }
        
        return try pathByFillingInParentReferences(for: path, prependCurrentFolderPath: true)
    }
    
    func parentPath(for path: String) -> String? {
        guard path != "/" else {
            return nil
        }
        
        var pathComponents = path.pathComponents
        
        if path.hasSuffix("/") {
            pathComponents.removeLast(2)
        } else {
            pathComponents.removeLast()
        }
        
        return pathComponents.joined(separator: "/")
    }
    
    func pathByFillingInParentReferences(for path: String, prependCurrentFolderPath: Bool = false) throws -> String {
        var path = path
        var filledIn = false
        
        while let parentReferenceRange = path.range(of: "../") {
            let currentFolderPath = String(path[..<parentReferenceRange.lowerBound])
            
            guard let currentFolder = try? Folder(path: currentFolderPath) else {
                throw FileSystem.Item.PathError.invalid(path)
            }
            
            guard let parent = currentFolder.parent else {
                throw FileSystem.Item.PathError.invalid(path)
            }
            
            path = path.replacingCharacters(in: path.startIndex ..< parentReferenceRange.upperBound, with: parent.path)
            filledIn = true
        }
        
        if prependCurrentFolderPath {
            guard filledIn else {
                return currentDirectoryPath + "/" + path
            }
        }
        
        return path
    }
}


// MARK: - Item

public extension FileSystem.Item {
    public enum Kind: CustomStringConvertible {
        case file
        case folder
        
        public var description: String {
            switch self {
            case .file:
                return "File"
            case .folder:
                return "Folder"
            }
        }
    }
    
    func loadModificationDate() -> Date {
        let attributes = try! fileManager.attributesOfItem(atPath: path)
        return attributes[FileAttributeKey.modificationDate] as! Date
    }
}

// MARK: - For Linux

#if !os(Linux)
extension FileSystem {
    /// A reference to the document folder used by this file system.
    public var documentFolder: Folder? {
        guard let url = try? fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) else {
            return nil
        }
        
        return try? Folder(path: url.path, fileManager: fileManager)
    }
    
    /// A reference to the library folder used by this file system.
    public var libraryFolder: Folder? {
        guard let url = try? fileManager.url(for: .libraryDirectory, in: .userDomainMask, appropriateFor: nil, create: false) else {
            return nil
        }
        
        return try? Folder(path: url.path, fileManager: fileManager)
    }
}
#endif

