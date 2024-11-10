import Foundation

struct BusStopService {
  static let shared = BusStopService()
  static let maxDeparturesToShowPerStop = 6

  func fetchBusStopsFromMetlink() async -> [BusStop] {
    var stops: [BusStop] = []

    for stopConfig in AppConfig.shared.busStopsOfInterest {
      // TODO: handle network errors with `try await` and throwing
      let allDepartures = await MetlinkApi.shared.predictedDeparturesFor(
        stopName: stopConfig.stopId)
      let followedBusRouteNames = stopConfig.followedBusRoutes.map { $0.name }
      let departuresSlice =
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
        .prefix(Self.maxDeparturesToShowPerStop)
      let departures = Array(departuresSlice)

      let stop = BusStop(
        stopName: stopConfig.stopId,
        nickName: stopConfig.friendlyName,
        departures: departures,
        direction: stopConfig.direction
      )

      stops.append(stop)
    }

    return stops
  }

  func nextDeparture(for stops: [BusStop]) -> Date? {

    // TODO: tidy this up, is messy af
    let x =
      stops
      .compactMap({ stop in
        if let nextDeparture = stop.departures.compactMap({ $0.bestDepartureTimeGuess }).min() {
          return (stop.nickName, nextDeparture)
        } else {
          return nil
        }
      }
      )
      .min(by: { $0.1 < $1.1 })

    if let (name, depTime) = x {
      Debug.dumpTime(time: depTime, message: "Next depature of any bus is at stop '\(name)` in ")
      return depTime
    }

    return nil
  }
}
