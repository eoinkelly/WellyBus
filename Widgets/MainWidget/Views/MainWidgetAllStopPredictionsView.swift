import SwiftUI
import WidgetKit

struct MainWidgetAllStopPredictionsView: View {
  var entry: WellyBusWidgetTimelineProvider.Entry

  var body: some View {
    Grid {
      ForEach(entry.busStops) { busStop in
        GridRow {
          VStack(alignment: .leading, spacing: 0) {
            Divider()
            MainWidgetStopPredictionHeaderView(busStop: busStop)
              .padding([.bottom], 4)
            MainWidgetDeparturesView(busStop: busStop)
          }
        }
      }
    }
  }
}
