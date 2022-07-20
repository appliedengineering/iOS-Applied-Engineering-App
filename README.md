# iOS-Applied-Engineering-App
 Source code for the iOS Applied Engineering App.
 
# XCode setup
- After cloning, you must generate your own xcode project that will be specific to your computer
- Before continuing, you must first make sure you have [Brew](https://brew.sh/) and [Cocoapods](https://cocoapods.org/) installed.
- Afterwards, make sure you install [xcodegen](https://github.com/yonaskolb/XcodeGen/) by running this command in the terminal: `brew install xcodegen`.
- Next, run these commands in order:
1. `cd .../iOS-Applied-Engineering-App/Applied Engineering/`
2. `xcodegen` (this should generate a `.xcodeproj` file. **DO NOT OPEN IT**)
3. `pod install` (this should generate a `.xcworkspace`)
- Now, open the generated `.xcworkspace` file.

 - Make sure to select the `Applied Engineering` target on the top bar.
 - Now, click on the `Applied Engineering` project (as opposed to the `Pods` project)
 
 -  Under the "Signing & Capabilities" tab, make sure to sign into our shared Apple developer account via our Apple ID.
 
 - Now, make a selection for a team. Select "Arcadia Unified School District"
 
 -  You should now be all set up and ready to compile the app!
 
 Tip: if you pull a commit that has either added or deleted a file and that file change is not shown in xcode, all you have to do is rerun `xcodegen` and `pod install` again. However, make sure you are in this directory: `.../iOS-Applied-Engineering-App/Applied Engineering/`.
