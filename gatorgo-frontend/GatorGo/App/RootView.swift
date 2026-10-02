import SwiftUI

struct RootView: View {
    @EnvironmentObject var session: SessionStore

    var body: some View {
        Group {
            if !session.isReady {
                VStack(spacing: 18) {
                    BrandLogoView(height: 80)
                    ProgressView("Starting GatorGo…")
                }
            } else {
                TabView {
                    NavigationStack { HomeView() }
                        .tabItem { Label("Home", systemImage: "house.fill") }

                    NavigationStack { PlanTripView() }
                        .tabItem { Label("Trips", systemImage: "map.fill") }

                    NavigationStack { ResourcesView() }
                        .tabItem { Label("Resources", systemImage: "sparkles") }

                    NavigationStack { AskGatorGoView() }
                        .tabItem { Label("Ask", systemImage: "bubble.left.and.bubble.right.fill") }

                    NavigationStack { LandmarksView() }
                        .tabItem { Label("Explore", systemImage: "mappin.and.ellipse") }
                }
            }
        }
    }
}
