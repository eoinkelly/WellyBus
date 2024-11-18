import SwiftUI

struct MultiStopWidgetDeparturesView: View {
  @State private var rows: [Row]
  @State public var busStopSnapshot: BusStopSnapshot

  init(busStopSnapshot: BusStopSnapshot) {
    self.busStopSnapshot = busStopSnapshot

    let nextDepatures = busStopSnapshot.nextDepartures(
      limit: 2, after: busStopSnapshot.snapshotTime)

    if nextDepatures.count == 2 {
      self.rows = Row.create(from: nextDepatures)
    } else {
      self.rows = []
      // TODO: if there are not at least 2 departures then fill the row space with a "open app for better info" msg
    }

  }

  var body: some View {
    Grid(alignment: .leading, horizontalSpacing: 4, verticalSpacing: 4) {
      ForEach(rows) { row in
        GridRow {
          ForEach(row.departureSnapshots) { departureSnapshot in
            MultiStopWidgetDepartureView(
              busStopSnapshot: busStopSnapshot,
              departureSnapshot: departureSnapshot
            )
            .frame(maxWidth: .infinity)
          }
        }
      }
    }
  }
}

// Row controls how many columns are shown in the grid
private struct Row: Identifiable {
  static let maxColumns = 2
  let id = UUID()
  let departureSnapshots: [DepartureSnapshot]

  static func create(from departures: [DepartureSnapshot], groupSize: Int = maxColumns)
    -> [Self]
  {
    stride(from: 0, to: departures.count, by: groupSize)
      .map { i in
        let deps = Array(departures[i..<Swift.min(i + groupSize, departures.count)])
        return Self(departureSnapshots: deps)
      }
  }
}
