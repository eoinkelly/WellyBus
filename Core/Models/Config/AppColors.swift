import SwiftUI

enum AppColors {
  case defaultRouteForegroundColor
  case defaultRouteBackgroundColor
  case trackedBusColor
  case scheduledBusColor

  var color: Color {
    switch self {
    case .defaultRouteForegroundColor:
      return Color(.black)
    case .defaultRouteBackgroundColor:
      return Color(red: 0.90, green: 0.90, blue: 0.90)

    case .trackedBusColor:
      return Color(.green)
    case .scheduledBusColor:
      return .gray
    }
  }
}
