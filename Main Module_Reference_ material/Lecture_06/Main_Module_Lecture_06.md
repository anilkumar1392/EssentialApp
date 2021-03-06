## Validating the UI with Snapshot Tests + Dark Mode Support (Snapshot testing)

// Idea is to render the user interface and take the snapshot.

Learning Outcomes
Validating the app’s UI with Snapshot Testing
Supporting Dark Mode
Rendering views without running the app

## Snapshot Testing
Snapshot testing is the process of recording a “snapshot” of parts of your system in order to compare them against previously recorded states.

A common use case for snapshot testing is validating the UI of an app. You can do so by rendering the desired view as an image, record/store the image, and retrieve later for asserting the UI hasn’t changed unexpectedly. The tests will then pass if the recorded state is the same as the received one, and they will fail if the two snapshots don’t match.

Some of the traits of snapshot testing are:

It allows you to easily review visuals on pull requests as you can store the snapshot artifacts in git.
They reveal visual bugs that other testing strategies won’t pick up easily (e.g., odd rendering in specific localizations).
They improve the collaboration with the design team as you can actually easily present them with visuals aids.
They allow you to automate the capturing of screenshots (e.g., for App Store Connect).
They offer a significantly more performant alternative for automating testing visuals than manual or UI testing.
Moreover, you can commit the snapshot artifacts to your git repository. Thus, everyone in the team will have access to them.

Finally, you can (and should) run the snapshot tests on the CI server, making it part of your QA process.

## File holds the path to the current file.

Ideally we should store the snapshot close to the test file. So we can use the current file path. 

## References
Human Interface Guidelines for Dark Mode https://developer.apple.com/design/human-interface-guidelines/ios/visual-design/dark-mode
UIGraphicsImageRenderer reference https://developer.apple.com/documentation/uikit/uigraphicsimagerenderer
UITraitCollection reference https://developer.apple.com/documentation/uikit/uitraitcollection
