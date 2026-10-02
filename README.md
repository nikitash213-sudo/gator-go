# GatorGo

GatorGo is an SFSU student mobility and resource-discovery app concept designed to help students find affordable transit options, campus opportunities, and nearby benefits.

## Project structure

- `GatorGoTestApp/` — SwiftUI iOS prototype
- `gatorgo-backend/` — Firebase + Google Cloud Functions API

## Frontend

The iOS prototype is a SwiftUI starter app that can be opened in Xcode and connected to the backend by setting the API base URL in `GatorGoTestApp/GatorGoTestApp/Config.swift`.

## Backend

The backend is a Firebase Cloud Functions API with:

- Firebase Firestore
- Firebase Auth
- Gemini-powered recommendations
- endpoints for resources and landmark claims

The backend is stored in `gatorgo-backend/` and is designed to be called from the iOS app once the Firebase project ID is configured.

## Quick start

1. Configure your Firebase project in `gatorgo-backend/.firebaserc`
2. Update the API URL in `GatorGoTestApp/GatorGoTestApp/Config.swift`
3. Open the SwiftUI app in Xcode and run it
4. If needed, deploy the backend with Firebase CLI and connect the app to the deployed URL

## Current status

- SwiftUI UI prototype exists
- Firebase backend API exists and compiles successfully
- app + backend are wired by configuration, not by a hardcoded production endpoint
