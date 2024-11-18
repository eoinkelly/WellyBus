import SwiftUI

struct MultiStopWidgetRouteNameView: View {
  @State public var departureSnapshot: DepartureSnapshot
  @State public var highlightColor: Color
  @State public var busStopSnapshot: BusStopSnapshot

  init(busStopSnapshot: BusStopSnapshot, departureSnapshot: DepartureSnapshot) {
    self.busStopSnapshot = busStopSnapshot
    self.departureSnapshot = departureSnapshot

    if departureSnapshot.expectedAt != nil {
      self.highlightColor = AppColors.trackedBusColor.color
    } else {
      self.highlightColor = AppColors.scheduledBusColor.color
    }
  }

  var body: some View {
    HStack {
      Rectangle()
        .fill(highlightColor)
        .frame(width: 6, height: 30)
        .cornerRadius(3)

      Text(departureSnapshot.serviceId)
        .padding(2)
        .foregroundStyle(departureSnapshot.foregroundColor)
        .background(departureSnapshot.backgroundColor)
        .cornerRadius(4)
    }
  }
}
