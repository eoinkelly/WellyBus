import SwiftUI

struct BusStopSnapshot: Identifiable {
  let id = UUID()
  let stopName: String
  let nickName: String
  let direction: BusDirection
  let snapshotTakenAt: Date

  /// The time at which this snapshot is intended to be rendered to the screen
  let snapshotTime: Date

  let departures: [DepartureSnapshot]

  // Find up to `limit` depatures which happen after `after`
  func nextDepartures(limit: Int, after: Date = Date.now) -> [DepartureSnapshot] {
    Array(self.departures.filter { $0.bestDepartureTimeGuess > after }.prefix(limit))
  }
}
