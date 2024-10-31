//
//  StopPredictionView.swift
//  WellyBus
//
//  Created by Eoin Kelly on 29/10/2024.
//

import SwiftUI

struct StopPredictionView: View {
  @State public var stopPrediction: StopPrediction

  let numDeparturesToShow = 5

  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      HStack(alignment: .center) {
        Image(systemName: "location")

        Text(stopPrediction.name)
          .font(.title3)
          .fontWeight(.light)

        Image(systemName: "arrow.forward")

        switch stopPrediction.stopConfig.direction {
        case .toHome:
          Image(systemName: "house")
          Text("Home")
            .font(.title3)
            .fontWeight(.light)
        case .toTown:
          Image(systemName: "building.2")
          Text("Town")
            .font(.title3)
            .fontWeight(.light)
        }
      }

      Grid(alignment: .leading, horizontalSpacing: 4, verticalSpacing: 8) {
        ForEach(stopPrediction.departures.prefix(numDeparturesToShow)) { departure in
          GridRow(alignment: .firstTextBaseline) {
            Text(departure.serviceId)
            Text("leaves in")
              .fontWeight(.light)

            Text(departure.departure.timeUntil())
              .gridColumnAlignment(.trailing)
              .fontWeight(.bold)
          }
          Divider()  // TODO: how to get full width without this?
        }
      }
    }
    .padding([.leading, .trailing], 24)
  }
}

//#Preview {
//  StopPredictionView()
//}
