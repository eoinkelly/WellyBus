import SwiftUI

struct LastUpdateView: View {
  @Binding var lastUpdatedAt: Date
  @Binding var refreshInProgress: Bool

  var body: some View {
    HStack(alignment: .center, spacing: 4) {
      Text("Last update:")
        .font(.caption)
        .fontWeight(.semibold)

      if refreshInProgress {
        Text("...")
          .font(.caption)
      } else {
        Image(systemName: "timer")
          .imageScale(.small)
        Text(lastUpdatedAt, style: .timer)
          .font(.caption)
      }
    }
  }
}
