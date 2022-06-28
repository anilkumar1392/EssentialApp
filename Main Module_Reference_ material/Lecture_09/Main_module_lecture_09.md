## Continuous Delivery and Deployment: Automating the App Deploy to App Store Connect

## Setup Continuous Integration & Delivery pipelines with GitHub actions

## .github/workflows/CI-iOS.yml


name: CI-iOS

# Controls when the action will run. Triggers the workflow on push or pull request
# events but only for the master branch
on:
  pull_request:
    branches: [ master ]

# A workflow run is made up of one or more jobs that can run sequentially or in parallel
jobs:
  # This workflow contains a single job called "build"
  build-and-test:
    # The type of runner that the job will run on
    runs-on: macos-latest

    # Steps represent a sequence of tasks that will be executed as part of the job
    steps:
    # Checks-out your repository under $GITHUB_WORKSPACE, so your job can access it
    - uses: actions/checkout@v2

    - name: Select Xcode
      run: sudo xcode-select -switch /Applications/Xcode_11.4.1.app

    - name: Xcode version
      run: /usr/bin/xcodebuild -version

    - name: Build and Test
      run: xcodebuild clean build test -workspace EssentialApp/EssentialApp.xcworkspace -scheme "CI_iOS" CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO -sdk iphonesimulator -destination "platform=iOS Simulator,name=iPhone 11" ONLY_ACTIVE_ARCH=YES

## .github/workflows/CI-macOS.yml

name: CI-macOS

# Controls when the action will run. Triggers the workflow on push or pull request
# events but only for the master branch
on:
  pull_request:
    branches: [ master ]

# A workflow run is made up of one or more jobs that can run sequentially or in parallel
jobs:
  # This workflow contains a single job called "build"
  build-and-test:
    # The type of runner that the job will run on
    runs-on: macos-latest

    # Steps represent a sequence of tasks that will be executed as part of the job
    steps:
    # Checks-out your repository under $GITHUB_WORKSPACE, so your job can access it
    - uses: actions/checkout@v2

    - name: Select Xcode
      run: sudo xcode-select -switch /Applications/Xcode_11.4.1.app

    - name: Xcode version
      run: /usr/bin/xcodebuild -version

    - name: Build and Test
      run: xcodebuild clean build test -project EssentialFeed/EssentialFeed.xcodeproj -scheme "CI_macOS" CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO -sdk macosx -destination "platform=macOS" ONLY_ACTIVE_ARCH=YES

## .travis.yml

os: osx
osx_image: xcode11.2
language: swift
script: 
  - xcodebuild clean build test -project EssentialFeed/EssentialFeed.xcodeproj -scheme "CI_macOS" CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO -sdk macosx -destination "platform=macOS" ONLY_ACTIVE_ARCH=YES
  - xcodebuild clean build test -workspace EssentialApp/EssentialApp.xcworkspace -scheme "CI_iOS" CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO -sdk iphonesimulator -destination "platform=iOS Simulator,OS=13.2.2,name=iPhone 11" ONLY_ACTIVE_ARCH=YES
 
 
 # Set up Deploy workflow with GitHub actions
1. ExportOptions.plist
2. certificate.p12.gpg
3. profile.mobileprovision.gpg

## .github/deployment/ExportOptions.plist

?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>destination</key>
    <string>export</string>
    <key>method</key>
    <string>app-store</string>
    <key>provisioningProfiles</key>
    <dict>
        <key>com.essentialdeveloper.EssentialAppCaseStudy</key>
        <string>Essential App Case Study (Production)</string>
    </dict>
    <key>signingCertificate</key>
    <string>Apple Distribution</string>
    <key>signingStyle</key>
    <string>manual</string>
    <key>stripSwiftSymbols</key>
    <true/>
    <key>teamID</key>
    <string>VRJ2W4578X</string>
    <key>uploadBitcode</key>
    <true/>
    <key>uploadSymbols</key>
    <true/>
</dict>
</plist>


# .github/deployment/certificate.p12.gpg

# .github/deployment/profile.mobileprovision.gpg
