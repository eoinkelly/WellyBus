import SwiftUI

struct LastUpdateView: View {
  @Binding var lastUpdatedAt: Date
  @Binding var refreshInProgress: Bool

  var body: some View {
    HStack(alignment: .center, spacing: 4) {
      Text("Last refresh:")
        .font(.caption)

      if refreshInProgress {
        Text("...")
          .font(.caption)
      } else {
        Text(lastUpdatedAt, style: .relative)
          .font(.caption)
      }

      Text("ago")
        .font(.caption)
    }
    .frame(maxWidth: .infinity, alignment: .leading)
  }
}
