## Xcode Walkthrough

Check apple documentation on XCode

Assistants.

1. Counterpart
2. Supercalsses
3. Extensions
4. callers 
5. Preprocesser


## Signing and Capabilities:

Provisiong profile: This is an abstract entity that connects app id's one and more signing certificates and the listed devices.

Provisiong profile is the center of connection between App id's, certificates and devices.

Signing Certificate: 
A certificate that is unique and is used to sign the binary 

## Resource Tags:

This are on demand resources downloaded only when needed does not embed into app bundle.

Particularly useful when you need big resource in your app but you do nto want to incerease your app size.

## Info:

this is pouplated with the setting from info P.list.

## Build Settings

A property you can apply to your Xcode targets to configure aspects how they are build.


while build or any other action The system must resolve all the build settings for each target that is build.
It uses a fallback based system, In this graphical representation and as well as in xcode.


So proirity decrease from left to right ot increase from right to left.
Resoved: The value that in the end will be used by the build.
target Settings: Explicit target settings that overrides any other target settings.

if we set TargetConfig File it overrides all the settings expect for the target on the left.
Project Settings explicit once: They are used when target settings are missing other wise they are overridden by target settings.

Refer Iamge: Build Settings 

## Build Phases: 

