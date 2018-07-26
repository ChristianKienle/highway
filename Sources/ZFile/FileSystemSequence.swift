//
//  FileSystemSequence.swift
//  GitHooks
//
//  Created by Stijn on 10/07/2018.
//

import Foundation

/**
 *  A sequence used to iterate over file system items
 *
 *  You don't create instances of this class yourself. Instead, you can access various sequences on a `Folder`, for example
 *  containing its files and subfolders. The sequence is lazily evaluated when you perform operations on it.
 */
public class FileSystemSequence<T>: Sequence, CustomStringConvertible where T: FileSystemIterable, T: ItemProtocol {
    /// The number of items contained in this sequence. Accessing this causes the sequence to be evaluated.
    public var count: Int {
        var count = 0
        forEach { _ in count += 1 }
        return count
    }
    
    /// An array containing the names of all the items contained in this sequence. Accessing this causes the sequence to be evaluated.
    public var names: [String] {
        return map { $0.name }
    }
    
    /// The first item of the sequence. Accessing this causes the sequence to be evaluated until an item is found
    public var first: T? {
        return makeIterator().next()
    }
    
    /// The last item of the sequence. Accessing this causes the sequence to be evaluated.
    public var last: T? {
        var item: T?
        forEach { item = $0 }
        return item
    }
    
    private let folder: Folder
    private let recursive: Bool
    private let includeHidden: Bool
    private let fileManager: FileManager
    
    init(folder: Folder, recursive: Bool, includeHidden: Bool, using fileManager: FileManager) {
        self.folder = folder
        self.recursive = recursive
        self.includeHidden = includeHidden
        self.fileManager = fileManager
    }
    
    /// Create an iterator to use to iterate over the sequence
    public func makeIterator() -> FileSystemIterator<T> {
        return FileSystemIterator(folder: folder, recursive: recursive, includeHidden: includeHidden, using: fileManager)
    }
    
    /// Move all the items in this sequence to a new folder. See `FileSystem.Item.move(to:)` for more info.
    public func move(to newParent: Folder) throws {
        try forEach { try $0.move(to: newParent) }
    }
    
    public var description: String {
        return map { $0.description }.joined(separator: "\n")
    }
}
