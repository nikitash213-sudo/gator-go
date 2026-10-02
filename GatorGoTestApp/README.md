# GatorGo Test App

This is a lightweight SwiftUI starter app for an iOS prototype of the SFSU commute and student resources project.

## Files

- `project.yml` – XcodeGen project definition
- `GatorGoTestApp/App.swift` – app entry point
- `GatorGoTestApp/ContentView.swift` – starter home screen
- `GatorGoTestApp/Info.plist` – minimal app config

## How to open it in Xcode

1. Install Xcode on your Mac.
2. Install XcodeGen if you want to generate the project automatically:
   `brew install xcodegen`
3. Run:
   `cd GatorGoTestApp`
   `xcodegen generate`
4. Open the generated `.xcodeproj` file in Xcode.
5. Select a simulator and run the app.

## What this version includes

- A simple landing screen
- SFSU-related app theme
- Feature cards for commute, discounts, AI, and landmarks
- A clean starting point to build the real app on top of

## Next steps

- Add a map screen for SFSU and nearby destinations
- Add student resources and neighborhood cards
- Connect Gemini for natural-language recommendations
- Add landmark claiming and reward badges
