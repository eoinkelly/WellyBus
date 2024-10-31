import Foundation

struct BusStopPredictor {
  func stopPredictions() async -> [StopPrediction] {
    var predictions: [StopPrediction] = []

    for stop in Config.shared.busStopsOfInterest {
      let p = await StopPrediction(stopConfig: stop)
      predictions.append(p)
    }

    return predictions
  }
}
