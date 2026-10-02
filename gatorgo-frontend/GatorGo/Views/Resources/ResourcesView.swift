import SwiftUI

@MainActor
final class ResourcesViewModel: ObservableObject {
    @Published var resources: [ResourceItem] = []
    @Published var query = ""
    @Published var isLoading = false
    @Published var errorMessage: String?

    func load() async {
        isLoading = true
        defer { isLoading = false }
        do { resources = try await BackendAPI.shared.resources(query: query) }
        catch { errorMessage = error.localizedDescription }
    }
}

struct ResourcesView: View {
    @StateObject private var model = ResourcesViewModel()

    var body: some View {
        List {
            if model.isLoading { ProgressView().frame(maxWidth: .infinity) }
            ForEach(model.resources) { item in
                ResourceCard(item: item)
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
            }
        }
        .listStyle(.plain)
        .background(GatorTheme.background)
        .navigationTitle("Student Resources")
        .searchable(text: $model.query, prompt: "Transit, museums, food…")
        .onSubmit(of: .search) { Task { await model.load() } }
        .task { await model.load() }
        .refreshable { await model.load() }
        .alert("Couldn't load resources", isPresented: .constant(model.errorMessage != nil)) {
            Button("OK") { model.errorMessage = nil }
        } message: { Text(model.errorMessage ?? "") }
    }
}

private struct ResourceCard: View {
    let item: ResourceItem

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(item.category.uppercased())
                    .font(.caption2.bold())
                    .foregroundStyle(GatorTheme.green)
                Spacer()
                if let cost = item.costLabel {
                    Text(cost).font(.caption.bold()).foregroundStyle(GatorTheme.purple)
                }
            }
            Text(item.name).font(.headline)
            Text(item.description).font(.subheadline).foregroundStyle(.secondary)
            if let location = item.locationName {
                Label(location, systemImage: "mappin").font(.caption)
            }
            if let sourceURL = URL(string: item.sourceUrl) {
                Link(destination: sourceURL) {
                    Label("Verify at source", systemImage: "arrow.up.right.square")
                        .font(.caption.bold())
                }
            }
        }
        .gatorCard()
    }
}
