//
//  LargeTextView.swift
//  WellyBus
//
//  Created by Eoin Kelly on 26/10/2024.
//

import SwiftUI

struct StopPredictionsView: View {
  @State private var stopPredictions: [StopPrediction] = []
  @State private var lastFetchedAt = "..."

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
          stopPredictions = BusStopPredictor().stopPredictions()
          lastFetchedAt = prettyNow()
        }
      }
      .frame(maxWidth: .infinity, alignment: .trailing)
    }
    .padding([.leading, .trailing], 16)

    Text("Last updated at \(lastFetchedAt)")
      .font(.caption)
      .padding(4)

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
          stopPredictions = BusStopPredictor().stopPredictions()
          lastFetchedAt = prettyNow()
        }
      }
    }
  }

  private func prettyNow() -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm"
    return formatter.string(from: Date())
  }
}

#Preview {
  StopPredictionsView()
}
