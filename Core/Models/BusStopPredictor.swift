import Foundation

struct BusStopPredictor {
  func refreshPredictions() async -> [StopPrediction] {
    var predictions: [StopPrediction] = []

    for stop in AppConfig.shared.busStopsOfInterest {
      let p = await StopPrediction(stopConfig: stop)
      predictions.append(p)
    }

    return predictions
  }
}
