//
//  WellyBusTests.swift
//  WellyBusTests
//
//  Created by Eoin Kelly on 26/10/2024.
//

import Foundation
import Testing

@testable import WellyBus

//struct WellyBusTests {
//
//  @Test func example() async throws {
//    // Write your test here and use APIs like `#expect(...)` to check expected conditions.
//  }
//
//}

struct BusDepartureApiResponseTests {
  @Test func testDecodingValidResponse() throws {
    // Given
    let json = """
      {
          "stop_id": "WGTN-STOP1",
          "service_id": "SERV123",
          "direction": "inbound",
          "operator": "Metlink",
          "origin": {
              "stop_id": "STOP_A",
              "name": "Wellington Station"
          },
          "destination": {
              "stop_id": "STOP_B",
              "name": "Karori Park"
          },
          "delay": "PT5M",
          "vehicle_id": "BUS123",
          "name": "Route 2",
          "arrival": {
              "aimed": "2024-10-26T10:00:00Z",
              "expected": "2024-10-26T10:05:00Z"
          },
          "departure": {
              "aimed": "2024-10-26T10:02:00Z",
              "expected": "2024-10-26T10:07:00Z"
          },
          "status": "ON_TIME",
          "monitored": true,
          "wheelchair_accessible": true,
          "trip_id": "TRIP123"
      }
      """.data(using: .utf8)!

    // When
    let response = try JSONDecoder().decode(StopPredictionsApiDeparture.self, from: json)

    // Then
    #expect(response.stopId == "WGTN-STOP1", "stopId should match")
    #expect(response.serviceId == "SERV123", "serviceId should match")
    #expect(response.direction == "inbound", "direction should match")
    #expect(response.busOperator == "Metlink", "busOperator should match")
    #expect(response.origin.stopId == "STOP_A", "origin stopId should match")
    #expect(response.origin.name == "Wellington Station", "origin name should match")
    #expect(response.destination.stopId == "STOP_B", "destination stopId should match")
    #expect(response.destination.name == "Karori Park", "destination name should match")
    #expect(response.delay == "PT5M", "delay should match")
    #expect(response.vehicleId == "BUS123", "vehicleId should match")
    #expect(response.name == "Route 2", "name should match")
    #expect(response.monitored == true, "monitored should be true")
    #expect(response.wheelchairAccessible == true, "wheelchairAccessible should be true")
  }

  @Test func testDecodingWithOptionalFields() throws {
    // Given
    let json = """
      {
          "stop_id": "WGTN-STOP1",
          "service_id": "SERV123",
          "direction": "inbound",
          "operator": "Metlink",
          "origin": {
              "stop_id": "STOP_A",
              "name": "Wellington Station"
          },
          "destination": {
              "stop_id": "STOP_B",
              "name": "Karori Park"
          },
          "delay": "PT5M",
          "vehicle_id": null,
          "name": "Route 2",
          "arrival": {
              "aimed": "2024-10-26T10:00:00Z",
              "expected": "2024-10-26T10:05:00Z"
          },
          "departure": {
              "aimed": "2024-10-26T10:02:00Z",
              "expected": "2024-10-26T10:07:00Z"
          },
          "status": "ON_TIME",
          "monitored": true,
          "wheelchair_accessible": true,
          "trip_id": "TRIP123"
      }
      """.data(using: .utf8)!

    // When
    let response = try JSONDecoder().decode(StopPredictionsApiDeparture.self, from: json)

    // Then
    #expect(response.vehicleId == nil, "vehicleId should be nil")
  }

  @Test func testDepartureBestGuessWithExpected() throws {
    // Given
    let departure = StopPredictionsApiDeparture.Departure(
      aimed: "2024-10-26T10:00:00Z",
      expected: "2024-10-26T10:05:00Z"
    )

    // When
    let bestGuess = departure.bestGuess()

    // Then
    let formatter = ISO8601DateFormatter()
    let expectedDate = formatter.date(from: "2024-10-26T10:05:00Z")!
    #expect(bestGuess == expectedDate, "bestGuess should use expected time")
  }

  @Test
  func testDepartureBestGuessWithEmptyExpected() throws {
    // Given
    let departure = StopPredictionsApiDeparture.Departure(
      aimed: "2024-10-26T10:00:00Z",
      expected: ""
    )

    // When
    let bestGuess = departure.bestGuess()

    // Then
    let formatter = ISO8601DateFormatter()
    let expectedDate = formatter.date(from: "2024-10-26T10:00:00Z")!
    #expect(bestGuess == expectedDate, "bestGuess should fall back to aimed time")
  }

  @Test
  func testDepartureSecondsUntilBestGuess() throws {
    // Given
    let departure = StopPredictionsApiDeparture.Departure(
      aimed: "2024-10-26T10:00:00Z",
      expected: "2024-10-26T10:05:00Z"
    )

    // When
    let seconds = departure.secondsUntilBestGuess()

    // Then
    #expect(seconds < 0, "seconds should be negative for past dates")
  }

  @Test
  func testDecodingInvalidJSON() throws {
    // Given
    let invalidJSON = "invalid json".data(using: .utf8)!

    #expect(throws: DecodingError.self) {
      try JSONDecoder().decode(StopPredictionsApiDeparture.self, from: invalidJSON)
    }
  }
}
