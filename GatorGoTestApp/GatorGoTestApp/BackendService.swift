import Foundation

struct HealthResponse: Decodable {
    let ok: Bool
    let service: String
}

struct ResourceItem: Decodable, Identifiable {
    let id: String
    let name: String
    let category: String
    let description: String
    let eligibility: String?
    let isActive: Bool?
}

struct ResourcesResponse: Decodable {
    let resources: [ResourceItem]
}

@MainActor
final class BackendService: ObservableObject {
    @Published var statusText: String = "Waiting for backend..."
    @Published var resources: [ResourceItem] = []
    @Published var errorMessage: String?

    func load() async {
        guard GatorGoConfig.apiBaseURL.contains("YOUR_FIREBASE_PROJECT_ID") == false else {
            statusText = "Backend not configured yet"
            errorMessage = "Set your Firebase project ID in GatorGoConfig.apiBaseURL"
            return
        }

        do {
            let health = try await fetchHealth()
            statusText = health.ok ? "Connected: \(health.service)" : "Backend responded but is unhealthy"

            let response = try await fetchResources()
            resources = response.resources
            errorMessage = nil
        } catch {
            statusText = "Backend unavailable"
            errorMessage = error.localizedDescription
        }
    }

    private func fetchHealth() async throws -> HealthResponse {
        let url = URL(string: "\(GatorGoConfig.apiBaseURL)/health")!
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(HealthResponse.self, from: data)
    }

    private func fetchResources() async throws -> ResourcesResponse {
        let url = URL(string: "\(GatorGoConfig.apiBaseURL)/resources?category=transportation")!
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(ResourcesResponse.self, from: data)
    }
}
