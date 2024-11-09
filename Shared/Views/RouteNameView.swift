import SwiftUI

struct RouteNameView: View {
  @State public var departure: BusDeparture
  @State public var highlightColor: Color
  @State public var busStop: BusStop

  init(busStop: BusStop, departure: BusDeparture) {
    self.busStop = busStop
    self.departure = departure

    if departure.expectedAt != nil {
      self.highlightColor = AppColors.trackedBusColor.color
    } else {
      self.highlightColor = AppColors.scheduledBusColor.color
    }
  }

  var body: some View {
    HStack {
      Rectangle()
        .fill(highlightColor)
        .frame(width: 6)
        .cornerRadius(3)

      Text(departure.serviceId)
        .padding(2)
        .foregroundStyle(departure.foregroundColor)
        .background(departure.backgroundColor)
        .cornerRadius(4)
    }
  }
}
