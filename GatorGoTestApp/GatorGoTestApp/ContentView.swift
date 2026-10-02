import SwiftUI

struct ContentView: View {
    @StateObject private var backendService = BackendService()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    Image(systemName: "bus.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 72, height: 72)
                        .foregroundStyle(.blue)

                    Text("GatorGo")
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    Text("SFSU commute + student resources")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)

                    VStack(alignment: .leading, spacing: 12) {
                        FeatureRow(icon: "map.fill", title: "Commute", detail: "Find routes to SFSU and nearby places")
                        FeatureRow(icon: "gift.fill", title: "Student Discounts", detail: "Discover free and affordable opportunities")
                        FeatureRow(icon: "sparkles", title: "Gemini AI", detail: "Ask about transit and campus resources")
                        FeatureRow(icon: "star.fill", title: "Landmarks", detail: "Claim campus landmarks and earn rewards")
                    }
                    .padding()
                    .frame(maxWidth: 360)
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Backend status")
                            .font(.headline)

                        Text(backendService.statusText)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)

                        if let error = backendService.errorMessage {
                            Text(error)
                                .font(.caption)
                                .foregroundStyle(.red)
                        }
                    }
                    .frame(maxWidth: 360, alignment: .leading)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))

                    if !backendService.resources.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Sample resources")
                                .font(.headline)

                            ForEach(backendService.resources.prefix(3)) { resource in
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(resource.name)
                                        .font(.headline)
                                    Text(resource.category)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                    Text(resource.description)
                                        .font(.subheadline)
                                }
                                .padding(.vertical, 6)
                            }
                        }
                        .frame(maxWidth: 360, alignment: .leading)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                    }

                    Button {
                        Task {
                            await backendService.load()
                        }
                    } label: {
                        Label("Refresh backend", systemImage: "arrow.triangle.2.circlepath")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .foregroundStyle(.white)
                            .background(Color.blue)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .padding(.horizontal)
                }
                .padding()
            }
            .navigationTitle("Home")
            .task {
                await backendService.load()
            }
        }
    }
}

struct FeatureRow: View {
    let icon: String
    let title: String
    let detail: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .frame(width: 28, height: 28)
                .foregroundStyle(.blue)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                Text(detail)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    ContentView()
}
