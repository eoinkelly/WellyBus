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

struct BusStopOfInterest {
  let friendlyName: String
  let stopId: String
  let priorityBusIds: Set<String>
  let ordinaryBusIds: Set<String>
  let direction: BusDirection
}
