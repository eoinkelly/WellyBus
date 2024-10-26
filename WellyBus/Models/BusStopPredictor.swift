import Foundation

class BusStopPredictor {
  func textSummary() async -> String {
    var output = ""

    logger.info("Starting Bus Tracker function")

    for stop in Config.shared.busStopsOfInterest {
      output += await createTextSummaryOf(stop)
    }

    logger.info("output=\(output)")
    return output
  }

  private func formatStopHeader(_ stop: BusStopOfInterest) -> String {
    return """

      ****************************
      \(stop.friendlyName) (\(stop.stopId))

      """
  }

  private func formatSeparator() -> String {
    return "----\n"
  }

  private func createTextSummaryOf(_ stop: BusStopOfInterest) async -> String {
    let departures = await MetlinkApi.shared.predictedDeparturesForStop(stop)
    var output = formatStopHeader(stop)

    // Process priority buses
    let priorityBuses =
      departures
      .filter { stop.priorityBusIds.contains($0.serviceId) }
      .map { formatSummary($0) }
      .joined(separator: "\n")

    output += priorityBuses
    output += "\n"
    output += formatSeparator()

    // Process ordinary buses
    let ordinaryBuses =
      departures
      .filter { stop.ordinaryBusIds.contains($0.serviceId) }
      .map { formatSummary($0) }
      .joined(separator: "\n")

    output += ordinaryBuses
    output += "\n"

    return output
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
