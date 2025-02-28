This file will provide all informations related to [Qt Framework][qt-home] under **MacOS**

**Table of contents**
- [1. Deploy](#1-deploy)
  - [1.1. Set metadata ressources](#11-set-metadata-ressources)
  - [1.2. Generate bundle](#12-generate-bundle)
  - [1.3. Sign application](#13-sign-application)


# 1. Deploy
## 1.1. Set metadata ressources

Under **MacOS**, a file `Info.plist` is required, _Qt_ (or _XCode_) automatically generate one for us but if additional permissions are required, we have to manage this file ourself.

The easiest way is to use [`configure_file()`][cmake-configure-file] feature from **CMake**.

1. Provide `Info.plist.in` template:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleInfoDictionaryVersion</key>
    <string>6.0</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleDevelopmentRegion</key>
	<string>en</string>

    <key>CFBundleIdentifier</key>
    <string>com.@PROJECT_COMPANY_ID@.@PROJECT_ID@</string>
    <key>CFBundleName</key>
	<string>@PROJECT_NAME@</string>
    <key>CFBundleDisplayName</key>
	<string>@PROJECT_NAME@</string>
    <key>CFBundleExecutable</key>
	<string>@PROJECT_ID@</string>

    <key>CFBundleVersion</key>
    <string>@PROJECT_VERSION@</string>
    <key>NSHumanReadableCopyright</key>
    <string>Copyright (c) @DATE_CURRENT_YEAR@, @PROJECT_COMPANY_NAME@</string>
    <key>LSMinimumSystemVersion</key>
	<string></string>

    <key>CFBundleIconFile</key>
	<string></string>

    <key>NSPrincipalClass</key>
	<string>NSApplication</string>

    <key>NSLocalNetworkUsageDescription</key>
    <string>This app requires access to the local network to communicate with devices.</string>
    <key>NSBonjourServices</key>
    <array>
        <string>_myservice._tcp</string>
    </array>
</dict>
</plist>
```
> [!NOTE]
> More infos can be found under [Apple Bundle Information Properly List][apple-info-plist] documentation.

2. Set **CMake** needed variable and generate the file:
```cmake
cmake_minimum_required(VERSION 3.19)

# Set project properties
set(PROJECT_COMPANY_ID mycompanyid)
set(PROJECT_COMPANY_NAME "My Company Name")
set(PROJECT_ID myprojectid)
set(PROJECT_NAME "My application name")
set(PROJECT_VERSION_SEMANTIC 5.0.0)

project(${PROJECT_NAME} VERSION ${PROJECT_VERSION_SEMANTIC})

# Defines useful path variables for easier CMake configuration
set(PROJECT_FILE_OS_METADATA_MACOS "Info.plist")

# Do your thing...

# Before calling `add_executable()`
configure_file("${CMAKE_CURRENT_SOURCE_DIR}/${PROJECT_FILE_OS_METADATA_MACOS}.in" "${CMAKE_BINARY_DIR}/${PROJECT_FILE_OS_METADATA_MACOS}")

# Once target is created
set_target_properties(${PROJECT_NAME} PROPERTIES
    VERSION ${PROJECT_VERSION_SEMANTIC}
    MACOSX_BUNDLE TRUE
    MACOSX_BUNDLE_INFO_PLIST ${CMAKE_BINARY_DIR}/${PROJECT_FILE_OS_METADATA_MACOS}
)
```
> [!TIP]
> Values set here are not **CMake** variable (except `PROJECT_VERSION`), `configure_file()` allow any variable name as long as they are properly set.

## 1.2. Generate bundle

_TODO: Add details on how to use macdeployqt_

## 1.3. Sign application

_TODO: explain how to use codesign (should not use `--force`). But provide some examples in the meantime:_
```shell
# If your app runs into sandboxing or security issues, sign it:
codesign --force --deep --sign - MyApp.app

# If distributing the app, use your Apple Developer ID:
codesign --force --sign "Developer ID Application: Your Name" MyApp.app
```

<!-- External links -->

[apple-info-plist]: https://developer.apple.com/documentation/bundleresources/information-property-list?language=objc
[cmake-configure-file]: https://cmake.org/cmake/help/latest/command/configure_file.html
[qt-home]: https://www.qt.io/