import Foundation

enum AppConfig {
    // Emulator example:
    // http://127.0.0.1:5001/YOUR_PROJECT_ID/us-west1/api
    // Production example:
    // https://us-west1-YOUR_PROJECT_ID.cloudfunctions.net/api
    static let apiBaseURL = URL(string: "http://127.0.0.1:5001/YOUR_PROJECT_ID/us-west1/api")!

    static let useFirebaseEmulators = true
    static let authEmulatorHost = "127.0.0.1"
    static let authEmulatorPort = 9099
}
