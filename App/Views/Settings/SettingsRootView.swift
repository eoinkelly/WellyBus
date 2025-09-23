import SwiftData
import SwiftUI

struct SettingsRootView: View {
  @Environment(\.modelContext) private var modelContext
  @Environment(\.dismiss) var dismiss

  @Query(sort: \BusStop2.sortOrder) private var busStops: [BusStop2]

  @State private var isAddingNewStop = false

  var body: some View {
    NavigationStack {
      VStack {
        List {
          ForEach(busStops) { stop in
            NavigationLink(value: stop) {
              SettingStopListItemView(stop: stop)
            }
          }
          .onMove { indices, destination in
            var stops = busStops  // TODO: why need this?

            // Re-order `busStops` array in memory to match what the user just did in the UI
            stops.move(fromOffsets: indices, toOffset: destination)

            // Update the `sortOrder` attribute on each stop to save the new order to the DB
            for (index, stop) in stops.enumerated() {
              stop.sortOrder = index
            }
          }
          .onDelete { indices in
            for index in indices {
              modelContext.delete(busStops[index])
            }
          }
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
          ToolbarItem(placement: .navigationBarTrailing) {
            if !busStops.isEmpty {
              EditButton()
            }
          }
          ToolbarItem(placement: .navigationBarLeading) {
            Button(
              "Close",
              action: {
                dismiss()
              }
            )
          }
        }
        .sheet(isPresented: $isAddingNewStop) {
          SettingsAddStopView()
        }
        .navigationDestination(for: BusStop2.self) { stop in
          // When a NavigationLink(for: thing) { ... } is tapped then
          // this block is invoked if the type of thing is BusStop2
          SettingsEditStopView(stop: stop)
        }

        Button(action: { isAddingNewStop = true }) {
          Label("Add stop", systemImage: "plus.circle.fill")
        }

        Divider()

        Button(action: {
          resetToEoinPersonalDefaults()
        }) {
          Label("Reset to defaults", systemImage: "plus.circle.fill")
        }
      }
    }
  }

  private func resetToEoinPersonalDefaults() {
    print("Deleting all existing stored stops")
    try! modelContext.delete(model: BusStop2.self)

    let routes = [
      BusRoute2(routeName: "52", isPriorityRoute: true),
      BusRoute2(routeName: "58", isPriorityRoute: true),
      BusRoute2(routeName: "56", isPriorityRoute: false),
      BusRoute2(routeName: "57", isPriorityRoute: false),
    ]

    let busStopsOfInterest = [
      BusStop2(
        name: "5515",
        nickname: "Manners/Cuba",
        sortOrder: 0,
        routes: routes
      ),
      BusStop2(
        name: "5006",
        nickname: "DoC",
        sortOrder: 1,
        routes: routes
      ),
      BusStop2(
        name: "5014",
        nickname: "Lambton Kiwibank",
        sortOrder: 2,
        routes: routes
      ),
      BusStop2(
        name: "3772",
        nickname: "Up the top",
        sortOrder: 3,
        routes: routes
      ),
      BusStop2(
        name: "3546",
        nickname: "Down the bottom",
        sortOrder: 4,
        routes: routes
      ),
    ]

    print("Inserting hard-coded default stops")

    for stop in busStopsOfInterest {
      modelContext.insert(stop)
    }
  }
}

#Preview {
  let config = ModelConfiguration(isStoredInMemoryOnly: true)
  let container = try! ModelContainer(for: BusStop2.self, configurations: config)
  let sampleStop = BusStop2(
    name: "Downtown Station",
    nickname: "City Center",
    routes: [
      BusRoute2(routeName: "52", isPriorityRoute: true),
      BusRoute2(routeName: "56", isPriorityRoute: true),
      BusRoute2(routeName: "N5", isPriorityRoute: false),
    ]
  )

  container.mainContext.insert(sampleStop)

  return SettingsRootView()
    .modelContainer(container)
}
