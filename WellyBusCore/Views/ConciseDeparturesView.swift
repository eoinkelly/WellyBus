import SwiftUI

struct ConciseDeparturesView: View {
  @State private var rows: [Row]

  init(departures: [StopPredictionsApiDeparture], maxDeparturesToShow: Int) {
    let visibleDepartures = Array(departures.prefix(maxDeparturesToShow))

    self.rows = Row.create(from: visibleDepartures)
  }

  var body: some View {
    Grid(alignment: .leading, horizontalSpacing: 4, verticalSpacing: 4) {
      ForEach(rows) { row in
        GridRow {
          ForEach(row.departures) { departure in
            ConciseDepartureView(departure: departure)
              .frame(maxWidth: .infinity)
          }
        }
      }
    }
  }
}

private struct Row: Identifiable {
  let id = UUID()
  let departures: [StopPredictionsApiDeparture]

  static func create(from departures: [StopPredictionsApiDeparture], groupSize: Int = 2)
    -> [Self]
  {
    stride(from: 0, to: departures.count, by: groupSize)
      .map { i in
        let deps = Array(departures[i..<Swift.min(i + groupSize, departures.count)])
        return Self(departures: deps)
      }
  }
}