//
//  WidgetView.swift
//  WellyBus
//
//  Created by Eoin Kelly on 01/11/2024.
//

import SwiftUI
import WidgetKit

struct MainWidgetView: View {
  var entry: WellyBusWidgetTimelineProvider.Entry

  var body: some View {
    HStack(alignment: .center) {
      HStack {
        Image(systemName: "bus.fill")
          .foregroundStyle(.yellow)
          .backgroundStyle(.red)

        Text("Welly Bus Widget")
          .font(.title3)
      }
      .frame(maxWidth: .infinity, alignment: .leading)
    }
    .padding([.leading, .trailing], 16)

    Text("Last updated at ...")
      .font(.caption)
      .padding(4)

    Grid {
      ForEach(entry.stopPredictions) { stopPrediction in
        GridRow {
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
              ForEach(stopPrediction.departures) { departure in
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
    }
  }
}
