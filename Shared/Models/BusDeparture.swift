import Foundation
import SwiftUI

struct BusDeparture: Identifiable {
  let id = UUID()
  let serviceId: String
  let direction: String
  let scheduledAt: Date?
  let expectedAt: Date?
  let foregroundColor: Color
  let backgroundColor: Color

  var bestDepartureTimeGuess: Date? {
    expectedAt ?? scheduledAt
  }
}
