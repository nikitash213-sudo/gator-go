import SwiftUI
import UIKit

struct BrandLogoView: View {
    var height: CGFloat = 64

    // Development fallback. Export the supplied logo into Assets.xcassets as
    // "GatorGoLogo" for a production-safe bundled asset.
    private let remoteLogoURL = URL(string: "https://docs.google.com/drawings/u/0/d/1HAP4UiR-aMou-9Henpiami_Dcs2f1NTtKs0XgimZ8kM4A60S1n8xIfv96GRkZ8tcjJyPKlIFO9Neipt2fhrqcv4uOvVfXgVlFi1cewnl08GXzOaPak_2ug/image?w=624&h=345&rev=4&drawingRevisionAccessToken=cvP_vQYmrKXLXg&ac=1&fmt=png&parent=1-rgr3ipZyd1p4pERJcI9YINk7IUPLv3SZyjJdUsXzcs")

    var body: some View {
        Group {
            if let image = UIImage(named: "GatorGoLogo") {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            } else if let remoteLogoURL {
                AsyncImage(url: remoteLogoURL) { phase in
                    switch phase {
                    case .success(let image):
                        image.resizable().scaledToFit()
                    default:
                        fallback
                    }
                }
            } else {
                fallback
            }
        }
        .frame(height: height)
        .accessibilityLabel("GatorGo")
    }

    private var fallback: some View {
        HStack(spacing: 9) {
            Image(systemName: "figure.walk.motion")
                .font(.system(size: height * 0.45, weight: .bold))
            Text("GatorGo")
                .font(.system(size: height * 0.42, weight: .black, design: .rounded))
        }
        .foregroundStyle(GatorTheme.brandGradient)
    }
}
