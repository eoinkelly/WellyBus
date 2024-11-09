import Foundation

class BusStop: Identifiable {
  let id = UUID()
  let stopName: String
  let nickName: String
  let departures: [BusDeparture]
  let direction: BusDirection

  init(stopName: String, nickName: String, departures: [BusDeparture], direction: BusDirection) {
    self.stopName = stopName
    self.nickName = nickName
    self.departures = departures
    self.direction = direction
  }
}
