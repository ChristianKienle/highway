// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "_highway",
   dependencies: [
      .package(url: "https://github.com/ChristianKienle/highway.git", .upToNextMajor(from: "0.0.0"))
   ],
   targets: [
      .target(
         name: "_highway",
         dependencies: ["HighwayProject", "HighwayCore", "HWKit", "FSKit", "Terminal"],
         path: "."
      ),
   ]
)
