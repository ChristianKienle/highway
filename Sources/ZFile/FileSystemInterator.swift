//
//  FileSystemInterator.swift
//  GitHooks
//
//  Created by Stijn on 10/07/2018.
//

import Foundation


/// Iterator used to iterate over an instance of `FileSystemSequence`
public class FileSystemIterator<T: ItemProtocol>: IteratorProtocol where T: FileSystemIterable {
    private let folder: Folder
    private let recursive: Bool
    private let includeHidden: Bool
    private let fileManager: FileManager
    private lazy var itemNames: [String] = {
        self.fileManager.itemNames(inFolderAtPath: self.folder.path)
    }()
    
    private lazy var childIteratorQueue = [FileSystemIterator]()
    private var currentChildIterator: FileSystemIterator?
    
    init(folder: Folder, recursive: Bool, includeHidden: Bool, using fileManager: FileManager) {
        self.folder = folder
        self.recursive = recursive
        self.includeHidden = includeHidden
        self.fileManager = fileManager
    }
    
    /// Advance the iterator to the next element
    public func next() -> T? {
        if itemNames.isEmpty {
            if let childIterator = currentChildIterator {
                if let next = childIterator.next() {
                    return next
                }
            }
            
            guard !childIteratorQueue.isEmpty else {
                return nil
            }
            
            currentChildIterator = childIteratorQueue.removeFirst()
            return next()
        }
        
        let nextItemName = itemNames.removeFirst()
        
        guard includeHidden || !nextItemName.hasPrefix(".") else {
            return next()
        }
        
        let nextItemPath = folder.path + nextItemName
        let nextItem = try? T(path: nextItemPath)
        
        if recursive, let folder = (nextItem as? Folder) ?? (try? Folder(path: nextItemPath)) {
            let child = FileSystemIterator(folder: folder, recursive: true, includeHidden: includeHidden, using: fileManager)
            childIteratorQueue.append(child)
        }
        
        return nextItem ?? next()
    }
}
