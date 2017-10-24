Highway
=================

`highway` allows you to quickly automate the build, test and release cycle of your iOS or macOS app. Since `highway` builds on technologies you already know  (Swift & the Swift Package Manager, Foundation, ...) getting started is super easy.

# Cheat Sheet

| Command                   | Description                                                 |
|---------------------------|-------------------------------------------------------------|
| `highway` **init**        | Initializes a new highway project in the current directory. |
| `highway` **help**        | Displays available commands and options.                    |
| `highway` **generate**    | Generates an Xcode project.                                 |
| `highway` **bootstrap**   | Bootstraps the highway home directory.                      |
| `highway` **clean**       | Delete build artifacts of your highway project.             |
| `highway` **self_update** | Updates highway & the supporting frameworks                 |
| `highway` **--version**   | Print version information and exit.                         |


**Good to know**
* **Unknown commands/arguments** are passed to your highway project. For example: `highway xyz` will execute your highway called `xyz`.
* Executing `highway` **without any arguments** will print all available commands (including commands implemented by your highway project).
* To see whats going on under the hood use `--verbose`. For example: `highway --verbose xyz`.

Table of Contents
=================
* [Getting started](#a-namegetting-started-getting-started)
  * [Installing highway in 60 seconds (or less)](#a-nameinstallation-installing-highway-in-60-seconds-or-less)
  * [Setting up highway](#a-namesetup-setting-up-highway)
  * [Hello World (the fun part)](#a-namehello-world-hello-world-the-fun-part)
* [Make your highway project useful](#a-namemake-useful--make-your-highway-project-useful)
  * [Creating a simple custom Highway](#creating-a-simple-custom-highway)
  * [Highways with Dependencies](#highways-with-dependencies)
    * [Depending on a single Highway](#depending-on-a-single-highway)
    * [Depending on multiple Highways](#depending-on-multiple-highways)
  * [Highways with Results](#highways-with-results)
  * [Special Highways](#special-highways)
* [Included Frameworks](#included-frameworks)
  * [Swift: build & test](#swift-build--test)
  * [Xcode: build, archive, test (...) + xcpretty](#xcode-build-archive-test---xcpretty)
  * [Keychain: Access Secrets](#keychain-access-secrets)
  * [git: commit, push, (auto-) tag](#git-commit-push-auto--tag)
  * [fastlane](#fastlane)
* [Updating](#updating)
  * [Dependencies](#dependencies)
  * [CLI](#cli)
  
---

# <a name="getting-started" />Getting started


## <a name="installation" />Installing highway in 60 seconds (or less)

Simply paste the following command into a terminal of your choice.

```
pushd $(mktemp -d -t highway) && \
git clone -b master https://github.com/ChristianKienle/highway.git highway && \
./highway/scripts/bootstrap.sh --interactive && popd
```

This will checkout highway and run the bootstrap script. The bootstrap script is building highway using Swift Package Manager. The built highway command line tool will be placed (alongside other stuff) in `~/.highway`. Make sure to add `~/.highway/bin` to your `$PATH` after the bootstrap process is finished.

## <a name="setup" />Setting up highway
After installing highway make sure to add `~/.highway/bin` to your `$PATH`. Here is one way to do it:

```
$ echo "PATH=$PATH:${HOME}/.highway/bin" >> ${HOME}/.profile
```

Then open a new terminal window, so that the new `PATH` takes effect. Check your installation:

```
$ highway --version
$ highway help
```

## <a name="hello-world" />Hello World (the fun part)
With highway you can do just about anything. Highway is not specifically made for a specific task. You can think of it as a command line tool (+ support frameworks) that make is easy to manage, build and execute Swift code from the command line. One use case that comes immediately to mind is to use highway to build, test, deploy and release iOS/macOS apps.

Open Terminal and create an empty directory:

```
$ mkdir my_new_project
$ cd my_new_project
```

Now you can create a plain highway project.:

```
$ highway init
```

This creates a directory directory named `_highway`. You can have a look at the contents of the directory if you want. It is just a Swift Package Manager compatible project with a single Swift file, `main.swift`. In the directory containing the `_highway` directory execute:

```
$ highway
```

Yes: Without any arguments. This builds and runs your `_highway`. By default, this displays a list of available commands. The cool thing is that you can add new commands by simply editing the `_highway/main.swift` file.

# <a name="make-useful" /> Make your highway project useful

## Creating a simple custom Highway
The `highway` command line tool can be executed with arguments - just like most command line tools. Custom highways make it possible to invoke `highway` with custom commands/arguments. You can think of a highway as code that maps arguments/commands to custom logic, written in Swift. Each new highway project (created using `highway init`) comes with a few custom highways by default. You can see the predefined custom highways in `_highway/main.swift`. The default custom highways look something like this:

``` swift
import HighwayCore
import XCBuild
import HighwayProject
import Deliver
import Foundation

enum Way: String, HighwayType {
    case test, build, run
    var usage: String {
        switch self {
        case .build: return "Builds the project"
        case .test: return "Executes tests"
        case .run: return "Runs the project"
        }
    }
}

class App: Highway<Way> {
    override func setupHighways() {
        self[.build] ==> build
        self[.test] ==> test
        self[.run] ==> run
    }

    // MARK: - Highways
    func build() {

    }

    func test() throws {
        var options = TestOptions()
        options.project = "<insert path to *.xcproject here>"
        options.scheme = "<insert name of scheme here>"
        options.destination = Destination.simulator(.iOS, name: "iPhone 7", os: .latest, id: nil)
        try xcbuild.buildAndTest(using: options)
    }

    func run() {

    }
}

App(Way.self).go()
```

The `Way`-enum implements the `HighwayType`-protocol. By default the `rawValue` of the `Way`-enum will be the expected argument. In the example above the highways `build`, `test` and `run` can be invoked like this:

Executing the `build`-highway:
```
$ highway build
```

Executing the `test`-highway:
```
$ highway test
```

Executing the `run`-highway:
```
$ highway run
```

You get the idea. Creating a custom highway is done in two steps:

**1. Add a case to the `Highway`-implementation and implement `-usage`:**

``` swift
//...
enum Way: String, HighwayType {
    case test
    case build
    case run
    case myHighway // ⬅︎ HERE

    var usage: String {
        switch self {
        case .build: return "Builds the project"
        case .test: return "Executes tests"
        case .run: return "Runs the project"
        case .myHighway: return "hello" // ⬅︎ HERE
        }
    }
}
//...
```

**2. Register your highway:**
Still in `_highway/main.swift`: Scroll down and register your highway in `-setupHighways` like this:

``` swift
//...
class App: Highway<Way> {
    override func setupHighways() {
        self[.build] ==> build
        self[.test] ==> test
        self[.run] ==> run
        self[.myHighway] ==> myHighway // ⬅︎ HERE
    }

    func myHighway() throws { // ⬅︎ HERE
      print("hello world")
    }
//...
```
Now you can execute your highway like this:

```
$ highway myHighway
```

If you omit the command/highway then highway will list all available commands/highways.

## Highways with Dependencies

### Depending on a single Highway

A highway can depend on other highways. You specify dependencies between highways in your implementation of `-setupHighways`:

``` swift
//...
override func setupHighways() {
    // imagine 'build' actually builds your app/project.
    self[.build] ==> build

    // imagine 'test' actually runs your tests.
    self[.test].depends(on: .build) ==> test

    // imagine 'run 'actually runs your app/project.
    self[.run].depends(on: .test) ==> run
}
//...
```

In the example above there are three highways, two of which depend on other highways.

* `test` depends on `build`: This means that executing `highway test` first executes the `build` highway. Which makes sense because you want to execute the tests only if your project is building.
* `run` depends on `test`: This means that executing `highway run` first executes the `test` highway (which first executes the `build` highway). This way it is ensured that `highway run` always runs the latest artifact.

### Depending on multiple Highways

A highway can depend on a single highway (see above) or on multiple highways. Multiple dependencies are specified by using the exact same method (`-depend(on:)`). For example:

``` swift
//...
override func setupHighways() {
    // imagine 'build' actually builds your app/project.
    self[.build] ==> build

    // imagine 'test' actually runs your tests.
    self[.test] ==> test

    // imagine 'run 'actually runs your app/project.
    self[.run].depends(on: .build, .test) ==> run
}
//...
```
The `run`-highway above directly depends on `build` and `test`. This means that `highway run` will first execute `build` and then `test`.

## Highways with Results

A highway usually performs a task like building, testing, deploying (or something less impactful). It is not uncommon that a highway produces some kind of (intermediate) result. One example immediately comes to mind:

Let's assume that you have two highways:

1. `build`: Builds your project - for example by using `xcodebuild` or `swift`.
2. `release`: Releases your project by uploading the build artifact to a server.

Your `release`-highway naturally depends on `build`: `build` must be executed before `release` and `release` needs the results from the build process. You can do that by combining dependencies and highways with results:

``` swift
import HighwayCore
import XCBuild
import HighwayProject
import Deliver
import Foundation

enum Way: String, HighwayType {
    case build, release
}

class App: Highway<Way> {
    override func setupHighways() {
        self[.build] ==> build
        self[.release].depends(on: .build) ==> release
    }

    func build() -> String {
        return "./.build/release/my_app"
    }

    func release() throws {
        let path: String = try result(for: .build)
        print(path)
        // Now upload the file at path to a server.
    }
}

App(Way.self).go()
```  

## Special Highways
There are a few special highways. Registering for a special highway is straight forward:

```swift
//...
override func setupHighways() {
  self[.build] ==> build
  self[.release].depends(on: .build) ==> release

  // 🔆 🔆 SPECIAL HIGHWAYS 🔆 🔆
  onError = { print($0) }                         // 1.
  onEmptyCommand = { print("$ ./_highway") }      // 2.
  onUnrecognizedCommand = { print("args: \($0)")} // 3.
}
//...
```

The code above registers for three special highways:

1. `onError`: If a custom highway throws an `Swift.Error` this highway is executed. The error is passed as an argument.
2. `onEmptyCommand`: If the `_highway` binary is executed without any command this highway is executed. Don't confuse `highway` with `_highway`. `highway` is the command line tool you interact with all the time. `_highway` is the executable produced by compiling `_highway/main.swift`. Usually you do never interact with `_highway` directly. You only use `_highway` indirectly. It is only listed here to be complete.
3. `onUnrecognizedCommand`: If `highway` is executed with a command that is neither handled by itself nor by your `_highway` project the default behavior is that `highway` prints a list of all known commands — unless you have registered the `onUnrecognizedCommand` highway. In that case `highway` no longer prints any helpful information when it encounters an unknown command.

# Included Frameworks

highway comes with a few frameworks that help you get stuff done in your highway project. You are not limited to only those frameworks/features. You can use almost any Objective-C/Swift framework available. Just add additional frameworks you wanna use in your `_highway/main.swift`-file to `_highway/Package.swift`. However in some circumstances, the build in features/frameworks will be enough. Here is what you can use out of the box:

## Swift: build & test
Example:

```
let swift = SwiftBuildSystem()

try swift.test() // Test

// Build and get an object describing the result.
let artifact = try swift.build()

print("😜  \(artifact.binPath)")
print("😜  \(artifact.buildOutput)")
```

`SwiftBuildSystem` is a wrapper around the `swift` command line tool. By default, `test()` simply executes the tests of the Swift project in `_highway/..`. `build()` is much like `test()` with the difference that it returns a `SwiftBuildSystem.Artifact` that has properties like `buildOutput` (everything `swift build` would have printed to the screen) and `binPath`, the path to the directory that contains the built executable.

## Xcode: build, archive, test (...) + xcpretty
highway has a few classes that deal with Xcode (a wrapper for xcodebuild and xcpretty). They can be found in the `XCBuild` framework.

Those classes can be used to easily talk to the Xcode build system. However they are very volatile and subject to change.

Each `Highway` automatically has an instance of `XCBuild`. `XCBuild` is able to:

- build your Xcode project,
- run your tests,
- create archives,
- code sign and export those archives and
- finally upload them to iTunes Connect

For example the following code (that can be used in `setupHighways` as a highway) builds and tests the project `myapp`.

``` swift
func build() throws -> TestReport {
    var options = TestOptions()

    options.project = cwd.appending("myapp.xcodeproj").path
    options.destination = Destination.simulator(.iOS,
                                                name: "iPhone 7",
                                                os: .latest,
                                                id: nil)
    options.scheme = "myapp"

    return try xcbuild.buildAndTest(using: options)
}
```

## Keychain: Access Secrets
A simple way to store secrets and use the from within your custom highways is to use `Keychain`. You could store your old fashioned and highly insecure FTP-passwords there for example. Highway comes with a simple class that allows you to access your keychain:

``` swift
let keychain = Keychain()
let query = Keychain.PasswordQuery(account: "$username", service: "My FTP Password")
let password = try keychain.password(matching: query)
```

## git: commit, push, (auto-) tag

``` swift
let git = self.git // each highway has a git-instance already!
let cwd = self.cwd // each highway knows it's current working directory

// Executes: git add .
try git.addEverything(at: cwd)

// Executes: git commit -m "$message"
try git.commit(at: cwd, message: "$message")

// Executes: git push origin master
try git.pushToMaster(at: cwd)

// Executes: git-autotag
let nextVersion = try GitAutotag().autotag(at: cwd, dryRun: false)

// Executes: git push --tags
try git.pushTagsToMaster(at: cwd)
```

## fastlane
A super minimalistic wrapper around fastlane:

```
try Fastlane().gym("arguments", "passed", "to", "fastlane gym")
try Fastlane().scan("arguments", "passed", "to", "fastlane scan")
```

# Updating

## Dependencies

Update the dependencies of your highway project:

```
$ highway clean
$ highway
$ highway generate # optional
```

## CLI

Update highway itself:

```
$ highway self_update
$ highway --version # verify
```
