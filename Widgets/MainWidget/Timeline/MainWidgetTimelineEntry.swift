import SwiftUI
import WidgetKit

struct MainWidgetTimelineEntry: TimelineEntry {
  let date: Date
  let busStopSnapshots: [BusStopSnapshot]
  let debug: Debug

  struct Debug {
    let createdAt: Date
    let containingTimelineLength: Int
    let containingTimelineIndex: Int
  }

  init(date: Date, busStops: [BusStop], containingTimelineLength: Int, containingTimelineIndex: Int)
  {
    let now = Date()

    self.date = date
    self.busStopSnapshots = Self.buildBusStopSnapshots(
      from: busStops, snapshotTime: date, snapshotTakenAt: now)
    self.debug = Debug(
      createdAt: Date(),
      containingTimelineLength: containingTimelineLength,
      containingTimelineIndex: containingTimelineIndex
    )
  }

  static private func buildBusStopSnapshots(
    from busStops: [BusStop],
    snapshotTime: Date,
    snapshotTakenAt: Date
  ) -> [BusStopSnapshot] {
    let snapshots = busStops.map {
      buildBusStopSnapshot(from: $0, snapshotTime: snapshotTime, snapshotTakenAt: snapshotTakenAt)
    }
    return snapshots
  }

  static private func buildBusStopSnapshot(
    from busStop: BusStop,
    snapshotTime: Date,
    snapshotTakenAt: Date
  ) -> BusStopSnapshot {
    let departureSnapshots = busStop
      .departures
      .compactMap { buildDepartureSnapshot(from: $0, snapshotTime: snapshotTime) }
    //      .sorted { $0.bestDepartureTimeGuess < $1.bestDepartureTimeGuess }

    return BusStopSnapshot(
      stopName: busStop.stopName,
      nickName: busStop.nickName,
      direction: busStop.direction,
      snapshotTakenAt: snapshotTakenAt,
      snapshotTime: snapshotTime,
      departures: departureSnapshots
    )
  }

  static private func buildDepartureSnapshot(from departure: BusDeparture, snapshotTime: Date)
    -> DepartureSnapshot?
  {
    guard let bestGuess = departure.bestDepartureTimeGuess else { return nil }

    return DepartureSnapshot(
      serviceId: departure.serviceId,
      direction: departure.direction,
      scheduledAt: departure.scheduledAt,
      expectedAt: departure.expectedAt,
      bestDepartureTimeGuess: bestGuess,
      foregroundColor: departure.foregroundColor,
      backgroundColor: departure.backgroundColor
    )
  }
}

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

struct DepartureSnapshot: Identifiable {
  let id = UUID()
  let serviceId: String
  let direction: String
  let scheduledAt: Date?
  let expectedAt: Date?
  let bestDepartureTimeGuess: Date
  let foregroundColor: Color
  let backgroundColor: Color
}
