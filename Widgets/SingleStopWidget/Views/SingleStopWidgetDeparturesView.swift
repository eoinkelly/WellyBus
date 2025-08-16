import SwiftUI

struct SingleStopWidgetDeparturesView: View {
  public let busStopSnapshot: BusStopSnapshot
  public let departures: [DepartureSnapshot]

  let numDeparturesToShow: Int = 6

  init(busStopSnapshot: BusStopSnapshot) {
    self.busStopSnapshot = busStopSnapshot

    self.departures = busStopSnapshot.nextDepartures(
      limit: numDeparturesToShow,
      after: busStopSnapshot.snapshotTime
    )
  }

  var body: some View {
    VStack {
      ForEach(departures) { departureSnapshot in
        SingleStopWidgetDepartureView(
          busStopSnapshot: busStopSnapshot,
          departureSnapshot: departureSnapshot
        )
        .frame(maxWidth: .infinity)
      }
    }
  }
}
