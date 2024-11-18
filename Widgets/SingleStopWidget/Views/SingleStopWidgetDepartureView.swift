import SwiftUI

struct SingleStopWidgetDepartureView: View {
  @State public var departureSnapshot: DepartureSnapshot
  @State public var busStopSnapshot: BusStopSnapshot

  init(busStopSnapshot: BusStopSnapshot, departureSnapshot: DepartureSnapshot) {
    self.departureSnapshot = departureSnapshot
    self.busStopSnapshot = busStopSnapshot
  }

  var body: some View {
    HStack(alignment: .center) {
      SingleStopWidgetRouteNameView(
        busStopSnapshot: busStopSnapshot, departureSnapshot: departureSnapshot)

      HStack(alignment: .center, spacing: 4) {
        SingleStopWidgetDepartureTimeView(departsAt: departureSnapshot.bestDepartureTimeGuess)
      }
      .frame(maxWidth: .infinity, alignment: .leading)
    }
    .frame(maxWidth: .infinity)
  }
}
