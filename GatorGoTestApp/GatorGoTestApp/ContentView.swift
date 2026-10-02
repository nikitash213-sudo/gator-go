import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
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

                Button {
                    // Replace with real navigation later
                } label: {
                    Label("Open Demo", systemImage: "arrow.right.circle.fill")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundStyle(.white)
                        .background(Color.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .padding(.horizontal)
            }
            .padding()
            .navigationTitle("Home")
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
