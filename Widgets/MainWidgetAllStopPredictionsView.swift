import SwiftUI
import WidgetKit

struct MainWidgetAllStopPredictionsView: View {
  var entry: WellyBusWidgetTimelineProvider.Entry

  var body: some View {
    Grid {
      ForEach(entry.stopPredictions) { stopPrediction in
        GridRow {
          VStack(alignment: .leading, spacing: 0) {
            Divider()
            StopPredictionHeaderView(stopPrediction: stopPrediction)
              .padding([.bottom], 4)
            ConciseDeparturesView(stopPrediction: stopPrediction, maxDeparturesToShow: 4)
          }
        }
      }
    }
  }
}
