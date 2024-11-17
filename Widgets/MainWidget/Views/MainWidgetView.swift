import SwiftUI
import WidgetKit

struct MainWidgetView: View {
  var entry: MainWidgetTimelineProvider.Entry

  //  @State private var lastUpdatedAt: Date
  //  @State private var refreshInProgress: Bool

  init(entry: MainWidgetTimelineProvider.Entry) {
    self.entry = entry
    //    self.lastUpdatedAt = entry.date
    //    self.refreshInProgress = false
  }

  var body: some View {
    VStack(alignment: .leading) {
      DebugView(entry: entry)

      Grid(alignment: .center) {
        ForEach(entry.busStopSnapshots) { busStopSnapshot in
          GridRow {
            VStack(alignment: .leading) {
              MainWidgetStopHeaderView(busStopSnapshot: busStopSnapshot)
              MainWidgetDeparturesView(busStopSnapshot: busStopSnapshot)
            }
          }
          Spacer()
        }
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    .padding([.leading, .trailing], 16)
    .padding([.top, .bottom], 8)
  }
}
