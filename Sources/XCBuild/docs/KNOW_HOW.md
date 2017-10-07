# Show SDKs

```
xcodebuild -showsdks
```

# Show Toolchains

```
 xcodebuild -version -sdk
```

Toolchains:
- iPhoneSimulator11.0.sdk - Simulator - iOS 11.0 (iphonesimulator11.0)
- iPhoneOS11.0.sdk - iOS 11.0 (iphoneos11.0)

# Destination
xcodebuild -destination DESTINATIONSPECIFIER

see: http://www.mokacoding.com/blog/xcodebuild-destination-options/


# ddd
Simulator:

xcodebuild \
  -scheme highwayiostest \
  -sdk iphonesimulator11.0 \
  -toolchain iphonesimulator11.0 \
  -archivePath ./archive \
  -derivedDataPath ./derivedData \
  -resultBundlePath ./resultBundle \
  build

Release/Device:

xcodebuild \
  -scheme highwayiostest \
  -sdk iphonesimulator11.0 \
  -toolchain iphonesimulator11.0 \
  -archivePath ./archive \
  -derivedDataPath ./derivedData_archive \
  -resultBundlePath ./resultBundle_archive \
  -destination generic/platform=iOS \
  -configuration Release \
  CODE_SIGN_IDENTITY='iPhone Distribution: Christian Kienle' \
  archive

xcodebuild \
  -scheme highwayiostest \
  -project ./highwayiostest.xcodeproj \
  -destination 'generic/platform=iOS' \
  -archivePath 'temp/path/uud.xcarchive'
  archive

export:

erst plist schrieben

<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>method</key>
	<string>app-store</string>
	<key>provisioningProfiles</key>
	<dict>
		<key>de.christian-kienle.highway.e2e.ios</key>
		<string>highwayiostest Prod Profile</string>
	</dict>
</dict>
</plist>


xcodebuild \
  -exportArchive \
  -exportOptionsPlist './path.plist' \
  -archivePath 'temp/path/uud.xcarchive' \
  -exportPath 'test/temp/uuid'



  xcodebuild \
    -scheme highwayiostest \
    -sdk iphonesimulator11.0 \
    -toolchain iphonesimulator11.0 \
    -destination generic/platform=iOS \
    -configuration Release \
    CODE_SIGN_IDENTITY='iPhone Distribution: Christian Kienle' \
    archive
