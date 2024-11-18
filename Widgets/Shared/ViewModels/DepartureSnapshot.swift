import SwiftUI

struct DepartureSnapshot: Identifiable {
  let id = UUID()
  let serviceId: String
  let direction: String
  let scheduledAt: Date?
  let expectedAt: Date?
  let bestDepartureTimeGuess: Date
  let foregroundColor: Color
  let backgroundColor: Color
}
