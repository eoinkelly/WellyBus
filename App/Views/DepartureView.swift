import SwiftUI

struct DepartureView: View {
  @State private var departure: BusDeparture
  @State private var busStop: BusStop

  init(busStop: BusStop, departure: BusDeparture) {
    self.departure = departure
    self.busStop = busStop
  }

  var body: some View {
    HStack(alignment: .center) {
      RouteNameView(busStop: busStop, departure: departure)

      HStack(alignment: .center, spacing: 4) {
        if let expected = departure.expectedAt {
          DepartureTimeView(departAt: expected)
        } else if let aimed = departure.scheduledAt {
          DepartureTimeView(departAt: aimed)
        } else {
          Text("UNKNOWN")
        }
      }
      .frame(maxWidth: .infinity, alignment: .leading)
    }
    .frame(maxWidth: .infinity)
  }
}
