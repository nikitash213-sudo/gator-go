import SwiftUI
import MapKit

@MainActor
final class LandmarksViewModel: ObservableObject {
    @Published var landmarks: [Landmark] = []
    @Published var claimedIDs: Set<String> = []
    @Published var errorMessage: String?

    func load() async {
        do { landmarks = try await BackendAPI.shared.landmarks() }
        catch { errorMessage = error.localizedDescription }
    }

    func claim(_ landmark: Landmark, using location: CLLocation?) async {
        guard let location else {
            errorMessage = "Location is needed to verify a landmark claim."
            return
        }
        do {
            let result = try await BackendAPI.shared.claimLandmark(
                id: landmark.id,
                latitude: location.coordinate.latitude,
                longitude: location.coordinate.longitude
            )
            if result.claimed { claimedIDs.insert(landmark.id) }
        } catch { errorMessage = error.localizedDescription }
    }
}

struct LandmarksView: View {
    @StateObject private var model = LandmarksViewModel()
    @StateObject private var location = LocationService()
    @State private var position: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 37.7219, longitude: -122.4782),
            span: MKCoordinateSpan(latitudeDelta: 0.08, longitudeDelta: 0.08)
        )
    )

    var body: some View {
        ScrollView {
            VStack(spacing: 18) {
                Map(position: $position) {
                    UserAnnotation()
                    ForEach(model.landmarks) { landmark in
                        Marker(landmark.name, coordinate: landmark.coordinate)
                            .tint(model.claimedIDs.contains(landmark.id) ? GatorTheme.green : GatorTheme.purple)
                    }
                }
                .frame(height: 310)
                .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))

                SectionHeader(title: "Landmark collection", subtitle: "Claim a place only when you are physically nearby.")

                ForEach(model.landmarks) { landmark in
                    HStack(alignment: .top, spacing: 14) {
                        Image(systemName: model.claimedIDs.contains(landmark.id) ? "checkmark.seal.fill" : "mappin.circle.fill")
                            .font(.title2)
                            .foregroundStyle(model.claimedIDs.contains(landmark.id) ? GatorTheme.green : GatorTheme.purple)
                        VStack(alignment: .leading, spacing: 5) {
                            Text(landmark.name).font(.headline)
                            Text(landmark.description).font(.subheadline).foregroundStyle(.secondary)
                            Text(landmark.category).font(.caption.bold()).foregroundStyle(GatorTheme.green)
                        }
                        Spacer()
                        Button(model.claimedIDs.contains(landmark.id) ? "Claimed" : "Claim") {
                            location.requestLocation()
                            Task { await model.claim(landmark, using: location.location) }
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(GatorTheme.purple)
                        .disabled(model.claimedIDs.contains(landmark.id))
                    }
                    .gatorCard()
                }
            }
            .padding()
        }
        .background(GatorTheme.background)
        .navigationTitle("Explore")
        .task {
            location.requestLocation()
            await model.load()
        }
        .alert("Landmark claim", isPresented: .constant(model.errorMessage != nil)) {
            Button("OK") { model.errorMessage = nil }
        } message: { Text(model.errorMessage ?? "") }
    }
}
