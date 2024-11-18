import SwiftUI

struct SingleStopWidgetDeparturesView: View {
  @State public var busStopSnapshot: BusStopSnapshot
  @State public var departures: [DepartureSnapshot]

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
