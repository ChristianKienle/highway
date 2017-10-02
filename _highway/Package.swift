// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "_highway",
   dependencies: [
      .package(url: "git@bitbucket.org:ChristianKienle/highway.git", .upToNextMajor(from: "0.0.0"))
   ],
   targets: [
      .target(
         name: "_highway",
         dependencies: ["HighwayCore", "HWKit"],
         path: "."
      ),
   ]
)
