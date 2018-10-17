//
//  File.swift
//  GitHooks
//
//  Created by Stijn on 10/07/2018.
//

import Foundation

/**
 *  Class representing a file that's stored by a file system
 *
 *  You initialize this class with a path, or by asking a folder to return a file for a given name
 */
// sourcery:AutoMockable
// sourcery:skipPublicInit
public protocol FileProtocol: ItemProtocol, FileSystemIterable {
    
    /// sourcery:inline:File.AutoGenerateSelectiveProtocol
    var localizedDate: String {  get }

    func readAllLines() throws -> [String]
    func read() throws -> Data
    func readAsString() throws -> String
    func write(data: Data) throws 
    func write(string: String, encoding: String.Encoding) throws 
    func copy(to folder: Folder) throws -> FileProtocol
    
    /// sourcery:end
}

open class File: FileSystem.Item, FileProtocol {
    
    // sourcery:selectedForProtocol
    public func readAllLines() throws -> [String] {
        return try readAsString().components(separatedBy: "\n")
    }
    
    // sourcery:selectedForProtocol
    public var localizedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .full
        return formatter.string(from: modificationDate)
    }
    
    /// Error type specific to file-related operations
    public enum Error: Swift.Error, CustomStringConvertible {
        /// Thrown when a file couldn't be written to
        case writeFailed
        /// Thrown when a file couldn't be read, either because it was malformed or because it has been deleted
        case readFailed
        
        /// A string describing the error
        public var description: String {
            switch self {
            case .writeFailed:
                return "Failed to write to file"
            case .readFailed:
                return "Failed to read file"
            }
        }
    }
    
    public required init() {
        try! super.init(path: "\(Date().timeIntervalSince1970)", kind: .file, using: .default)
    }
    
    /**
     *  Initialize an instance of this class with a path pointing to a file
     *
     *  - parameter path: The path of the file to create a representation of
     *  - parameter fileManager: Optionally give a custom file manager to use to look up the file
     *
     *  - throws: `FileSystemItem.Error` in case an empty path was given, or if the path given doesn't
     *    point to a readable file.
     */
    public init(path: String, fileManager: FileManager) throws {
        try super.init(path: path, kind: .file, using: fileManager)
    }
    
    public required init(path: String) throws {
        try super.init(path: path, kind: .file, using: .default)
    }
    
    /**
     *  Read the data contained within this file
     *
     *  - throws: `File.Error.readFailed` if the file's data couldn't be read
     */
    // sourcery:selectedForProtocol
    public func read() throws -> Data {
        do {
            return try Data(contentsOf: URL(fileURLWithPath: path))
        } catch {
            throw Error.readFailed
        }
    }
    
    /**
     *  Read the data contained within this file, and convert it to a string
     *
     *  - throws: `File.Error.readFailed` if the file's data couldn't be read as a string
     */
    // sourcery:selectedForProtocol
    public func readAsString() throws -> String {
        return try readAsString(encoding: .utf8)
    }
    
    public func readAsString(encoding: String.Encoding) throws -> String {
        guard let string = try String(data: read(), encoding: encoding) else {
            throw Error.readFailed
        }
        
        return string
    }
    
    /**
     *  Read the data contained within this file, and convert it to an int
     *
     *  - throws: `File.Error.readFailed` if the file's data couldn't be read as an int
     */
    public func readAsInt() throws -> Int {
        guard let int = try Int(readAsString()) else {
            throw Error.readFailed
        }
        
        return int
    }
    
    /**
     *  Write data to the file, replacing its current content
     *
     *  - parameter data: The data to write to the file
     *
     *  - throws: `File.Error.writeFailed` if the file couldn't be written to
     */
    // sourcery:selectedForProtocol
    public func write(data: Data) throws {
        do {
            try data.write(to: URL(fileURLWithPath: path))
        } catch {
            throw Error.writeFailed
        }
    }
    
    /**
     *  Write a string to the file, replacing its current content
     *
     *  - parameter string: The string to write to the file
     *  - parameter encoding: Optionally give which encoding that the string should be encoded in (defaults to UTF-8)
     *
     *  - throws: `File.Error.writeFailed` if the string couldn't be encoded, or written to the file
     */
    public func write(string: String) throws {
        try write(string: string, encoding: .utf8)
    }
    
    // sourcery:selectedForProtocol
    public func write(string: String, encoding: String.Encoding) throws {
        guard let data = string.data(using: encoding) else {
            throw Error.writeFailed
        }
        
        try write(data: data)
    }
    
    /**
     *  Append data to the end of the file
     *
     *  - parameter data: The data to append to the file
     *
     *  - throws: `File.Error.writeFailed` if the file couldn't be written to
     */
    public func append(data: Data) throws {
        do {
            let handle = try FileHandle(forWritingTo: URL(fileURLWithPath: path))
            handle.seekToEndOfFile()
            handle.write(data)
            handle.closeFile()
        } catch {
            throw Error.writeFailed
        }
    }
    
    /**
     *  Append a string to the end of the file
     *
     *  - parameter string: The string to append to the file
     *  - parameter encoding: Optionally give which encoding that the string should be encoded in (defaults to UTF-8)
     *
     *  - throws: `File.Error.writeFailed` if the string couldn't be encoded, or written to the file
     */
    public func append(string: String, encoding: String.Encoding = .utf8) throws {
        guard let data = string.data(using: encoding) else {
            throw Error.writeFailed
        }
        
        try append(data: data)
    }
    
    /**
     *  Copy this file to a new folder
     *
     *  - parameter folder: The folder that the file should be copy to
     *
     *  - throws: `FileSystem.Item.OperationError.copyFailed` if the file couldn't be copied
     */
    // sourcery:selectedForProtocol
    @discardableResult public func copy(to folder: Folder) throws -> FileProtocol {
        let newPath = folder.path + name
        
        do {
            try fileManager.copyItem(atPath: path, toPath: newPath)
            return try File(path: newPath)
        } catch {
            throw OperationError.copyFailed(self, error: "\(error)")
        }
    }
}
