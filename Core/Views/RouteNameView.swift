import SwiftUI

struct RouteNameView: View {
  @State public var departure: StopPredictionsApiDeparture
  @State public var highlightColor: Color
  @State private var stopPrediction: StopPrediction
  @State private var busRouteForegroundColor: Color
  @State private var busRouteBackgroundColor: Color

  init(stopPrediction: StopPrediction, departure: StopPredictionsApiDeparture) {
    self.stopPrediction = stopPrediction
    self.departure = departure
    self.busRouteForegroundColor = stopPrediction.busRouteForegroundColor(for: departure.serviceId)
    self.busRouteBackgroundColor = stopPrediction.busRouteBackgroundColor(for: departure.serviceId)

    if departure.departure.expectedDate != nil {
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
        .foregroundStyle(busRouteForegroundColor)
        .background(busRouteBackgroundColor)
        .cornerRadius(4)
    }
  }
}
