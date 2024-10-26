//
//  MetlinkApi.swift
//  WellyBus
//
//  Created by Eoin Kelly on 27/10/2024.
//

import Foundation

class MetlinkApi {
  static let shared = MetlinkApi()

  let apiKeyValue: String
  let apiKeyHttpHeaderName: String = "x-api-key"

  private init() {
    self.apiKeyValue = metLinkApiKey
  }

  func predictedDeparturesForStop(_ stop: BusStopOfInterest) async
    -> [StopPredictionsApiDeparture]
  {
    // TODO: shorter syntax for this guard since I know it will succeed?
    guard var url = URL(string: "https://api.opendata.metlink.org.nz/v1/stop-predictions")
    else {
      return []
    }

    url.append(queryItems: [URLQueryItem(name: "stop_id", value: stop.stopId)])

    print("Stop number: \(stop.stopId)")
    print("URL: \(url)")

    var request = URLRequest(url: url)
    request.addValue(apiKeyValue, forHTTPHeaderField: apiKeyHttpHeaderName)

    do {
      let (data, _) = try await URLSession.shared.data(for: request)

      //            if let dataString = String(data: data, encoding: .utf8) {
      //              print("----------------------")
      //              print(dataString)
      //              print("----------------------")
      //            } else {
      //              print("Failed to convert data to string")
      //            }

      let response = try JSONDecoder().decode(StopPredictionsApiResponse.self, from: data)
      return response.departures

    } catch {
      logger.error("AAA Error fetching departs: \(error)")
      return []
    }
  }
}
