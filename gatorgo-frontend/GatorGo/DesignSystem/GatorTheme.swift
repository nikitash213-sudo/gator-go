import SwiftUI

enum GatorTheme {
    static let purple = Color(red: 0.31, green: 0.18, blue: 0.55)
    static let deepPurple = Color(red: 0.20, green: 0.10, blue: 0.37)
    static let green = Color(red: 0.16, green: 0.50, blue: 0.34)
    static let brightGreen = Color(red: 0.31, green: 0.69, blue: 0.47)
    static let gold = Color(red: 0.95, green: 0.70, blue: 0.18)
    static let background = Color(uiColor: .systemGroupedBackground)
    static let card = Color(uiColor: .secondarySystemGroupedBackground)
    static let ink = Color.primary
    static let muted = Color.secondary

    static let brandGradient = LinearGradient(
        colors: [purple, green],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

struct GatorCardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(16)
            .background(GatorTheme.card)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(Color.primary.opacity(0.06), lineWidth: 1)
            }
    }
}

extension View {
    func gatorCard() -> some View { modifier(GatorCardModifier()) }
}
