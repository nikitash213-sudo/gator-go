import Foundation

enum GatorGoConfig {
    static let apiBaseURL: String = {
        if let env = ProcessInfo.processInfo.environment["GATORGO_API_BASE_URL"], !env.isEmpty {
            return env
        }
        return "http://127.0.0.1:5001/YOUR_FIREBASE_PROJECT_ID/us-west1/api"
    }()
}
