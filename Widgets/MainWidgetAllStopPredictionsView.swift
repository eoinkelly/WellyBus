//
//  MainWidgetStopPredictionView.swift
//  WellyBus
//
//  Created by Eoin Kelly on 02/11/2024.
//
import SwiftUI
import WidgetKit

struct MainWidgetAllStopPredictionsView: View {
  var entry: WellyBusWidgetTimelineProvider.Entry

  let columns = [
    GridItem(.flexible(), spacing: 4),
    GridItem(.flexible(), spacing: 4),
    GridItem(.flexible(), spacing: 4),
  ]

  var body: some View {
    Grid {
      ForEach(entry.stopPredictions) { stopPrediction in
        GridRow {  // the stop prediction
          VStack(alignment: .leading, spacing: 0) {
            Divider()
            StopPredictionHeaderView(stopPrediction: stopPrediction)
              .padding([.bottom], 4)
            ConciseDeparturesView(departures: stopPrediction.departures)
          }
        }
      }
    }
  }
}
