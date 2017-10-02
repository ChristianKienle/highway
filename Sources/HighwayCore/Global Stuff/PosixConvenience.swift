import Foundation
import Darwin
import FSKit

public func getabscwd() -> AbsoluteUrl {
    #if Xcode
        if let result = _getabsxcodecwd(file: #file, bundle: .standard) {
            return AbsoluteUrl(result)
        }
    #endif
    func error() -> Never {
        fputs("error: no current directory\n", stderr)
        exit(EXIT_FAILURE)
    }
    
    let cwd = Darwin.getcwd(nil, Int(PATH_MAX))
    if cwd == nil { error() }
    defer { free(cwd) }
    guard let path = String(validatingUTF8: cwd!) else { error() }

    return AbsoluteUrl(path)
}

private func _getabsxcodecwd(file: String, bundle: HighwayBundle.Configuration) -> URL? {
    // Special case:
    // Xcode modifies the current working directory. If the user
    // opens his highway project in Xcode and launches it
    // he expects the cwd to be the directory that contains
    // highway-go/.
    // In order to determine the cwd we get #file and move up the
    // directory tree until we find 'highway-go/.hwbuild'
    // or more generally, until we find:
    // HWBundle.directoryName/HWBundle.buildDirectoryName
    // The cwd then becomes the parent of HWBundle.directoryName.
    let xcodeCWD = URL(fileURLWithPath: file)
    let components = xcodeCWD.pathComponents
    guard let buildDirIndex = components.index(of: bundle.buildDirectoryName) else {
        return nil
    }
    // Check if index before buildDirIndex exists and value is correct
    let previousIndex = buildDirIndex - 1
    guard components.indices.contains(previousIndex) else {
        return nil
    }
    let prevValue = components[previousIndex]
    let foundDirSequence = prevValue == bundle.directoryName
    guard foundDirSequence else {
        return nil
    }
    let subComps = components[0..<previousIndex]
    var result = URL(string: "file://")!
    subComps.forEach { result = result.appendingPathComponent($0) }
    return result
}
