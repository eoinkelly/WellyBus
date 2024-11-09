import SwiftUI

struct AllDeparturesForStopView: View {
  @State private var busStop: BusStop
  @State private var rows: [Row]

  init(busStop: BusStop) {
    self.busStop = busStop
    self.rows = Row.create(from: busStop.departures)
  }

  var body: some View {
    Grid(alignment: .leading, horizontalSpacing: 24, verticalSpacing: 8) {
      ForEach(rows) { row in
        GridRow {
          ForEach(row.departures) { departure in
            DepartureView(busStop: busStop, departure: departure)
              .frame(maxWidth: .infinity)
          }
        }
      }
    }
  }
}

private struct Row: Identifiable {
  let id = UUID()
  let departures: [BusDeparture]

  static func create(from departures: [BusDeparture], groupSize: Int = 2)
    -> [Self]
  {
    stride(from: 0, to: departures.count, by: groupSize)
      .map { i in
        let deps = Array(departures[i..<Swift.min(i + groupSize, departures.count)])
        return Self(departures: deps)
      }
  }
}
