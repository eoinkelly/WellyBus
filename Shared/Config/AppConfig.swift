import Foundation
import SwiftUI

// Someday this could be loaded from somewhere user editable
class AppConfig {
  static let shared = AppConfig()

  enum Widgets {
    enum MultiStopWidget {
      static let kind: String = "info.eoinkelly.WellyBus.Widgets.MultiStop"
    }
    enum SingleStopWidget {
      static let kind: String = "info.eoinkelly.WellyBus.Widgets.SingleStop"
    }
  }

  // These are Arrays not Sets so we can preserve order
  let busStopsOfInterest: [BusStopConfig]
  let followedBusRoutes: [BusStopConfig.BusRouteConfig] = [
    BusStopConfig.BusRouteConfig(name: "52", backgroundColor: .blue, foregroundColor: .white),
    BusStopConfig.BusRouteConfig(name: "58", backgroundColor: .blue, foregroundColor: .white),
    BusStopConfig.BusRouteConfig(name: "56"),
    BusStopConfig.BusRouteConfig(name: "57"),
    BusStopConfig.BusRouteConfig(name: "N5"),
  ]

  private init() {
    self.busStopsOfInterest = [
      BusStopConfig(
        friendlyName: "Manners/Cuba",
        stopId: "5515",
        followedBusRoutes: followedBusRoutes,
        direction: BusDirection.toHome
      ),
      BusStopConfig(
        friendlyName: "DoC",
        stopId: "5006",
        followedBusRoutes: followedBusRoutes,
        direction: BusDirection.toHome
      ),
      BusStopConfig(
        friendlyName: "Lambton Kiwibank",
        stopId: "5014",
        followedBusRoutes: followedBusRoutes,
        direction: BusDirection.toHome
      ),
      BusStopConfig(
        friendlyName: "Up the top",
        stopId: "3772",
        followedBusRoutes: followedBusRoutes,
        direction: BusDirection.toTown
      ),
      BusStopConfig(
        friendlyName: "Down the bottom",
        stopId: "3546",
        followedBusRoutes: followedBusRoutes,
        direction: BusDirection.toTown
      ),
    ]
  }
}
