Highway
=================

From zero to a new highway- + Swift Package Manager-project + an Xcode project + a build and test highway in 5 seconds.

```
$ highway init_swift      # ➤ new swift + highway project
$ highway build           # ➤ executes the build highway
$ highway test            # ➤ executes the test highway
$ highway generate        # ➤ generates Xcode project
```

`highway` allows you to quickly automate the build, test and release cycle of your iOS or macOS app. Since `highway` builds on top of technologies you already know how to use (Swift & the Swift Package Manager, Foundation, ...) getting started is super easy.

Table of Contents
=================

* [Getting started](#getting-started)
  * [Installing highway in 60 seconds (or less)](#installing-highway-in-60-seconds-or-less)
  * [Setting up highway](#setting-up-highway)
  * [Hello World (the fun part)](#hello-world-the-fun-part)
  * [highway + Swift](#highway--swift)
* [Make your highway project useful](#make-your-highway-project-useful)
  * [Creating a simple custom Highway](#creating-a-simple-custom-highway)
  * [Highways with Dependencies](#highways-with-dependencies)
  * [Highways with Results](#highways-with-results)
  * [Special Highways](#special-highways)
* [Included Frameworks](#included-frameworks)
  * [Swift: build &amp; test](#swift-build--test)
  * [Xcode: build, archive, test (...) + xcpretty](#xcode-build-archive-test---xcpretty)
  * [Keychain: Access Secrets](#keychain-access-secrets)
  * [git: commit, push, (auto-) tag](#git-commit-push-auto--tag)
  * [fastlane](#fastlane)
* [Updating](#updating)
  * [Dependencies](#dependencies)
  * [CLI](#cli)

---
# Getting started


## Installing highway in 60 seconds (or less)

Simply paste the following command into a terminal of your choice.

```
pushd $(mktemp -d -t highway) && \
git clone -b master https://github.com/ChristianKienle/highway.git highway && \
./highway/scripts/bootstrap.sh --interactive && popd
```

This will checkout highway and run the bootstrap script. The bootstrap script is building highway using Swift Package Manager. The built highway command line tool will be placed (alongside other stuff) in `~/.highway`. Make sure to add `~/.highway/bin` to your `$PATH` after the bootstrap process is finished.

## Setting up highway
After installing highway make sure to add `~/.highway/bin` to your `$PATH`. Here is one way to do it:

```
$ echo "PATH=$PATH:${HOME}/.highway/bin" >> ${HOME}/.profile
```

Then open a new terminal window, so that the new `PATH` takes effect. Check your installation:

```
$ highway --version
$ highway help
```

## Hello World (the fun part)
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

## highway + Swift

highway + Swift  =  ❤️

Because of that there is a special version of `init`:

```
$ mkdir my_new_app && cd my_new_app
$ highway init_swift
```

Executing `highway init_swift` creates:
- a Swift Package Manager project (type: executable) named `my_new_app` and
- a highway project in the same directory (`./_highway`). The created highway project has two simple highways:
  - `build`: Builds the created Swift project.
  - `test`: Executes the tests of the Swift project.


# Make your highway project useful

## Creating a simple custom Highway
The `highway` command line tool can be executed with arguments - just like most command line tools. Custom highways make it possible to invoke `highway` with custom commands/arguments. You can think of a highway as code that maps arguments/commands to custom logic, written in Swift. Each new highway project (created using `highway init`) comes with a few custom highways by default. You can see the predefined custom highways in `_highway/main.swift`. The default custom highways look something like this:

```
enum App: String, Highway {
    case build
    case test
    case run

    /// !!! Add more Highways by adding additional cases. !!!

    var usage: String {
        switch self {
        case .build: return "Builds the project"
        case .test: return "Executes tests"
        case .run: return "Runs the project"
        }
    }
}
```

The `App`-enum implements the `Highway`-protocol. By default the `rawValue` of the `Highway` will be the expected argument. In the example above the highways build, test and run can be invoked like this:

Executing the `build`-highway:
```
$ highway build
```

Executing the `test`-highway:
```
$ highway test
```

Executing the `clean`-highway:
```
$ highway clean
```

You get the idea. Creating a custom highway is done in two steps:

**1. Add a case to the `Highway`-implementation and implement `-usage`:**

```
enum App: String, Highway {
    case build
    case test
    case run
    case myHighway /// <---- here

    var usage: String {
        switch self {
        case .build: return "Builds the project"
        case .test: return "Executes tests"
        case .run: return "Runs the project"
        case .myHighway: return "I like snow" /// <---- and here
        }
    }
}
```

**2. Register your highway:**
Still in `_highway/main.swift`: Scroll down and register your highway like this:

```
// MARK: - Setup your custom highways
highways

    .highway(.build) {

    }
    .highway(.test) {

    }
    .highway(.run) {

    }
    .highway(myHighway) {
      print(">>> here <<<")
    }

    .go()
```
Now you can execute your highway like this:

```
$ highway myHighway
```

If you omit the command/highway then highway will list all available commands/highways.

## Highways with Dependencies
A highway can depend on other highways. You specify dependencies between highways in the `main.swift` file:

```
highways

    .highway(.build) {
      // imagine code that actually builds your app/project.
    }

    .highway(.test, dependsOn: [.build]) {
      // imagine code that actually runs your tests.
    }

    .highway(.run, dependsOn: [.test]) {
      // imagine code that actually runs your app/project.
    }

    .go()
```

In the example above there are three highways, two of which depend on other highways.

* `test` depends on `build`: This means that executing `highway test` first executes the `build` highway. Which makes sense because you want to execute the tests only if your project is building.
* `run` depends on `test`: This means that executing `highway run` first executes the `test` highway (which first executes the `build` highway). This way it is ensured that `highway run` always runs the latest artifact.

## Highways with Results

A highway usually performs a task like building, testing, deploying (or something less impactful). It is not uncommon that a highway produces some kind of (intermediate) result. One example immediately comes to mind:

Let's assume that you have two highways:

1. `build`: Builds your project - for example by using `xcodebuild` or `swift`.
2. `release`: Releases your project by uploading the build artifact to a server.

Your `release`-highway naturally depends on `build`: `build` must be executed before `release` and `release` needs the results from the build process. You can do that by combining dependencies and highways with results:

```
import HighwayCore

enum App: String, Highway { case build, release }

let highways = Highways(App.self)

highways

    .highway(.build) {
        // image code that uses xcodebuild or swift (...)
        // and returns the url to the build product.
        return "./.build/release/my_app"
    }

    .highway(.release, dependsOn: [.build]) {
        let path: String = try highways.result(for: .build)
        print(path)
        // Now upload the file at path to a server.
    }

    .go()
```  

## Special Highways
There are a few special highways. Registering for a special highway is straight forward:

```
enum App: String, Highway { case build, release }

let highways = Highways(App.self)

highways

  // specical highways

  .onError { print($0) }                         // 1.
  .onEmptyCommand { print("$ ./_highway") }      // 2.
  .onUnrecognizedCommand { print("args: \($0)")} // 3.


  // regular custom highways, as usual

  .highway(.build)   { /*...*/ }
  .highway(.release) { /*...*/ }

  .go()
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
highway has a few classes that deal with Xcode (a wrapper for xcodebuild and xcpretty):

- class: `XCBuildSystem`
- class: `Xcodebuild`

Those classes can be used to easily talk to the Xcode build system. However they are very volatile and subject to change.

## Keychain: Access Secrets
A simple way to store secrets and use the from within your custom highways is to use `Keychain`. You could store your old fashioned and highly insecure FTP-passwords there for example. Highway comes with a simple class that allows you to access your keychain:

```
let keychain = Keychain()
let query = Keychain.PasswordQuery(account: "$username", service: "My FTP Password")
let password = try keychain.password(matching: query)
```

## git: commit, push, (auto-) tag

```
let git = try GitTool()
let cwd = getabscwd()

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
