//
//  Config.swift
//  WellyBus
//
//  Created by Eoin Kelly on 27/10/2024.
//

class Config {
  static let shared = Config()

  let busStopsOfInterest: [StopConfig]

  private init() {
    // Someday this could be loaded from somewhere user editable

    self.busStopsOfInterest = [
      StopConfig(
        //        friendlyName: "Glanmire Road/Truville Cr",
        friendlyName: "Up the top",
        stopId: "3772",
        followedBusIds: ["52", "58", "56", "57", "N5"],
        direction: BusDirection.toTown
      ),
      StopConfig(
        //        friendlyName: "Newlands Road/Black Rock Road",
        friendlyName: "Down the bottom",
        stopId: "3546",
        followedBusIds: ["52", "58", "56", "57", "N5"],
        direction: BusDirection.toTown
      ),
      StopConfig(
        friendlyName: "Outside DoC",
        stopId: "5006",
        followedBusIds: ["52", "58", "56", "57", "N5"],
        direction: BusDirection.toHome
      ),
      StopConfig(
        friendlyName: "Lambton Quay",
        stopId: "5014",
        followedBusIds: ["52", "58", "56", "57", "N5"],
        direction: BusDirection.toHome
      ),
    ]

  }
}
