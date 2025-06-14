import SwiftUI

struct SettingStopListItemView: View {
  let stop: BusStop2

  var body: some View {
    VStack(alignment: .leading, spacing: 4) {
      Text(stop.name)
        .font(.headline)

      if !stop.nickname.isEmpty {
        Text(stop.nickname)
          .font(.subheadline)
          .foregroundColor(.secondary)
      }

      Text("Routes: \(stop.routes.map(\.routeName).joined(separator: ", "))")
        .font(.caption)
        .foregroundColor(.secondary)
    }
  }
}
