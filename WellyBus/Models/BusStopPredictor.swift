import Foundation

struct BusStopPredictor {
  func stopPredictions() -> [StopPrediction] {
    Config.shared.busStopsOfInterest.map {
      StopPrediction(stopConfig: $0)
    }
  }

  //  func textSummary() async -> String {
  //
  //    // ****************
  //    var preds: [StopPrediction] = []
  //
  //    for stopConfig in Config.shared.busStopsOfInterest {
  //
  //      preds.append(StopPrediction(stopConfig: stopConfig))
  //      //      var deps: [StopPredictionsApiDeparture] = []
  //      //      for await dep in MetlinkApi.shared.predictedDeparturesForStop(stop) {
  //      //        deps.append(dep)
  //      //      }
  //      //      preds.append(StopPrediction( stop: stop, departures: deps))
  //    }
  //    // ****************8
  //
  //    var output = ""
  //
  //    for stop in Config.shared.busStopsOfInterest {
  //      output += await createTextSummaryOf(stop)
  //    }
  //
  //    return output
  //  }
  //
  //  private func formatStopHeader(_ stop: StopConfig) -> String {
  //    "\(stop.formattedDirection()): \(stop.friendlyName)\n----\n"
  //  }
  //
  //  private func formatSeparator() -> String {
  //    "\n"
  //  }
  //
  //  //  private func buildStopPredictionFor(_ stop: BusStopOfInterest) async -> StopPrediction {
  //  //    StopPrediction(stop: stop, departures: await MetlinkApi.shared.predictedDeparturesForStop(stop))
  //  //  }
  //
  //  private func createTextSummaryOf(_ stop: StopConfig) async -> String {
  //    let departures = await MetlinkApi.shared.predictedDeparturesForStop(stop)
  //    var output = formatStopHeader(stop)
  //
  //    // Process priority buses
  //    let priorityBuses =
  //      departures
  //      .filter { stop.followedBusIds.contains($0.serviceId) }
  //      .map { formatSummary($0) }
  //      .joined(separator: "\n")
  //
  //    output += priorityBuses
  //    output += "\n"
  //    output += formatSeparator()
  //
  //    // Process ordinary buses
  //    //    let ordinaryBuses =
  //    //      departures
  //    //      .filter { stop.ordinaryBusIds.contains($0.serviceId) }
  //    //      .map { formatSummary($0) }
  //    //      .joined(separator: "\n")
  //    //
  //    //    output += ordinaryBuses
  //    //    output += "\n"
  //
  //    return output
  //  }
  //
  //  private func formatSummary(_ busDeparture: StopPredictionsApiDeparture) -> String {
  //    let busNumber = busDeparture.serviceId
  //
  //    let dateFormatter = DateFormatter()
  //    dateFormatter.dateFormat = "HH:mm"
  //    let busLeavesAt = dateFormatter.string(from: busDeparture.departure.bestGuess())
  //
  //    let timeToPrepare = calculateTimeToPrepare(busDeparture)
  //
  //    return "\(busNumber) in \(timeToPrepare) (\(busLeavesAt))"
  //  }
  //
  //  private func calculateTimeToPrepare(_ busDeparture: StopPredictionsApiDeparture) -> String {
  //    let departureSecs = Int(busDeparture.departure.secondsUntilBestGuess())
  //    let hours = departureSecs / (60 * 60)
  //    let secsNotInHours = departureSecs % (60 * 60)
  //    let mins = secsNotInHours / 60
  //    let secs = secsNotInHours % 60
  //
  //    var duration = ""
  //    if hours > 0 { duration += "\(hours)h " }
  //    if mins > 0 { duration += "\(mins)m " }
  //    if hours == 0 && mins == 0 { duration += "\(secs)s " }
  //
  //    return duration
  //  }
}
