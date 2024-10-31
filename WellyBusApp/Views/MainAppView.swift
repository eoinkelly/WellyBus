//
//  LargeTextView.swift
//  WellyBus
//
//  Created by Eoin Kelly on 26/10/2024.
//

import SwiftUI

struct MainAppView: View {
  @State private var stopPredictions: [StopPrediction] = []
  @State private var lastFetchedAt = "Never"

  var body: some View {
    HStack(alignment: .center) {
      HStack {
        Image(systemName: "bus.fill")
          .foregroundStyle(.yellow)
          .backgroundStyle(.red)

        Text("Welly Bus")
          .font(.title3)
      }
      .frame(maxWidth: .infinity, alignment: .leading)

      Button("Refresh", systemImage: "arrow.clockwise") {
        Task {
          lastFetchedAt = "..."
          stopPredictions = await BusStopPredictor().stopPredictions()
          lastFetchedAt = prettyNow()
        }
      }
      .frame(maxWidth: .infinity, alignment: .trailing)
    }
    .padding([.leading, .trailing], 16)

    Text("Last updated at \(lastFetchedAt)")
      .font(.footnote)
      .padding([.leading, .trailing], 16)
      .padding([.top, .bottom], 1)
      .frame(maxWidth: .infinity, alignment: .leading)

    ScrollView {
      Grid {
        ForEach(stopPredictions) { stopPrediction in
          GridRow {
            StopPredictionView(stopPrediction: stopPrediction)
          }
        }
      }
      .onAppear {
        Task {
          stopPredictions = await BusStopPredictor().stopPredictions()
          lastFetchedAt = prettyNow()
        }
      }
    }
  }

  private func prettyNow() -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "d MMM HH:mm:ss"
    return formatter.string(from: Date())
  }
}

#Preview {
  MainAppView()
}
