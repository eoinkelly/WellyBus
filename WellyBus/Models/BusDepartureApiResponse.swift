//
//  BusDepartureApiResponse.swift
//  WellyBus
//
//  Created by Eoin Kelly on 26/10/2024.
//
import Foundation

struct BusDepartureApiResponse: Decodable {
  struct Origin: Decodable {
    let stopId: String
    let name: String

    enum CodingKeys: String, CodingKey {
      case stopId = "stop_id"
      case name
    }
  }

  struct Destination: Decodable {
    let stopId: String
    let name: String

    enum CodingKeys: String, CodingKey {
      case stopId = "stop_id"
      case name
    }
  }

  struct Arrival: Decodable {
    let aimed: String
    let expected: String
  }

  struct Departure: Decodable {
    let aimed: String
    let expected: String

    func bestGuess() -> Date {
      if !expected.isEmpty {
        return ISO8601DateFormatter().date(from: expected) ?? Date()
      }
      return ISO8601DateFormatter().date(from: aimed) ?? Date()
    }

    func secondsUntilBestGuess() -> TimeInterval {
      return bestGuess().timeIntervalSince(Date())
    }
  }

  let stopId: String
  let serviceId: String
  let direction: String
  let busOperator: String
  let origin: Origin
  let destination: Destination
  let delay: String
  let vehicleId: String
  let name: String
  let arrival: Arrival
  let departure: Departure
  let status: String
  let monitored: Bool
  let wheelchairAccessible: Bool
  let tripId: String

  enum CodingKeys: String, CodingKey {
    case stopId = "stop_id"
    case serviceId = "service_id"
    case direction
    case busOperator
    case origin
    case destination
    case delay
    case vehicleId = "vehicle_id"
    case name
    case arrival
    case departure
    case status
    case monitored
    case wheelchairAccessible = "wheelchair_accessible"
    case tripId = "trip_id"
  }
}
