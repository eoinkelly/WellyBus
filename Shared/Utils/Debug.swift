import Foundation

struct Debug {
  static func asRelativeTime(_ time: Date) -> String {
    time.formatted(.relative(presentation: .numeric, unitsStyle: .narrow))
  }
}
