import Foundation

struct Debug {
  static func dumpTime(time: Date, message: String = "") {
    let formatter = DateComponentsFormatter()
    formatter.allowedUnits = [.day, .hour, .minute, .second]
    formatter.unitsStyle = .short

    let formattedDuration = formatter.string(from: time.timeIntervalSinceNow)!

    print("DUMP:\(message) \(formattedDuration)")
  }
}
