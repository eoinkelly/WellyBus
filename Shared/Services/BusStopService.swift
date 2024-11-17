import Foundation

struct BusStopService {
  static let shared = BusStopService()

  func fetchBusStopsFromMetlink(maxDeparturesPerStop: Int? = nil) async -> [BusStop] {
    var stops: [BusStop] = []

    do {
      for stopConfig in AppConfig.shared.busStopsOfInterest {
        logNotice("Start building models for stop=\(stopConfig.stopId)")

        let allDepartures = try await MetlinkAPI.shared.predictedDeparturesFor(
          stopName: stopConfig.stopId)
        let departuresFetchedAt = Date()
        let followedBusRouteNames = stopConfig.followedBusRoutes.map { $0.name }

        var departuresOfInterest =
          allDepartures
          .filter { followedBusRouteNames.contains($0.serviceId) }
          .map { departure in
            let route = AppConfig.shared.followedBusRoutes.first(where: {
              $0.name == departure.serviceId
            })!

            return BusDeparture(
              serviceId: departure.serviceId,
              direction: departure.direction,
              scheduledAt: departure.departure.aimedDate,
              expectedAt: departure.departure.expectedDate,
              foregroundColor: route.foregroundColor,
              backgroundColor: route.backgroundColor
            )
          }

        if let maxDeparturesPerStop = maxDeparturesPerStop {
          departuresOfInterest = Array(departuresOfInterest.prefix(maxDeparturesPerStop))
        }

        let stop = BusStop(
          stopName: stopConfig.stopId,
          nickName: stopConfig.friendlyName,
          departures: departuresOfInterest,
          direction: stopConfig.direction,
          departuresFetchedAt: departuresFetchedAt
        )

        stops.append(stop)
      }

      logNotice(
        "Successfully Created \(stops.count) BusStop models for: \(stops.map { "'\($0.nickName)'" }.joined(separator: ", "))"
      )

      return stops
    } catch {
      logError("Unexpected error: \(error)")
      return []
    }
  }

  // Returns the next departure of any bus from any stop
  func nextDeparture(for stops: [BusStop]) -> Date? {
    let next =
      stops
      .compactMap({ stop in
        if let nextDeparture = stop.departures.compactMap({ $0.bestDepartureTimeGuess }).min() {
          return (name: stop.nickName, nextDeparture: nextDeparture)
        } else {
          return nil
        }
      })
      .min(by: { $0.nextDeparture < $1.nextDeparture })

    if let (name, depTime) = next {
      logNotice("Next departure of any bus from stop '\(name)` is \(Debug.asRelativeTime(depTime))")
      return depTime
    }

    return nil
  }

  private func logNotice(_ msg: String) {
    Log.log("BusStopService: \(msg)", logger: .service)
  }

  private func logError(_ msg: String) {
    Log.error("BusStopService: \(msg)", logger: .service)
  }
}
