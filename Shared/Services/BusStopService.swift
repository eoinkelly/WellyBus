import Foundation

struct BusStopService {
  static let shared = BusStopService()

  // fetchNewBusStops
  func refreshBusStops() async -> [BusStop] {
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
          BusDeparture(
            serviceId: departure.serviceId,
            direction: departure.direction,
            scheduledAt: departure.departure.aimedDate,
            expectedAt: departure.departure.expectedDate,
            foregroundColor: .white,
            backgroundColor: .red
          )
        }
        .prefix(6)
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

  func nextDeparture(for: [BusStop]) -> Date {
    // TODO: make real
    //    return Date()
    // return time 1 minute from now
    Calendar.current.date(byAdding: .minute, value: 1, to: Date())!
  }
}
