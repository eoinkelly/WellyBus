import SwiftUI

struct ConciseDepartureView: View {
  @State public var departure: StopPredictionsApiDeparture
  @State public var highlightColor: Color

  init(departure: StopPredictionsApiDeparture) {
    self.departure = departure

    if departure.departure.expectedDate != nil {
      self.highlightColor = .green
    } else {
      self.highlightColor = Color(red: 0.95, green: 0.95, blue: 0.95)
    }
  }

  var body: some View {
    HStack(alignment: .center) {
      RouteNameView(departure: departure)

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
