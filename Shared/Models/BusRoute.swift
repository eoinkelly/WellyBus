import SwiftUI

struct BusRoute {
  static let defaultBackgroundColor: Color = AppColors.defaultRouteBackgroundColor.color
  static let defaultForegroundColor: Color = AppColors.defaultRouteForegroundColor.color

  let name: String
  let foregroundColor: Color
  let backgroundColor: Color

  init(
    name: String,
    backgroundColor: Color = Self.defaultBackgroundColor,
    foregroundColor: Color = Self.defaultForegroundColor
  ) {
    self.name = name
    self.foregroundColor = foregroundColor
    self.backgroundColor = backgroundColor
  }
}
