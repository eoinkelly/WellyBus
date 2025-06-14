import SwiftUI

struct SettingsAddRouteView: View {
  @Environment(\.dismiss) private var dismiss
  @Bindable var stop: BusStop2

  @State private var routeName = ""
  @State private var isPriorityRoute = false

  var body: some View {
    NavigationStack {
      Form {
        TextField("Route Name", text: $routeName)
        //        DatePicker(
        //          "Departure Time", selection: $departureTime, displayedComponents: [.hourAndMinute])
        Toggle("Priority Route", isOn: $isPriorityRoute)
      }
      .navigationTitle("Add Route")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .cancellationAction) {
          Button("Cancel") {
            dismiss()
          }
        }
        ToolbarItem(placement: .confirmationAction) {
          Button("Add") {
            let newRoute = BusRoute2(
              routeName: routeName,
              isPriorityRoute: isPriorityRoute
            )
            stop.routes.append(newRoute)
            dismiss()
          }
          .disabled(routeName.isEmpty)
        }
      }
    }
  }
}
