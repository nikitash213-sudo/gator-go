import Foundation
import FirebaseAuth

@MainActor
final class SessionStore: ObservableObject {
    @Published var user: User?
    @Published var isReady = false
    @Published var errorMessage: String?

    private var handle: AuthStateDidChangeListenerHandle?

    func start() {
        if AppConfig.useFirebaseEmulators {
            Auth.auth().useEmulator(withHost: AppConfig.authEmulatorHost, port: AppConfig.authEmulatorPort)
        }
        handle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            Task { @MainActor in
                self?.user = user
                self?.isReady = true
            }
        }
        if Auth.auth().currentUser == nil {
            Task { await signInForDemo() }
        }
    }

    func signInForDemo() async {
        do {
            _ = try await Auth.auth().signInAnonymously()
        } catch {
            errorMessage = error.localizedDescription
            isReady = true
        }
    }

    func signOut() {
        try? Auth.auth().signOut()
    }
}
