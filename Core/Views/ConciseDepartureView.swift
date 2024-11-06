import SwiftUI

struct ConciseDepartureView: View {
  @State public var departure: StopPredictionsApiDeparture
  @State private var stopPrediction: StopPrediction

  init(stopPrediction: StopPrediction, departure: StopPredictionsApiDeparture) {
    self.departure = departure
    self.stopPrediction = stopPrediction
  }

  var body: some View {
    HStack(alignment: .center) {
      RouteNameView(stopPrediction: stopPrediction, departure: departure)

      HStack(alignment: .center, spacing: 4) {
        if let expected = departure.departure.expectedDate {
          DepartureTimeView(departAt: expected)
        } else if let aimed = departure.departure.aimedDate {
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
