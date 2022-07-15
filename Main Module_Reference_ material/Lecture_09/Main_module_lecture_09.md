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
1. ExportOptions.plist (For exporting your archieve.)
2. certificate.p12.gpg
3. profile.mobileprovision.gpg

## Turorials for all of this are available you just need to follow tutorial.
## Upload cretificate by encryptiing the certificate.

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


Learning Outcomes
Differences and Relations between Continuous Integration, Delivery, and Deployment
Guidelines for uploading builds to App Store Connect
Deploying builds to App Store Connect manually
Deploying builds to App Store Connect automatically with a Continuous Delivery pipeline

# Continuous Integration, Delivery, and Deployment

## Continuous Integration (CI) 

Continuous Integration (CI) is the practice of merging working versions of the code into the main branch with great speed and frequency (several times a day).

Continually merging all developers’ work enables dev teams to work in smaller and more concise batches, eliminating many issues that slow down the development process, such as big merge conflicts.

To guarantee the codebase consistency and speed up the integration process, the team will create an automated CI pipeline to ensure the build is not broken and that all tests are passing before merging to the main branch.

With a reliable Continuous Integration pipeline, where the main branch always contains stable versions of the code, you can achieve Continuous Delivery.

## Continuous Delivery

Continuous Delivery is the practice of delivering working software in short cycles, usually several times a week or a day. “Working software” means reliable builds that can be released to customers at any time.

The goal is to deploy working app versions to the broader team as often as possible, improving the communication and collaboration with the business as they don’t have to wait months to see and interact with the current state of the app.

For that, the codebase needs to always be in a releasable state, where all tests are passing, and there are no broken features. Which means ‘unfinished’ or ‘not ready to ship’ features can be hidden behind feature flags.

The team can produce builds every time there’s new code merged to the main branch. This build can be sent to QA and stakeholders, for example.

A Continuous Delivery workflow allows your team to continually deliver value to your stakeholders and customers as it eliminates long waiting periods.

In Continuous Delivery, the whole process of generating and uploading a build can also be automated. But approving the build and pushing it to production is done manually.

Once a build is approved by the business, it can be manually pushed to production. But pushing to production should be as simple as pressing a button because the build should always be ready to ship.

Going a step further, the team can achieve Continuous Deployment by eliminating the need for manual approvals.

## Continuous Deployment
Continuous Deployment is the practice of automatically approving and pushing builds to production as long as it passes all tests. The team needs to build a lot of confidence in the development process to eliminate the need for manual testing and approval, but it can be done by following practices you’ve been learning in this course such as excellent communication, clear requirements, Test-Driven Development, and supple software design.

Teams that achieve Continuous Deployment can more rapidly deliver value to customers and adapt to market changes, which is a huge advantage against competitors.

## Continuous Delivery in Apple’s ecosystem
Like you can create an automated Continuous Integration workflow to build and test your codebase before merging code, you can also automate the build and deploy of your apps in a Continuous Delivery workflow.

##
References
Prepare for app distribution https://help.apple.com/xcode/mac/current/#/dev91fe7130a
TestFlight overview https://help.apple.com/app-store-connect/#/devdc42b26b8
Uploading builds overview https://help.apple.com/app-store-connect/#/dev82a6a9d79
Add an App Store icon to your project https://help.apple.com/xcode/mac/current/#/dev4b0ebb1bb
Export compliance overview https://help.apple.com/app-store-connect/#/dev88f5c7bf9
App signing guide https://help.apple.com/xcode/mac/current/#/dev3a05256b8
Complying with encryption export regulations https://developer.apple.com/documentation/security/complying_with_encryption_export_regulations
UIWindow reference https://developer.apple.com/documentation/uikit/uiwindow
Migrating to Swift 5.2 and CI with GitHub Actions https://www.essentialdeveloper.com/articles/s02e21-migrating-to-swift-5-2-and-ci-with-github-actions-professional-ios-engineering-series
GitHub Actions: Configuring and managing workflows https://help.github.com/en/actions/configuring-and-managing-workflows
GitHub Actions: Creating and Storing Encrypted Secrets https://help.github.com/en/actions/configuring-and-managing-workflows/creating-and-storing-encrypted-secrets
fastlane documentation https://docs.fastlane.tools

## You can achieve this wioth any build server. (may be local or a remote server eg. CircleCI, Travis CI, Bitrise)

## Github actions.

## WORKFLOWS

So we have continuous Integration workflows that just build and test application.
and we have a deploy workflow just a 'YAML' config file to tell github actions the steps to follow in your workflow automation

## Deploy.YAML

So in current implementation every time their is a push to master. we are going to run this work flow.
we want to create a build and upload it to App storeConnect.

## But it depends on the branching statergy you use. May be you choose to do the same with a release branch.


So every time we push to master we are gonna run 
## build-and-deploy job.

1. so it's gonna run on mac-os.

## then we set the steps for the workflow
1. Checkout the repo.
2. Install Provisioning profile.
    we need to decrypt it with our secret key, their you can setup whatever build server you are using. you have space to add secrets.
    after we decrypt it we can install it in the right folder.
3. Then same thing we need to install the keychain certificate.
    we can decrypt with the secret key.
    and follow a bunch of steps to install the certificate in the image keychain.
4. Then we are going to select the latest x-code.
5. then we nned to set build number and its need to be sequential unique number. Every build needs to have a unique number otherwise apple will reject it.
    So we are just using the GITHUB_RUN_NUMBER and every build server have something similar to this.
6. Then we build the archieve for release.
7. Then we export the archieve.
8. And we Deploy it to the app store connect. 

    
 
