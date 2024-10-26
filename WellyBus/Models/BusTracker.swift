import Foundation

class BusTracker {
  func main() async -> String {
    let args: [String] = ["home"]
    var output = ""
    
    let toHomeStops = [
      BusStopOfInterest(
        friendlyName: "Nearest work",
        stopNumber: 5014,
        priorityBusNumbers: ["52", "58"],
        ordinaryBusNumbers: ["56", "57"]
      ),
      BusStopOfInterest(
        friendlyName: "St. James Theatre",
        stopNumber: 5002,
        priorityBusNumbers: ["52", "58"],
        ordinaryBusNumbers: ["56", "57"]
      ),
    ]
    
    let toTownStops = [
      BusStopOfInterest(
        friendlyName: "Newlands Road/Black Rock Road",
        stopNumber: 3546,
        priorityBusNumbers: ["52", "58"],
        ordinaryBusNumbers: ["56", "57"]
      ),
      BusStopOfInterest(
        friendlyName: "Glanmire Road/Truville Cr",
        stopNumber: 3772,
        priorityBusNumbers: ["52", "58"],
        ordinaryBusNumbers: ["56", "57"]
      ),
    ]

    logger.info("Starting Bus Tracker function")

    switch args[0] {
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

    logger.info("output=\(output)")
    return output
  }

  private func formatStopHeader(_ stop: BusStopOfInterest) -> String {
    return """

      ****************************
      \(stop.friendlyName) (\(stop.stopNumber))

      """
  }

  private func formatSeparator() -> String {
    return "----\n"
  }

  private func processBusStop(_ stop: BusStopOfInterest) async -> String {
    guard let departures = await getDeparturesForStop(stop) else {
      return "Error: Could not fetch departures for stop \(stop.stopNumber)\n"
    }

    var output = formatStopHeader(stop)

    // Process priority buses
    let priorityBuses =
      departures
      .filter { stop.priorityBusNumbers.contains($0.serviceId) }
      .map { formatSummary($0) }
      .joined(separator: "\n")

    output += priorityBuses
    output += "\n"
    output += formatSeparator()

    // Process ordinary buses
    let ordinaryBuses =
      departures
      .filter { stop.ordinaryBusNumbers.contains($0.serviceId) }
      .map { formatSummary($0) }
      .joined(separator: "\n")

    output += ordinaryBuses
    output += "\n"

    return output
  }

  private func getDeparturesForStop(_ stop: BusStopOfInterest) async -> [StopPredictionsApiDeparture]? {
    // TODO: shorter syntax for this guard since I know it will succeed?
    guard var url = URL(string: "https://api.opendata.metlink.org.nz/v1/stop-predictions")
    else {
      return nil
    }

    url.append(queryItems: [URLQueryItem(name: "stop_id", value: String(stop.stopNumber))])

    print("Stop number: \(stop.stopNumber)")
    print("URL: \(url)")

    var request = URLRequest(url: url)
    request.addValue(METLINK_API_KEY, forHTTPHeaderField: "x-api-key")
    request.httpMethod = "GET"

    do {
      let (data, _) = try await URLSession.shared.data(for: request)

      //            if let dataString = String(data: data, encoding: .utf8) {
      //              print("----------------------")
      //              print(dataString)
      //              print("----------------------")
      //            } else {
      //              print("Failed to convert data to string")
      //            }

      let response = try JSONDecoder().decode(StopPredictionsApiResponse.self, from: data)
      return response.departures

    } catch {
      logger.error("AAA Error fetching departs: \(error)")
      return nil
    }
  }

  private func formatSummary(_ busDeparture: StopPredictionsApiDeparture) -> String {
    let busNumber = busDeparture.serviceId

    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm"
    let busLeavesAt = dateFormatter.string(from: busDeparture.departure.bestGuess())

    let timeToPrepare = calculateTimeToPrepare(busDeparture)

    return "  No. \(busNumber) leaves at \(busLeavesAt) \(timeToPrepare)"
  }

  private func calculateTimeToPrepare(_ busDeparture: StopPredictionsApiDeparture) -> String {
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
