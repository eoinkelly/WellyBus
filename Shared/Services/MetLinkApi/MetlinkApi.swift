import Foundation

enum MetlinkAPIError: Error {
  case error
  case badStopName
}

struct MetlinkAPI {
  static let shared = MetlinkAPI()

  private enum Constants {
    static let apiKeyHeader = "x-api-key"
    static let baseURL = URL(string: "https://api.opendata.metlink.org.nz/v1")!
  }

  private let apiKey: String
  private let session: URLSession

  private init(session: URLSession = .shared) {
    self.apiKey = metLinkApiKey
    self.session = session
  }

  func predictedDeparturesFor(stopName: String) async throws
    -> [StopPredictionsApiDeparture]
  {
    do {
      let request = buildStopPredictionRequest(for: stopName)
      let (data, _) = try await URLSession.shared.data(for: request)
      let response = try JSONDecoder().decode(StopPredictionsApiResponse.self, from: data)
      return response.departures
    } catch {
      logger.error("Error fetching departure predictions. stop=\(stopName) error=\(error)")
      throw MetlinkAPIError.error
    }
  }

  private func buildStopPredictionRequest(for stopName: String) -> URLRequest {
    var url = URL(string: "https://api.opendata.metlink.org.nz/v1/stop-predictions")!

    url.append(queryItems: [URLQueryItem(name: "stop_id", value: stopName)])

    var request = URLRequest(url: url)

    request.addValue(apiKey, forHTTPHeaderField: Constants.apiKeyHeader)

    return request
  }
}
