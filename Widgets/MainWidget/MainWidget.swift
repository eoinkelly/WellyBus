import SwiftUI
import WidgetKit

struct MainWidget: Widget {
  var body: some WidgetConfiguration {
    StaticConfiguration(
      kind: AppConfig.Widgets.MainWidget.kind, provider: MainWidgetTimelineProvider()
    ) { entry in
      MainWidgetView(entry: entry)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .containerBackground(.background, for: .widget)
    }
    .configurationDisplayName("Welly Bus")
    .contentMarginsDisabled()
    .description("Upcoming bus departures")
    .supportedFamilies([.systemLarge])
  }
}

#Preview(as: .systemLarge) {
  MainWidget()
} timeline: {
  let busStops = await BusStopService.shared.fetchBusStopsFromMetlink()
  MainWidgetTimelineEntry(
    date: Date(),
    busStops: busStops,
    containingTimelineLength: -1,
    containingTimelineIndex: 0
  )
}
