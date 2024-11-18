import SwiftUI
import WidgetKit

struct SingleStopWidget: Widget {
  var body: some WidgetConfiguration {
    StaticConfiguration(
      kind: AppConfig.Widgets.SingleStopWidget.kind,
      provider: SingleStopWidgetTimelineProvider()
    ) { entry in
      SingleStopWidgetRootView(entry: entry)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .containerBackground(.background, for: .widget)
    }
    .configurationDisplayName("Welly Bus Single Stop")
    .contentMarginsDisabled()
    .description("Departures from a single stop")
    .supportedFamilies([.systemLarge])
  }
}

#Preview(as: .systemLarge) {
  SingleStopWidget()
} timeline: {
  let busStops = await BusStopService.shared.fetchBusStopsFromMetlink()
  SingleStopWidgetTimelineEntry(
    date: Date(),
    busStop: busStops[1],
    containingTimelineLength: busStops[1].departures.count,
    containingTimelineIndex: 0
  )
}
