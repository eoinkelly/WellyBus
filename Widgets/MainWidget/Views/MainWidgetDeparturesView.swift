import SwiftUI

struct MainWidgetDeparturesView: View {
  @State private var rows: [Row]
  @State public var busStop: BusStop

  let maxDeparturesToShow = 4

  init(busStop: BusStop) {
    self.busStop = busStop
    let depsToShow = Array(busStop.departures.prefix(maxDeparturesToShow))
    self.rows = Row.create(from: depsToShow)
  }

  var body: some View {
    Grid(alignment: .leading, horizontalSpacing: 4, verticalSpacing: 4) {
      ForEach(rows) { row in
        GridRow {
          ForEach(row.departures) { departure in
            MainWidgetDepartureView(busStop: busStop, departure: departure)
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
