import SwiftUI

struct HomeView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 22) {
                ZStack(alignment: .bottomLeading) {
                    RoundedRectangle(cornerRadius: 28, style: .continuous)
                        .fill(GatorTheme.brandGradient)
                        .frame(height: 220)

                    VStack(alignment: .leading, spacing: 12) {
                        BrandLogoView(height: 64)
                        Text("Move smarter. Discover more.")
                            .font(.title2.bold())
                            .foregroundStyle(.white)
                        Text("Transit, student resources, and SF experiences — in one place.")
                            .foregroundStyle(.white.opacity(0.9))
                    }
                    .padding(22)
                }

                SectionHeader(title: "What do you need?", subtitle: "Start with a goal and GatorGo will help you get there.")

                LazyVGrid(columns: [.init(.flexible()), .init(.flexible())], spacing: 14) {
                    NavigationLink { PlanTripView() } label: {
                        QuickAction(icon: "arrow.triangle.turn.up.right.diamond.fill", title: "Plan a Trip", subtitle: "Compare routes", tint: GatorTheme.purple)
                    }
                    NavigationLink { AskGatorGoView() } label: {
                        QuickAction(icon: "sparkles", title: "Ask GatorGo", subtitle: "Get a grounded plan", tint: GatorTheme.green)
                    }
                    NavigationLink { ResourcesView() } label: {
                        QuickAction(icon: "tag.fill", title: "Resources", subtitle: "Discounts & programs", tint: GatorTheme.gold)
                    }
                    NavigationLink { LandmarksView() } label: {
                        QuickAction(icon: "mappin.circle.fill", title: "Landmarks", subtitle: "Explore & collect", tint: GatorTheme.brightGreen)
                    }
                }

                VStack(alignment: .leading, spacing: 10) {
                    Label("Built for SFSU students", systemImage: "graduationcap.fill")
                        .font(.headline)
                        .foregroundStyle(GatorTheme.purple)
                    Text("Recommendations are based on retrieved route and resource data. Check the source and freshness details before acting on time-sensitive information.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .gatorCard()
            }
            .padding()
        }
        .background(GatorTheme.background)
        .navigationTitle("GatorGo")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink { ProfileView() } label: {
                    Image(systemName: "person.crop.circle")
                }
                .accessibilityLabel("Profile")
            }
        }
    }
}

private struct QuickAction: View {
    let icon: String
    let title: String
    let subtitle: String
    let tint: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(tint)
                .frame(width: 42, height: 42)
                .background(tint.opacity(0.12), in: RoundedRectangle(cornerRadius: 12))
            Text(title).font(.headline).foregroundStyle(.primary)
            Text(subtitle).font(.caption).foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, minHeight: 130, alignment: .leading)
        .gatorCard()
    }
}
