//
//  MetlinkResponse.swift
//  WellyBus
//
//  Created by Eoin Kelly on 26/10/2024.
//

struct StopPredictionsApiResponse: Decodable {
  let departures: [StopPredictionsApiDeparture]
}
