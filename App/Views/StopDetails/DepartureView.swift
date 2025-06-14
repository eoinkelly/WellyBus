import SwiftUI

struct DepartureView: View {
  @State public var departure: BusDeparture
  @State public var busStop: BusStop
  @Binding public var now: Date

//  init(departure: BusDeparture, busStop: BusStop, now: Date) {
//    print("YYYYYYYYYYYYYYYYYYYYYYyyyy")
//    self.departure = departure
//    self.busStop = busStop
//  }
  
  var body: some View {
    VStack {
      Text("DepartureView now: \(now.formatted(date: .omitted, time: .standard))")
        .font(.caption)
        .foregroundColor(.yellow)
      HStack(alignment: .center) {
        RouteNameView(busStop: busStop, departure: departure)

        HStack(alignment: .center, spacing: 4) {
          if let expected = departure.expectedAt {
            DepartureTimeView(departAt: expected, now: $now)
          } else if let aimed = departure.scheduledAt {
            DepartureTimeView(departAt: aimed, now: $now)
          }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
      }
      .frame(maxWidth: .infinity)
    }
//    .onChange(of: now, initial: false) { oldNow, newNow in
//      print("xxxxxxxxxxxxxxxxxxxxxxxxxxxx DepartureView got new now")
//    }
  }
}
