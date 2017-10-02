import Foundation
import HighwayCore
import FSKit

let allArguments = ProcessInfo.processInfo.arguments
let arguments = Array(allArguments.dropFirst())
let app = App(fileSystem: LocalFileSystem())
app.run(with: arguments)

