# GatorGo Backend

Firebase/Google Cloud backend for the GatorGo SFSU student mobility and resource-discovery prototype.

## Stack
- Cloud Functions for Firebase (2nd gen), Node.js 22 + TypeScript
- Cloud Firestore
- Firebase Authentication
- Gemini API via `@google/genai`
- SwiftUI client calls a single HTTPS function: `api`

## API
Base URL after deploy:
`https://<region>-<project-id>.cloudfunctions.net/api`

### Public
- `GET /health`
- `GET /resources?category=transportation&q=cheap`
- `GET /landmarks`
- `POST /ai/recommend` (auth optional)

### Authenticated
Send `Authorization: Bearer <Firebase ID token>`.
- `GET /users/me`
- `PATCH /users/me`
- `POST /landmarks/:id/claim` body `{ "latitude": ..., "longitude": ... }`
- `GET /landmarks/me/claims`

## AI grounding
`POST /ai/recommend` retrieves known Firestore resources first. Optional route candidates can be supplied by the SwiftUI client after MapKit/Google Maps routing. Gemini receives only those candidates. The server filters the model response so returned IDs must exist in the provided candidate set.

Example request:
```json
{
  "query": "I need to get to campus cheaply and want something free to do afterward",
  "routes": [
    { "id": "route-1", "mode": "transit", "durationMinutes": 32, "estimatedCost": "$2.50", "transfers": 1, "source": "MapKit" }
  ]
}
```

## Setup
1. Install Firebase CLI and authenticate: `npm install -g firebase-tools && firebase login`.
2. Create/select a Firebase project, enable Firestore and Firebase Authentication.
3. Replace `YOUR_FIREBASE_PROJECT_ID` in `.firebaserc`.
4. In `functions/`, run `npm install`.
5. Copy `.env.example` to `.env` for local emulation and set `GEMINI_API_KEY`.
6. Run `npm run build`.
7. From project root run `firebase emulators:start`.
8. Deploy with `firebase deploy --only functions,firestore`.

For production, store the Gemini key as a managed secret rather than committing an `.env` file. The API key should never be embedded in the SwiftUI app.

## Firestore collections
- `users/{uid}` — profile/preferences
- `resources/{resourceId}` — verified student resources
- `landmarks/{landmarkId}` — claimable locations
- `collections/{collectionId}` — landmark groups
- `landmarkClaims/{uid_landmarkId}` — minimal proximity claim metadata
- `aiInteractions/{id}` — query, retrieved record IDs, grounded response, model metadata

## SwiftUI auth call pattern
1. Sign in with Firebase Auth.
2. Call `getIDToken()`.
3. Set HTTP header `Authorization: Bearer <token>`.
4. Decode returned JSON using `Codable` models.

## Next integrations
- MapKit or Google Maps can stay primarily client-side for routing during the hackathon.
- If you add Google Routes API server-side, create a `routes` service and feed normalized route candidates into `/ai/recommend`.
- Add admin-only endpoints/custom claims if campus coordinators will maintain resource data through an admin UI.
