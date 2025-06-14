import SwiftUI

struct SettingsEditStopView: View {
  @Environment(\.modelContext) private var modelContext
  @Environment(\.dismiss) private var dismiss

  @Bindable var stop: BusStop2
  @State private var isAddingRoute = false

  var body: some View {
    Form {
      Section("Stop Details") {
        TextField("Stop Name", text: $stop.name)
        TextField("Nickname", text: $stop.nickname)
      }

      Section("Routes") {
        ForEach(stop.routes) { departure in
          SettingsRouteListItemView(route: departure)
        }
        .onDelete { indices in
          for index in indices {
            stop.routes.remove(at: index)
          }
        }

        Button("Add Route") {
          isAddingRoute = true
        }
      }
    }
    .navigationTitle("Edit Bus Stop")
    .navigationBarTitleDisplayMode(.inline)
    .toolbar {
      ToolbarItem(placement: .navigationBarTrailing) {
        Button("Done") {
          dismiss()
        }
      }
    }
    .sheet(isPresented: $isAddingRoute) {
      SettingsAddRouteView(stop: stop)
    }
  }
}
