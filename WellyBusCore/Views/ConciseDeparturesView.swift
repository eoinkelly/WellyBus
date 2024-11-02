import SwiftUI

struct ConciseDeparturesView: View {
  @State public var departures: [StopPredictionsApiDeparture]
  @State public var numDeparturesToShow = 6

  let columns = [
    GridItem(.flexible(), spacing: 4),
    GridItem(.flexible(), spacing: 4),
    GridItem(.flexible(), spacing: 4),
  ]

  var body: some View {
    LazyVGrid(columns: columns, alignment: .leading, spacing: 4) {
      ForEach(departures.prefix(numDeparturesToShow)) { departure in
        HStack(alignment: .center) {
          Text(departure.serviceId)
            .font(.body)
            .foregroundStyle(.black)
            .padding(1)
            .background(.yellow)
            .cornerRadius(3)
          Text(departure.departure.timeUntil())
            .font(.body)
        }
      }
    }
  }
}
