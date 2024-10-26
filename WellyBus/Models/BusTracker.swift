import Foundation

class BusTracker {
  private let toHomeStops = [
    BusStop(
      name: "Nearest work",
      number: 5014,
      priorityBuses: ["52", "58"],
      ordinaryBuses: ["56", "57"]
    ),
    BusStop(
      name: "St. James Theatre",
      number: 5002,
      priorityBuses: ["52", "58"],
      ordinaryBuses: ["56", "57"]
    ),
  ]

  private let toTownStops = [
    BusStop(
      name: "Newlands Road/Black Rock Road",
      number: 3546,
      priorityBuses: ["52", "58"],
      ordinaryBuses: ["56", "57"]
    ),
    BusStop(
      name: "Glanmire Road/Truville Cr",
      number: 3772,
      priorityBuses: ["52", "58"],
      ordinaryBuses: ["56", "57"]
    ),
  ]

  func main() async -> String {
    let args = CommandLine.arguments
    var output = ""

    if args.count > 1 {
      switch args[1].lowercased() {
      case "home":
        for stop in toHomeStops {
          output += await processBusStop(stop)
        }
      case "town", "work":
        for stop in toTownStops {
          output += await processBusStop(stop)
        }
      default:
        output += "Ideally you provide an option: home|town|work\n"
        output += "Defaulting to option: 'home'\n"
        for stop in toHomeStops {
          output += await processBusStop(stop)
        }
      }
    } else {
      output += "Ideally you provide an option: home|town|work\n"
      output += "Defaulting to option: 'home'\n"
      for stop in toHomeStops {
        output += await processBusStop(stop)
      }
    }

    return output
  }

  private func formatStopHeader(_ stop: BusStop) -> String {
    return """

      ****************************
      \(stop.name) (\(stop.number))

      """
  }

  private func formatSeparator() -> String {
    return "----\n"
  }

  private func processBusStop(_ stop: BusStop) async -> String {
    guard let departures = await getDeparturesForStop(stop) else {
      return "Error: Could not fetch departures for stop \(stop.number)\n"
    }

    var output = formatStopHeader(stop)

    // Process priority buses
    let priorityBuses =
      departures
      .filter { stop.priorityBuses.contains($0.serviceId) }
      .map { formatSummary($0) }
      .joined(separator: "\n")

    output += priorityBuses
    output += "\n"
    output += formatSeparator()

    // Process ordinary buses
    let ordinaryBuses =
      departures
      .filter { stop.ordinaryBuses.contains($0.serviceId) }
      .map { formatSummary($0) }
      .joined(separator: "\n")

    output += ordinaryBuses
    output += "\n"

    return output
  }

  private func getDeparturesForStop(_ stop: BusStop) async -> [BusDepartureApiResponse]? {
    guard
      let url = URL(
        string: "https://api.opendata.metlink.org.nz/v1/stop-predictions?stop_id=\(stop.number)")
    else {
      return nil
    }

    var request = URLRequest(url: url)
      request.addValue(METLINK_API_KEY, forHTTPHeaderField: "x-api-key")

    do {
      let (data, _) = try await URLSession.shared.data(for: request)
      let response = try JSONDecoder().decode(MetlinkResponse.self, from: data)
      return response.departures
    } catch {
      return nil
    }
  }

  private func formatSummary(_ busDeparture: BusDepartureApiResponse) -> String {
    let busNumber = busDeparture.serviceId

    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm"
    let busLeavesAt = dateFormatter.string(from: busDeparture.departure.bestGuess())

    let timeToPrepare = calculateTimeToPrepare(busDeparture)

    return "  No. \(busNumber) leaves at \(busLeavesAt) \(timeToPrepare)"
  }

  private func calculateTimeToPrepare(_ busDeparture: BusDepartureApiResponse) -> String {
    let departureSecs = Int(busDeparture.departure.secondsUntilBestGuess())
    let hours = departureSecs / (60 * 60)
    let secsNotInHours = departureSecs % (60 * 60)
    let mins = secsNotInHours / 60
    let secs = secsNotInHours % 60

    var duration = "( "
    if hours > 0 { duration += "\(hours)h " }
    if mins > 0 { duration += "\(mins)m " }
    if hours == 0 && mins == 0 { duration += "\(secs)s " }
    duration += ")"

    return duration
  }
}

// Entry point
//Task {
//    let output = await BusTracker().main()
//    print(output)  // Only print at the very end
//}
//
//RunLoop.main.run()
