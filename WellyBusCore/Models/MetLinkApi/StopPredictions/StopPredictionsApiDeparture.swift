import Foundation

struct StopPredictionsApiDeparture: Decodable, Identifiable {
  struct Origin: Decodable {
    let stopId: String
    let name: String

    enum CodingKeys: String, CodingKey {
      case stopId = "stop_id"
      case name
    }
  }

  struct Destination: Decodable {
    let stopId: String
    let name: String

    enum CodingKeys: String, CodingKey {
      case stopId = "stop_id"
      case name
    }
  }

  struct Arrival: Decodable {
    let aimed: String
    let expected: String?
  }

  struct Departure: Decodable {
    let aimed: String
    let expected: String?

    var aimedDate: Date? {
      ISO8601DateFormatter().date(from: aimed)
    }

    var expectedDate: Date? {
      ISO8601DateFormatter().date(from: (expected ?? ""))
    }

    func bestGuess() -> Date {
      if let x = expected {
        return ISO8601DateFormatter().date(from: x) ?? Date()
      }
      return ISO8601DateFormatter().date(from: aimed) ?? Date()
    }

    func secondsUntilBestGuess() -> TimeInterval {
      return bestGuess().timeIntervalSince(Date())
    }

    func bestGuessString() -> String {
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "HH:mm"

      return dateFormatter.string(from: bestGuess())
    }

    func timeUntil() -> String {
      let departureSecs = Int(secondsUntilBestGuess())
      let hours = departureSecs / (60 * 60)
      let secsNotInHours = departureSecs % (60 * 60)
      let mins = secsNotInHours / 60
      let secs = secsNotInHours % 60

      var duration = ""
      if hours > 0 { duration += "\(hours)h " }
      if mins > 0 { duration += "\(mins)m " }
      if hours == 0 && mins == 0 { duration += "\(secs)s " }

      return duration
    }
  }

  let id = UUID()
  let stopId: String
  let serviceId: String
  let direction: String
  let busOperator: String
  let origin: Origin
  let destination: Destination
  let delay: String
  let vehicleId: String?
  let name: String
  let arrival: Arrival
  let departure: Departure
  let status: String?
  let monitored: Bool
  let wheelchairAccessible: Bool
  let tripId: String

  enum CodingKeys: String, CodingKey {
    case stopId = "stop_id"
    case serviceId = "service_id"
    case direction
    case busOperator = "operator"
    case origin
    case destination
    case delay
    case vehicleId = "vehicle_id"
    case name
    case arrival
    case departure
    case status
    case monitored
    case wheelchairAccessible = "wheelchair_accessible"
    case tripId = "trip_id"
  }
}
