import SwiftUI

struct MainAppView: View {
  @State private var stopPredictions: [StopPrediction] = []
  @State private var lastUpdatedAt = Date()
  @State private var refreshButtonText = "Refresh"
  @State private var refreshInProgress = false

  @Environment(\.scenePhase) var scenePhase

  private func refresh() {
    Task {
      print("in refresh task")
      let oldButtonText = refreshButtonText
      refreshButtonText = "      ..."
      refreshInProgress = true
      stopPredictions = await BusStopPredictor().stopPredictions()
      lastUpdatedAt = Date()
      refreshButtonText = oldButtonText
      refreshInProgress = false
    }
  }

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
            refresh()
          }
        ) {
          HStack(alignment: .center) {
            Image(systemName: "arrow.clockwise")
              .frame(alignment: .leading)
            Text(refreshButtonText)
              .frame(alignment: .leading)
          }
          .padding([.leading, .trailing], 10)
          .padding([.top, .bottom], 8)
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
        .onChange(of: scenePhase, initial: true) { _oldPhase, newPhase in
          if newPhase == .active {
            refresh()
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
