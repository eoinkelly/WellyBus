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
  var departures: [StopPredictionsApiDeparture]
  let name: String
  let fetchedAt: Date

  init(stopConfig: StopConfig) async {
    self.stopConfig = stopConfig
    self.name = stopConfig.friendlyName

    // TODO: handle network errors with `try await` and throwing
    let allDepartures = await MetlinkApi.shared.predictedDeparturesForStop(stopConfig)

    self.departures = allDepartures.filter { stopConfig.followedBusIds.contains($0.serviceId) }
    self.fetchedAt = Date()
  }
}
