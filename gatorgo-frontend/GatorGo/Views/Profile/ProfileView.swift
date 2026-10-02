import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    @EnvironmentObject var session: SessionStore

    var body: some View {
        Form {
            Section {
                HStack(spacing: 14) {
                    Circle()
                        .fill(GatorTheme.brandGradient)
                        .frame(width: 54, height: 54)
                        .overlay(Image(systemName: "person.fill").foregroundStyle(.white))
                    VStack(alignment: .leading) {
                        Text("GatorGo Student").font(.headline)
                        Text(session.user?.isAnonymous == true ? "Demo account" : session.user?.email ?? "Signed in")
                            .font(.caption).foregroundStyle(.secondary)
                    }
                }
            }
            Section("Privacy") {
                Label("Landmark claims use location only when you tap Claim.", systemImage: "location.shield.fill")
                Label("AI suggestions are grounded in retrieved app data.", systemImage: "checkmark.shield.fill")
            }
            Section {
                Button("Sign Out", role: .destructive) { session.signOut() }
            }
        }
        .navigationTitle("Profile")
    }
}
