import SwiftUI
import WidgetKit

struct SingleStopWidgetRootView: View {
  var entry: SingleStopWidgetTimelineProvider.Entry

  init(entry: SingleStopWidgetTimelineProvider.Entry) {
    self.entry = entry
  }

  var body: some View {
    VStack(alignment: .leading) {
      SingleStopWidgetDebugView(entry: entry)

      VStack(alignment: .leading) {
        SingleStopWidgetStopHeaderView(busStopSnapshot: entry.busStopSnapshot)
        SingleStopWidgetDeparturesView(busStopSnapshot: entry.busStopSnapshot)
      }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    .padding([.leading, .trailing], 16)
    .padding([.top, .bottom], 8)
  }
}
