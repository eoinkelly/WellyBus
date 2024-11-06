import Foundation
import SwiftUI

class StopPrediction: Identifiable {
  let id = UUID()
  let stopConfig: BusStopConfig
  var departures: [StopPredictionsApiDeparture]
  let name: String
  let fetchedAt: Date

  init(stopConfig: BusStopConfig) async {
    self.stopConfig = stopConfig
    self.name = stopConfig.friendlyName

    // TODO: handle network errors with `try await` and throwing
    let allDepartures = await MetlinkApi.shared.predictedDeparturesForStop(stopConfig)

    let followedBusRouteNames = stopConfig.followedBusRoutes.map { $0.name }

    self.departures = allDepartures.filter { followedBusRouteNames.contains($0.serviceId) }
    self.fetchedAt = Date()
  }

  func busRouteForegroundColor(for serviceId: String) -> Color {
    let route = stopConfig.followedBusRoutes.first { $0.name == serviceId }
    return route?.foregroundColor ?? Color(.lightGray)
  }

  func busRouteBackgroundColor(for serviceId: String) -> Color {
    let route = stopConfig.followedBusRoutes.first { $0.name == serviceId }
    return route?.backgroundColor ?? Color(.lightGray)
  }
}
