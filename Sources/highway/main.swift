import Foundation
import HighwayCore
import ZFile
import Terminal

let invocation = CommandLineInvocationProvider().invocation()
Terminal.shared.verbose = invocation.verbose

let app = App(AppHighway.self)
app.go()

