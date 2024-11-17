import Foundation

enum MetlinkAPIError: LocalizedError {
  case invalidURL
  case invalidResponse
  case unauthorized
  case rateLimitExceeded
  case serverError(code: Int)
  case networkError(underlying: Error)
  case jsonDecodeError(underlying: Error)
  case invalidStopName
  case noData
  case unexpectedStatusCode(code: Int)

  var errorDescription: String? {
    switch self {
    case .invalidURL:
      return "Invalid URL constructed"
    case .invalidResponse:
      return "Invalid response from server"
    case .unauthorized:
      return "Unauthorized - Check API key"
    case .rateLimitExceeded:
      return "Rate limit exceeded"
    case .serverError(let code):
      return "Server error occurred (Code: \(code))"
    case .networkError(let error):
      return "Network error: \(error.localizedDescription)"
    case .jsonDecodeError(let error):
      return "Failed to decode response: \(error.localizedDescription)"
    case .invalidStopName:
      return "Invalid stop name provided"
    case .noData:
      return "No data received from server"
    case .unexpectedStatusCode(let code):
      return "Unexpected status code received: \(code)"
    }
  }
}

struct MetlinkAPI {
  static let shared = MetlinkAPI()

  private enum Constants {
    static let apiKeyHeader = "x-api-key"
    static let baseURL = URL(string: "https://api.opendata.metlink.org.nz/v1")!
    static let predictionsPath = "stop-predictions"
    static let timeout: TimeInterval = 30
  }

  private let apiKey: String
  private let session: URLSession

  private init(session: URLSession = .shared) {
    self.apiKey = metLinkApiKey

    // Configure URLSession with timeout and other parameters
    let configuration = URLSessionConfiguration.default
    configuration.timeoutIntervalForRequest = Constants.timeout
    configuration.timeoutIntervalForResource = Constants.timeout
    self.session = URLSession(configuration: configuration)
  }

  func predictedDeparturesFor(stopName: String) async throws -> [StopPredictionsApiDeparture] {
    guard !stopName.isEmpty else {
      logError(stopName: stopName, msg: "Invalid stop name provided")
      throw MetlinkAPIError.invalidStopName
    }

    do {
      logNotice(stopName: stopName, msg: "Start data fetch from API")

      let request = try buildStopPredictionRequest(for: stopName)
      let (data, response) = try await session.data(for: request)

      // We require a HTTPURLResponse so we can validate its status code
      guard let httpResponse = response as? HTTPURLResponse else {
        logError(stopName: stopName, msg: "Invalid response type received")
        throw MetlinkAPIError.invalidResponse
      }

      logNotice(stopName: stopName, msg: "Got HTTP \(httpResponse.statusCode) from server")

      // Validate response status code
      try validateResponse(httpResponse, stopName: stopName)

      // Validate data
      guard !data.isEmpty else {
        logError(stopName: stopName, msg: "No data received")
        throw MetlinkAPIError.noData
      }

      // Decode response
      let decoder = JSONDecoder()
      decoder.dateDecodingStrategy = .iso8601  // If dates are in ISO format

      do {
        let response = try decoder.decode(StopPredictionsApiResponse.self, from: data)
        logNotice(stopName: stopName, msg: "END: Data fetch from API")
        return response.departures
      } catch {
        logError(stopName: stopName, msg: "JSON decode error: \(error)")
        throw MetlinkAPIError.jsonDecodeError(underlying: error)
      }

    } catch let error as MetlinkAPIError {
      // Already logged and properly typed error, just rethrow
      throw error
    } catch {
      // Handle any other errors
      logError(stopName: stopName, msg: "Unexpected error: \(error)")
      throw MetlinkAPIError.networkError(underlying: error)
    }
  }

  private func buildStopPredictionRequest(for stopName: String) throws -> URLRequest {
    guard
      var components = URLComponents(
        url: Constants.baseURL.appendingPathComponent(Constants.predictionsPath),
        resolvingAgainstBaseURL: true)
    else {
      throw MetlinkAPIError.invalidURL
    }

    components.queryItems = [URLQueryItem(name: "stop_id", value: stopName)]

    guard let url = components.url else {
      throw MetlinkAPIError.invalidURL
    }

    var request = URLRequest(url: url)
    request.addValue(apiKey, forHTTPHeaderField: Constants.apiKeyHeader)
    request.timeoutInterval = Constants.timeout

    return request
  }

  private func validateResponse(_ response: HTTPURLResponse, stopName: String) throws {
    switch response.statusCode {
    case 200...299:
      return  // Success
    case 401:
      logError(stopName: stopName, msg: "Unauthorized - check API key")
      throw MetlinkAPIError.unauthorized
    case 429:
      logError(stopName: stopName, msg: "Rate limit exceeded")
      throw MetlinkAPIError.rateLimitExceeded
    case 500...599:
      logError(stopName: stopName, msg: "Server error: \(response.statusCode)")
      throw MetlinkAPIError.serverError(code: response.statusCode)
    default:
      logError(stopName: stopName, msg: "Unexpected status code: \(response.statusCode)")
      throw MetlinkAPIError.unexpectedStatusCode(code: response.statusCode)
    }
  }

  private func logNotice(stopName: String, msg: String) {
    Log.notice("stop=\(stopName) \(msg)", logger: .metlinkApi)
  }

  private func logError(stopName: String, msg: String) {
    Log.error("stop=\(stopName) \(msg)", logger: .metlinkApi)
  }
}
