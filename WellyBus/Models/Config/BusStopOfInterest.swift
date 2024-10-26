//
//  BusStop.swift
//  WellyBus
//
//  Created by Eoin Kelly on 26/10/2024.
//

struct BusStopOfInterest {
  let friendlyName: String
  let stopNumber: Int
  let priorityBusNumbers: Set<String>
  let ordinaryBusNumbers: Set<String>
}
