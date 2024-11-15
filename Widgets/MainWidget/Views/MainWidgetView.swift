import SwiftUI
import WidgetKit

struct MainWidgetView: View {
  var entry: MainWidgetTimelineProvider.Entry

  @State private var lastUpdatedAt: Date
  @State private var refreshInProgress: Bool

  init(entry: MainWidgetTimelineProvider.Entry) {
    self.entry = entry
    self.lastUpdatedAt = entry.date
    self.refreshInProgress = false
  }

  var body: some View {
    VStack(alignment: .leading) {
      HStack(alignment: .center, spacing: 4) {
        Text("TL_age =")
          .font(.caption)

        //        Text(entry.debug.createdAt, style: .relative)
        //          .font(.caption)
        //          .border(.blue)
        //          .frame(maxWidth: 100, alignment: .leading)

        Text(
          TimeDataSource<Date>.durationOffset(to: entry.debug.createdAt),
          format: .units(
            allowed: [.hours, .minutes, .seconds],
            width: .narrow,
            fractionalPart: .hide(rounded: .down)
          )
        )
        .font(.caption)
        //        .border(.green)
        .frame(maxWidth: 100, alignment: .leading)

        Text(
          "TL_Entry \(entry.debug.containingTimelineIndex) of \(entry.debug.containingTimelineLength)"
        )
        .font(.caption)
        //        .border(.blue)
      }
      .frame(maxWidth: .infinity, alignment: .leading)

      Grid {
        ForEach(entry.busStopSnapshots) { busStopSnapshot in
          GridRow {
            VStack(alignment: .leading, spacing: 0) {
              Divider()
              MainWidgetStopHeaderView(busStopSnapshot: busStopSnapshot)
                .padding([.bottom], 4)
              MainWidgetDeparturesView(busStopSnapshot: busStopSnapshot)
            }
          }
        }
      }
    }
  }
}
