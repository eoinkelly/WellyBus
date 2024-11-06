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
            MainWidgetStopPredictionHeaderView(stopPrediction: stopPrediction)
              .padding([.bottom], 4)
            MainWidgetDeparturesView(stopPrediction: stopPrediction, maxDeparturesToShow: 4)
          }
        }
      }
    }
  }
}
