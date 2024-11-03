//
//  WellyBusTests.swift
//  WellyBusTests
//
//  Created by Eoin Kelly on 26/10/2024.
//

import Foundation
import Testing

@testable import WellyBus

struct MetlinkResponseTests {
  @Test func decodesRealExampleAPIResponse() throws {
    #expect(throws: Never.self) {
      try JSONDecoder().decode(
        StopPredictionsApiResponse.self, from: stopPredictionsApiResponseExample)
    }
  }
}
