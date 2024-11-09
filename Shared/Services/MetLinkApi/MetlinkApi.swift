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

  func predictedDeparturesFor(stopName: String) async
    -> [StopPredictionsApiDeparture]
  {
    do {
      var url = URL(string: "https://api.opendata.metlink.org.nz/v1/stop-predictions")!

      url.append(queryItems: [URLQueryItem(name: "stop_id", value: stopName)])

      var request = URLRequest(url: url)
      request.addValue(apiKeyValue, forHTTPHeaderField: apiKeyHttpHeaderName)

      let (data, _) = try await URLSession.shared.data(for: request)

      //      if let dataString = String(data: data, encoding: .utf8) {
      //        print("----------------------")
      //        print(dataString)
      //        print("----------------------")
      //      } else {
      //        print("Failed to convert data to string")
      //      }

      let response = try JSONDecoder().decode(StopPredictionsApiResponse.self, from: data)
      return response.departures

    } catch {
      logger.error("Error fetching departure predictions. stop=\(stopName) error=\(error)")
      return []
    }
  }

  //  func predictedDepartures(forStops stops: [BusStopConfig], urlSession: URLSession = .shared)
  //    -> AsyncThrowingStream<[StopPredictionsApiDeparture], Error>
  //  {
  //    var index = 0
  //
  //    return AsyncThrowingStream {
  //      guard index < stops.count else {
  //        return nil
  //      }
  //
  //      let stop = stops[index]
  //      index += 1
  //
  //      var url = URL(string: "https://api.opendata.metlink.org.nz/v1/stop-predictions")!
  //      url.append(queryItems: [URLQueryItem(name: "stop_id", value: stop.stopId)])
  //      var request = URLRequest(url: url)
  //      request.addValue(self.apiKeyValue, forHTTPHeaderField: self.apiKeyHttpHeaderName)
  //
  //      let (data, _) = try await urlSession.data(for: request)
  //      let response = try JSONDecoder().decode(StopPredictionsApiResponse.self, from: data)
  //      return response.departures
  //    }
  //
  //    do {
  //      var url = URL(string: "https://api.opendata.metlink.org.nz/v1/stop-predictions")!
  //
  //      url.append(queryItems: [URLQueryItem(name: "stop_id", value: stop.stopId)])
  //
  //      var request = URLRequest(url: url)
  //      request.addValue(apiKeyValue, forHTTPHeaderField: apiKeyHttpHeaderName)
  //
  //      let (data, _) = try await URLSession.shared.data(for: request)
  //
  //      //      if let dataString = String(data: data, encoding: .utf8) {
  //      //        print("----------------------")
  //      //        print(dataString)
  //      //        print("----------------------")
  //      //      } else {
  //      //        print("Failed to convert data to string")
  //      //      }
  //
  //      let response = try JSONDecoder().decode(StopPredictionsApiResponse.self, from: data)
  //      return response.departures
  //
  //    } catch {
  //      logger.error("Error fetching departure predictions. stop=\(stop.stopId) error=\(error)")
  //      return []
  //    }
  //  }

  //  func remoteDataStream(
  //    forURLs urls: [URL],
  //    urlSession: URLSession = .shared
  //  ) -> AsyncThrowingStream<Data, Error> {
  //    var index = 0
  //
  //    return AsyncThrowingStream {
  //      guard index < urls.count else {
  //        return nil
  //      }
  //
  //      let url = urls[index]
  //      index += 1
  //
  //      let (data, _) = try await urlSession.data(from: url)
  //      return data
  //    }
  //  }
}
