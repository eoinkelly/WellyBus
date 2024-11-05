import SwiftUI

struct RouteNameView: View {
  @State public var departure: StopPredictionsApiDeparture
  @State public var highlightColor: Color

  init(departure: StopPredictionsApiDeparture) {
    self.departure = departure

    if departure.departure.expectedDate != nil {
      self.highlightColor = .green
    } else {
      self.highlightColor = .gray
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
        .foregroundStyle(.black)
        .background(.yellow)
        .cornerRadius(4)
    }
  }
}
