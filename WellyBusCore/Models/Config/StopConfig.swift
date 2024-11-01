//
//  BusStop.swift
//  WellyBus
//
//  Created by Eoin Kelly on 26/10/2024.
//

enum BusDirection: String, Codable {
  case toTown
  case toHome
}

struct StopConfig {
  let friendlyName: String
  let stopId: String
  let followedBusIds: Set<String>
  let direction: BusDirection

  func formattedDirection() -> String {
    switch direction {
    case .toTown: return "To town"
    case .toHome: return "To home"
    }
  }
}
