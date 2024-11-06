import SwiftUI

struct BusStopConfig: Hashable {
  enum BusDirection: String, Codable {
    case toTown
    case toHome
  }

  struct BusRouteConfig: Hashable {
    let name: String
    let foregroundColor: Color
    let backgroundColor: Color

    init(
      name: String,
      backgroundColor: Color = AppColors.defaultRouteBackgroundColor.color,
      foregroundColor: Color = AppColors.defaultRouteForegroundColor.color
    ) {
      self.name = name
      self.foregroundColor = foregroundColor
      self.backgroundColor = backgroundColor
    }
  }

  let friendlyName: String
  let stopId: String
  let followedBusRoutes: Set<BusRouteConfig>
  let direction: BusDirection
}
