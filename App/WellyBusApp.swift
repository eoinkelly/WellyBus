import SwiftData
import SwiftUI

@main
struct WellyBusApp: App {
  let container: ModelContainer

  init() {
    do {
      // SwiftData stores the sqlite here at this path. Useful when running in simulator. Haven't figured out a way to open the sqlite on device
      print(URL.applicationSupportDirectory.path(percentEncoded: false))

      let schema = Schema([
        BusStop2.self,
        BusRoute2.self,
      ])
      let modelConfiguration = ModelConfiguration(schema: schema)
      container = try ModelContainer(for: schema, configurations: [modelConfiguration])

      // Add starter stops if none exist
      // TODO: Currently this fails to compile
      //      if try container.mainContext.fetch(Descriptor<BusStop2>()).isEmpty {
      //        addSampleData(context: container.mainContext)
      //      }
    } catch {
      fatalError("Could not initialize ModelContainer: \(error)")
    }
  }

  var body: some Scene {
    WindowGroup {
      MainAppView()
    }
    .modelContainer(container)
  }

  //  private func addSampleData(context: ModelContext) {
  //    let sampleStop = BusStop2(name: "Downtown Station", nickname: "City Center")
  //    sampleStop.departures = [
  //      BusDeparture2(routeName: "Route 1", departureTime: Date(), isPriorityRoute: true),
  //      BusDeparture2(routeName: "Route 2", departureTime: Date().addingTimeInterval(3600), isPriorityRoute: false)
  //    ]
  //    context.insert(sampleStop)
  //  }
}
