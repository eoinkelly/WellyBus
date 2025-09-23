import SwiftUI

struct SettingsRouteListItemView: View {
  @Bindable var route: BusRoute2

  var body: some View {
    VStack(alignment: .leading, spacing: 4) {
      HStack {
        Text(route.routeName)
          .font(.headline)
        Spacer()
        Toggle("Priority", isOn: $route.isPriorityRoute)
          .labelsHidden()
        // TODO: i need to save the route if this changes
      }
    }
  }
}
