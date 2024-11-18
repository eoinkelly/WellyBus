import SwiftUI
import WidgetKit

struct MultiStopWidget: Widget {
  var body: some WidgetConfiguration {
    StaticConfiguration(
      kind: AppConfig.Widgets.MultiStopWidget.kind,
      provider: MultiStopWidgetTimelineProvider()
    ) { entry in
      MultiStopWidgetRootView(entry: entry)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .containerBackground(.background, for: .widget)
    }
    .configurationDisplayName("Welly Bus Multi Stop")
    .contentMarginsDisabled()
    .description("Departures from all stops")
    .supportedFamilies([.systemLarge])
  }
}

#Preview(as: .systemLarge) {
  MultiStopWidget()
} timeline: {
  let busStops = await BusStopService.shared.fetchBusStopsFromMetlink()
  MultiStopWidgetTimelineEntry(
    date: Date(),
    busStops: busStops,
    containingTimelineLength: -1,
    containingTimelineIndex: 0
  )
}
