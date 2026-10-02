# GatorGo SwiftUI Frontend

Drop the `GatorGo` folder into the existing Xcode project.

## Requirements
- iOS 17+
- SwiftUI
- MapKit
- Firebase iOS SDK packages: FirebaseCore, FirebaseAuth
- Existing Firebase `GoogleService-Info.plist`

## 1. Configure the backend URL
Edit `GatorGo/App/AppConfig.swift` and replace `YOUR_PROJECT_ID`.

Local emulator:
`http://127.0.0.1:5001/YOUR_PROJECT_ID/us-west1/api`

Production:
`https://us-west1-YOUR_PROJECT_ID.cloudfunctions.net/api`

Set `useFirebaseEmulators = false` for production.

## 2. Add the supplied logo
Export the Google Drawing as a PNG (transparent background works best). In Xcode:
1. Open Assets.xcassets.
2. Add a new Image Set named `GatorGoLogo`.
3. Drag the exported logo into the set.

`BrandLogoView` uses this bundled image first. It also has the supplied Google Drawing URL as a temporary development fallback.

## 3. Info.plist location permission
Add:
`Privacy - Location When In Use Usage Description`
Value example: `GatorGo uses your location only when you choose to verify a nearby landmark or plan from your current location.`

## 4. Firebase Auth
The sample automatically signs in anonymously for the hackathon demo. Enable Anonymous Authentication in Firebase Console > Authentication > Sign-in method.

If you already have a full login screen, remove the automatic `signInForDemo()` call in `SessionStore`.

## 5. Test
Start the backend emulators, run the iOS Simulator, then verify:
- Home loads
- Resources displays Firestore seed records
- Ask GatorGo returns a grounded response
- Plan Trip receives MapKit routes and sends them to `/ai/recommend`
- Landmark map displays records and Claim calls the authenticated backend endpoint

## Notes
The sample uses MapKit. You can replace `PlanTripView` and `LandmarksView` map rendering with Google Maps SDK later without changing the backend API layer.
