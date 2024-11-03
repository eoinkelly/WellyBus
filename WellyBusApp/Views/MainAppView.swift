//
//  LargeTextView.swift
//  WellyBus
//
//  Created by Eoin Kelly on 26/10/2024.
//

import SwiftUI

struct MainAppView: View {
  @State private var stopPredictions: [StopPrediction] = []
  @State private var lastUpdatedAt = Date()
  @State private var refreshButtonText = "Refresh"
  @State private var refreshInProgress = false

  //  private func refresh() {
  //    Task {
  //      stopPredictions = await BusStopPredictor().stopPredictions()
  //      lastFetchedAt = Date()
  //    }
  //  }

  var body: some View {
    VStack(alignment: .center) {
      HStack(alignment: .center) {
        HStack {
          Image(systemName: "bus.fill")
            .foregroundStyle(.yellow)
            .backgroundStyle(.red)

          Text("Welly Bus")
            .font(.title3)
        }
        .frame(maxWidth: .infinity, alignment: .leading)

        Button(
          action: {
            Task {
              refreshButtonText = "     ..."
              refreshInProgress = true
              stopPredictions = await BusStopPredictor().stopPredictions()
              lastUpdatedAt = Date()
              refreshButtonText = "Refresh"
              refreshInProgress = false
            }
          }
        ) {
          HStack(alignment: .center) {
            Image(systemName: "arrow.clockwise")
              .frame(alignment: .leading)
            Text(refreshButtonText)
              .frame(alignment: .leading)
          }
          .frame(minWidth: 100, alignment: .leading)
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
        .foregroundStyle(.black)
        .buttonStyle(.borderedProminent)
      }

      ScrollView {
        Grid {
          ForEach(stopPredictions) { stopPrediction in
            GridRow {
              StopPredictionView(stopPrediction: stopPrediction)
            }
          }
        }
        .onAppear {
          // TODO: figure out how to share this logic in one place
          print("onAppeaar XXXXXXXX")
          Task {
            refreshButtonText = "..."
            refreshInProgress = true
            stopPredictions = await BusStopPredictor().stopPredictions()
            lastUpdatedAt = Date()
            refreshButtonText = "Refresh"
            refreshInProgress = false
          }
        }
      }

      LastUpdateView(lastUpdatedAt: $lastUpdatedAt, refreshInProgress: $refreshInProgress)
      Divider()
      HelpView()
    }
    .padding([.leading, .trailing], 16)
  }
}

#Preview {
  MainAppView()
}
