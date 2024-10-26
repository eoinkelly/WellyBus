//
//  Config.swift
//  WellyBus
//
//  Created by Eoin Kelly on 27/10/2024.
//

class Config {
  static let shared = Config()

  //  var username: String?
  let busStopsOfInterest: [BusStopOfInterest]

  private init() {
    self.busStopsOfInterest = [
      BusStopOfInterest(
        friendlyName: "Nearest work",
        stopId: "5014",
        priorityBusIds: ["52", "58"],
        ordinaryBusIds: ["56", "57"],
        direction: BusDirection.toHome
      ),
      BusStopOfInterest(
        friendlyName: "St. James Theatre",
        stopId: "5002",
        priorityBusIds: ["52", "58"],
        ordinaryBusIds: ["56", "57"],
        direction: BusDirection.toHome
      ),
      BusStopOfInterest(
        friendlyName: "Newlands Road/Black Rock Road",
        stopId: "3546",
        priorityBusIds: ["52", "58"],
        ordinaryBusIds: ["56", "57"],
        direction: BusDirection.toTown
      ),
      BusStopOfInterest(
        friendlyName: "Glanmire Road/Truville Cr",
        stopId: "3772",
        priorityBusIds: ["52", "58"],
        ordinaryBusIds: ["56", "57"],
        direction: BusDirection.toTown
      ),
    ]

  }
}
