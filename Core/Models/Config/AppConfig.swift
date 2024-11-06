import Foundation
import SwiftUI

// Someday this could be loaded from somewhere user editable
class AppConfig {
  static let shared = AppConfig()

  let busStopsOfInterest: Set<BusStopConfig>
  let followedBusRoutes: Set<BusStopConfig.BusRouteConfig> = [
    BusStopConfig.BusRouteConfig(name: "52", backgroundColor: .blue, foregroundColor: .white),
    BusStopConfig.BusRouteConfig(name: "58", backgroundColor: .blue, foregroundColor: .white),
    BusStopConfig.BusRouteConfig(name: "56"),
    BusStopConfig.BusRouteConfig(name: "57"),
    BusStopConfig.BusRouteConfig(name: "N5"),
  ]

  private init() {
    self.busStopsOfInterest = [
      BusStopConfig(
        friendlyName: "Up the top",
        stopId: "3772",
        followedBusRoutes: followedBusRoutes,
        direction: BusStopConfig.BusDirection.toTown
      ),
      BusStopConfig(
        friendlyName: "Down the bottom",
        stopId: "3546",
        followedBusRoutes: followedBusRoutes,
        direction: BusStopConfig.BusDirection.toTown
      ),
      BusStopConfig(
        friendlyName: "Outside DoC",
        stopId: "5006",
        followedBusRoutes: followedBusRoutes,
        direction: BusStopConfig.BusDirection.toHome
      ),
      BusStopConfig(
        friendlyName: "Lambton Quay",
        stopId: "5014",
        followedBusRoutes: followedBusRoutes,
        direction: BusStopConfig.BusDirection.toHome
      ),
    ]
  }
}
