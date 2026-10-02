import Foundation
import CoreLocation

struct ResourceItem: Codable, Identifiable, Hashable {
    let id: String
    let name: String
    let description: String
    let category: String
    let costLabel: String?
    let eligibility: String?
    let locationName: String?
    let latitude: Double?
    let longitude: Double?
    let sourceUrl: String
    let sourceName: String?
    let lastVerifiedAt: String?
    let expiresAt: String?
    let isActive: Bool
    let tags: [String]?
}

struct ResourceResponse: Codable { let resources: [ResourceItem] }

struct Landmark: Codable, Identifiable, Hashable {
    let id: String
    let name: String
    let description: String
    let latitude: Double
    let longitude: Double
    let claimRadiusM: Double
    let category: String
    let collectionIds: [String]
    let isActive: Bool

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

struct LandmarkResponse: Codable { let landmarks: [Landmark] }

struct LandmarkClaimResponse: Codable {
    let claimed: Bool
    let landmarkId: String
    let distanceM: Int
}

struct RouteCandidate: Codable, Identifiable, Hashable {
    let id: String
    let mode: String
    let durationMinutes: Double?
    let estimatedCost: String?
    let transfers: Int?
    let walkingMinutes: Double?
    let summary: String?
    let source: String?
}

struct RecommendationRequest: Codable {
    let query: String
    let category: String?
    let routes: [RouteCandidate]?
}

struct AIRecommendation: Codable, Identifiable, Hashable {
    var id: String { "\(recordType)-\(recordId)" }
    let recordType: String
    let recordId: String
    let reason: String
    let tradeoffs: [String]
    let nextStep: String
}

struct RecommendationResponse: Codable {
    let interactionId: String
    let intent: String
    let summary: String
    let recommendations: [AIRecommendation]
    let caveats: [String]
    let resources: [ResourceItem]
}

struct UserProfile: Codable {
    let id: String
    let displayName: String?
    let preferences: UserPreferences?
}

struct UserPreferences: Codable {
    let budget: String?
    let accessibilityNotes: String?
    let interests: [String]?
}
