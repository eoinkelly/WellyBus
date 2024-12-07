import SwiftData
import SwiftUI

// MARK: - Models
@Model
class BusStop2 {
  var name: String
  var nickname: String
  var routes: [BusRoute2]
  var sortOrder: Int

  init(name: String, nickname: String, sortOrder: Int = 0, routes: [BusRoute2] = []) {
    self.name = name
    self.nickname = nickname
    self.sortOrder = sortOrder
    self.routes = routes
  }
}

@Model
class BusRoute2 {
  var routeName: String
  var isPriorityRoute: Bool

  init(routeName: String, isPriorityRoute: Bool = false) {
    self.routeName = routeName
    self.isPriorityRoute = isPriorityRoute
  }
}

// MARK: - Views
struct SettingsRootView: View {
  @Environment(\.modelContext) private var modelContext

  @Query(sort: \BusStop2.sortOrder) private var busStops: [BusStop2]
  @State private var isAddingNewStop = false
  @State private var selectedStop: BusStop2?

  var body: some View {
    NavigationStack {
      List {
        ForEach(busStops) { stop in
          SettingStopListItemView(stop: stop)
            .onTapGesture {
              selectedStop = stop
            }
        }
        .onMove { indices, destination in
          var stops = busStops  // TODO: why need this?

          // move the stops in memory
          stops.move(fromOffsets: indices, toOffset: destination)

          // update the sortOrder attribute on each stop to reflect the new order
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
      .navigationTitle("Bus Stops")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          Button(action: { isAddingNewStop = true }) {
            Image(systemName: "plus")
          }
        }
        ToolbarItem(placement: .navigationBarLeading) {
          EditButton()
        }
      }
      .sheet(isPresented: $isAddingNewStop) {
        SettingsAddStopView()
      }
      .sheet(item: $selectedStop) { stop in
        SettingsEditStopView(stop: stop)
      }
    }
  }
}

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

struct SettingsAddStopView: View {
  @Environment(\.modelContext) private var modelContext
  @Environment(\.dismiss) private var dismiss

  @State private var name = ""
  @State private var nickname = ""

  var body: some View {
    NavigationStack {
      Form {
        Section("Stop Details") {
          TextField("Stop Name", text: $name)
          TextField("Nickname (Optional)", text: $nickname)
        }
      }
      .navigationTitle("Add Bus Stop")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .cancellationAction) {
          Button("Cancel") {
            dismiss()
          }
        }
        ToolbarItem(placement: .confirmationAction) {
          Button("Add") {
            // ***********************
            // find highest sort order and add 1
            // TODO: is there a better way to do this?
            var fetchDescriptor = FetchDescriptor<BusStop2>(sortBy: [
              SortDescriptor(\.sortOrder, order: .reverse)
            ])
            fetchDescriptor.fetchLimit = 1

            let stops = try? modelContext.fetch(fetchDescriptor)
            let maxPositionStop = stops?.first
            let maxPosition = maxPositionStop?.sortOrder ?? 0
            let nextPosition = maxPosition + 1
            // ***********************

            let newStop = BusStop2(name: name, nickname: nickname, sortOrder: nextPosition)

            modelContext.insert(newStop)
            dismiss()
          }
          .disabled(name.isEmpty)
        }
      }
    }
  }
}

// MARK: - Edit Bus Stop View
struct SettingsEditStopView: View {
  @Environment(\.modelContext) private var modelContext
  @Environment(\.dismiss) private var dismiss

  @Bindable var stop: BusStop2
  @State private var isAddingDeparture = false

  var body: some View {
    NavigationStack {
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
            isAddingDeparture = true
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
      .sheet(isPresented: $isAddingDeparture) {
        SettingsAddRouteView(stop: stop)
      }
    }
  }
}

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
      }
    }
  }
}

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
