import SwiftUI
import WidgetKit

struct MultiStopWidgetRootView: View {
  var entry: MultiStopWidgetTimelineProvider.Entry

  //  @State private var lastUpdatedAt: Date
  //  @State private var refreshInProgress: Bool

  init(entry: MultiStopWidgetTimelineProvider.Entry) {
    self.entry = entry
    //    self.lastUpdatedAt = entry.date
    //    self.refreshInProgress = false
  }

  var body: some View {
    VStack(alignment: .leading) {
      MultiStopWidgetDebugView(entry: entry)

      Grid(alignment: .center) {
        ForEach(entry.busStopSnapshots) { busStopSnapshot in
          GridRow {
            VStack(alignment: .leading) {
              MultiStopWidgetStopHeaderView(busStopSnapshot: busStopSnapshot)
              MultiStopWidgetDeparturesView(busStopSnapshot: busStopSnapshot)
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
