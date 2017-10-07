import Foundation
import HighwayCore
import FileSystem
import Terminal

let invocation = CommandLineInvocationProvider().invocation()
Terminal.shared.verbose = invocation.verbose

let app = App(AppHighway.self)
app.go()

