import Foundation

class BusStop: Identifiable {
  let id = UUID()
  let stopName: String
  let nickName: String
  let departures: [BusDeparture]
  let direction: BusDirection
  let departuresFetchedAt: Date

  init(
    stopName: String,
    nickName: String,
    departures: [BusDeparture],
    direction: BusDirection,
    departuresFetchedAt: Date
  ) {
    self.stopName = stopName
    self.nickName = nickName
    self.departures = departures
    self.direction = direction
    self.departuresFetchedAt = departuresFetchedAt
  }
}
