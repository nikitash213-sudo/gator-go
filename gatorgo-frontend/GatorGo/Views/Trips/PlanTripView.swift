import SwiftUI
import MapKit

@MainActor
final class TripPlannerViewModel: ObservableObject {
    @Published var origin = "Current Location"
    @Published var destination = "San Francisco State University"
    @Published var routes: [RouteCandidate] = []
    @Published var recommendation: RecommendationResponse?
    @Published var isLoading = false
    @Published var errorMessage: String?

    func plan() async {
        isLoading = true
        defer { isLoading = false }
        do {
            let request = MKDirections.Request()
            request.source = try await mapItem(for: origin, currentLocationAllowed: true)
            request.destination = try await mapItem(for: destination, currentLocationAllowed: false)
            request.transportType = .transit
            request.requestsAlternateRoutes = true

            let result = try await MKDirections(request: request).calculate()
            routes = result.routes.enumerated().map { index, route in
                RouteCandidate(
                    id: "mapkit-\(index)",
                    mode: "transit",
                    durationMinutes: route.expectedTravelTime / 60,
                    estimatedCost: nil,
                    transfers: nil,
                    walkingMinutes: nil,
                    summary: route.name,
                    source: "MapKit"
                )
            }
            recommendation = try await BackendAPI.shared.recommend(
                query: "Compare these routes from \(origin) to \(destination). Prefer a practical affordable option and explain the tradeoffs.",
                routes: routes
            )
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func mapItem(for text: String, currentLocationAllowed: Bool) async throws -> MKMapItem {
        if currentLocationAllowed && text.lowercased().contains("current") {
            return MKMapItem.forCurrentLocation()
        }
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = text
        request.region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 37.7219, longitude: -122.4782),
            span: MKCoordinateSpan(latitudeDelta: 0.25, longitudeDelta: 0.25)
        )
        let result = try await MKLocalSearch(request: request).start()
        guard let item = result.mapItems.first else { throw URLError(.cannotFindHost) }
        return item
    }
}

struct PlanTripView: View {
    @StateObject private var model = TripPlannerViewModel()

    var body: some View {
        ScrollView {
            VStack(spacing: 18) {
                VStack(spacing: 12) {
                    locationField(icon: "circle.fill", label: "From", text: $model.origin, color: GatorTheme.green)
                    Divider()
                    locationField(icon: "mappin.circle.fill", label: "To", text: $model.destination, color: GatorTheme.purple)
                    Button {
                        Task { await model.plan() }
                    } label: {
                        Label(model.isLoading ? "Planning…" : "Find Routes", systemImage: "arrow.triangle.turn.up.right.diamond.fill")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .foregroundStyle(.white)
                            .background(GatorTheme.brandGradient, in: RoundedRectangle(cornerRadius: 15))
                    }
                    .disabled(model.isLoading)
                }
                .gatorCard()

                if !model.routes.isEmpty {
                    SectionHeader(title: "Route options", subtitle: "Live route candidates from MapKit")
                    ForEach(model.routes) { route in
                        HStack(spacing: 14) {
                            Image(systemName: "tram.fill")
                                .font(.title2).foregroundStyle(GatorTheme.purple)
                                .frame(width: 44, height: 44)
                                .background(GatorTheme.purple.opacity(0.12), in: RoundedRectangle(cornerRadius: 12))
                            VStack(alignment: .leading, spacing: 3) {
                                Text(route.summary ?? "Transit route").font(.headline)
                                if let mins = route.durationMinutes {
                                    Text("About \(Int(mins.rounded())) min · MapKit")
                                        .font(.subheadline).foregroundStyle(.secondary)
                                }
                            }
                            Spacer()
                        }
                        .gatorCard()
                    }
                }

                if let text = model.recommendation?.summary {
                    VStack(alignment: .leading, spacing: 10) {
                        Label("AI comparison", systemImage: "sparkles")
                            .font(.headline).foregroundStyle(GatorTheme.green)
                        Text(text)
                    }
                    .gatorCard()
                }
            }
            .padding()
        }
        .background(GatorTheme.background)
        .navigationTitle("Plan a Trip")
        .alert("Couldn't plan this trip", isPresented: .constant(model.errorMessage != nil)) {
            Button("OK") { model.errorMessage = nil }
        } message: { Text(model.errorMessage ?? "") }
    }

    private func locationField(icon: String, label: String, text: Binding<String>, color: Color) -> some View {
        HStack {
            Image(systemName: icon).foregroundStyle(color)
            VStack(alignment: .leading, spacing: 2) {
                Text(label).font(.caption).foregroundStyle(.secondary)
                TextField(label, text: text)
            }
        }
    }
}
