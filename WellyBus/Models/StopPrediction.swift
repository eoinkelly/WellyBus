//
//  StopPrediction.swift
//  WellyBus
//
//  Created by Eoin Kelly on 29/10/2024.
//
import Foundation

class StopPrediction: Identifiable {
  let id = UUID()
  let stopConfig: StopConfig
  var cachedDepatures: [StopPredictionsApiDeparture]? = nil
  let name: String

  init(stopConfig: StopConfig) {
    self.stopConfig = stopConfig
    self.name = stopConfig.friendlyName
  }

  func departures(allowFromCache: Bool = true) async -> [StopPredictionsApiDeparture] {
    if allowFromCache {
      if let cachedDepatures = self.cachedDepatures { return cachedDepatures }
    }

    let allDepartures = await MetlinkApi.shared.predictedDeparturesForStop(stopConfig)

    self.cachedDepatures = allDepartures.filter { stopConfig.followedBusIds.contains($0.serviceId) }

    return self.cachedDepatures ?? []
  }
}
