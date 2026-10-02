import SwiftUI

@MainActor
final class AskGatorGoViewModel: ObservableObject {
    @Published var query = ""
    @Published var response: RecommendationResponse?
    @Published var isLoading = false
    @Published var errorMessage: String?

    func ask() async {
        let clean = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard clean.count >= 2 else { return }
        isLoading = true
        defer { isLoading = false }
        do { response = try await BackendAPI.shared.recommend(query: clean) }
        catch { errorMessage = error.localizedDescription }
    }
}

struct AskGatorGoView: View {
    @StateObject private var model = AskGatorGoViewModel()

    var body: some View {
        ScrollView {
            VStack(spacing: 18) {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "sparkles").foregroundStyle(GatorTheme.green)
                        Text("Ask naturally").font(.headline)
                    }
                    Text("Try: “I need to be on campus by 9 and want the cheapest reasonable option.”")
                        .font(.subheadline).foregroundStyle(.secondary)
                    TextField("What do you need?", text: $model.query, axis: .vertical)
                        .textFieldStyle(.roundedBorder)
                        .lineLimit(3...6)
                    Button {
                        Task { await model.ask() }
                    } label: {
                        HStack {
                            if model.isLoading { ProgressView().tint(.white) }
                            Text(model.isLoading ? "Thinking…" : "Ask GatorGo")
                            Spacer()
                            Image(systemName: "arrow.right")
                        }
                        .fontWeight(.semibold)
                        .padding()
                        .foregroundStyle(.white)
                        .background(GatorTheme.brandGradient, in: RoundedRectangle(cornerRadius: 15))
                    }
                    .disabled(model.isLoading || model.query.trimmingCharacters(in: .whitespacesAndNewlines).count < 2)
                }
                .gatorCard()

                if let response = model.response {
                    VStack(alignment: .leading, spacing: 12) {
                        Label("GatorGo plan", systemImage: "checkmark.seal.fill")
                            .font(.title3.bold()).foregroundStyle(GatorTheme.purple)
                        Text(response.summary)
                        ForEach(response.recommendations) { recommendation in
                            VStack(alignment: .leading, spacing: 5) {
                                Text(recommendation.reason).font(.subheadline)
                                Label(recommendation.nextStep, systemImage: "arrow.right.circle.fill")
                                    .font(.caption.bold())
                                    .foregroundStyle(GatorTheme.green)
                            }
                        }
                        if !response.caveats.isEmpty {
                            Divider()
                            ForEach(response.caveats, id: \.self) { caveat in
                                Label(caveat, systemImage: "info.circle")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                    .gatorCard()

                    if !response.resources.isEmpty {
                        SectionHeader(title: "Sources used", subtitle: "These records were retrieved before Gemini generated the explanation.")
                        ForEach(response.resources) { item in
                            VStack(alignment: .leading, spacing: 6) {
                                Text(item.name).font(.headline)
                                Text(item.description).font(.subheadline).foregroundStyle(.secondary)
                                if let url = URL(string: item.sourceUrl) {
                                    Link("Open source", destination: url).font(.caption.bold())
                                }
                            }
                            .gatorCard()
                        }
                    }
                }
            }
            .padding()
        }
        .background(GatorTheme.background)
        .navigationTitle("Ask GatorGo")
        .alert("GatorGo couldn't answer", isPresented: .constant(model.errorMessage != nil)) {
            Button("OK") { model.errorMessage = nil }
        } message: { Text(model.errorMessage ?? "") }
    }
}
