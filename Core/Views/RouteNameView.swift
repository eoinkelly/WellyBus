import SwiftUI

struct RouteNameView: View {
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
    Text(departure.serviceId)
      .font(.body)
      .foregroundStyle(.black)
      .padding(2)
      .background(highlightColor)
      .cornerRadius(3)
  }
}
