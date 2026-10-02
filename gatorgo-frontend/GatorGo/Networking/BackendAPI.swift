import Foundation
import FirebaseAuth

@MainActor
final class BackendAPI: ObservableObject {
    static let shared = BackendAPI()
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()

    enum APIError: LocalizedError {
        case invalidResponse
        case server(Int, String)
        case noLocation

        var errorDescription: String? {
            switch self {
            case .invalidResponse: return "The server returned an invalid response."
            case .server(let code, let message): return "Server error \(code): \(message)"
            case .noLocation: return "Your current location is unavailable."
            }
        }
    }

    func health() async throws -> Bool {
        let data: HealthResponse = try await request(path: "/health")
        return data.ok
    }

    func resources(query: String? = nil, category: String? = nil) async throws -> [ResourceItem] {
        var components = URLComponents(url: AppConfig.apiBaseURL.appendingPathComponent("resources"), resolvingAgainstBaseURL: false)!
        var items: [URLQueryItem] = []
        if let query, !query.isEmpty { items.append(.init(name: "q", value: query)) }
        if let category, !category.isEmpty { items.append(.init(name: "category", value: category)) }
        components.queryItems = items.isEmpty ? nil : items
        let response: ResourceResponse = try await request(url: components.url!)
        return response.resources
    }

    func landmarks() async throws -> [Landmark] {
        let response: LandmarkResponse = try await request(path: "/landmarks")
        return response.landmarks
    }

    func claimLandmark(id: String, latitude: Double, longitude: Double) async throws -> LandmarkClaimResponse {
        try await request(
            path: "/landmarks/\(id)/claim",
            method: "POST",
            body: ["latitude": latitude, "longitude": longitude],
            authenticated: true
        )
    }

    func recommend(query: String, category: String? = nil, routes: [RouteCandidate] = []) async throws -> RecommendationResponse {
        let body = RecommendationRequest(
            query: query,
            category: category,
            routes: routes.isEmpty ? nil : routes
        )
        return try await request(path: "/ai/recommend", method: "POST", encodableBody: body, authenticated: false)
    }

    func userProfile() async throws -> UserProfile {
        try await request(path: "/users/me", authenticated: true)
    }

    private struct HealthResponse: Codable { let ok: Bool }

    private func request<T: Decodable>(
        path: String,
        method: String = "GET",
        body: [String: Double]? = nil,
        authenticated: Bool = false
    ) async throws -> T {
        let url = AppConfig.apiBaseURL.appendingPathComponent(path.trimmingCharacters(in: CharacterSet(charactersIn: "/")))
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let body { request.httpBody = try JSONSerialization.data(withJSONObject: body) }
        if authenticated { try await attachToken(to: &request) }
        return try await perform(request)
    }

    private func request<T: Decodable, B: Encodable>(
        path: String,
        method: String,
        encodableBody: B,
        authenticated: Bool
    ) async throws -> T {
        let url = AppConfig.apiBaseURL.appendingPathComponent(path.trimmingCharacters(in: CharacterSet(charactersIn: "/")))
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try encoder.encode(encodableBody)
        if authenticated { try await attachToken(to: &request) }
        return try await perform(request)
    }

    private func request<T: Decodable>(url: URL) async throws -> T {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return try await perform(request)
    }

    private func attachToken(to request: inout URLRequest) async throws {
        guard let user = Auth.auth().currentUser else { throw APIError.server(401, "Not signed in") }
        let token = try await user.getIDToken()
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    }

    private func perform<T: Decodable>(_ request: URLRequest) async throws -> T {
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let http = response as? HTTPURLResponse else { throw APIError.invalidResponse }
        guard 200..<300 ~= http.statusCode else {
            let text = String(data: data, encoding: .utf8) ?? "Unknown error"
            throw APIError.server(http.statusCode, text)
        }
        return try decoder.decode(T.self, from: data)
    }
}
