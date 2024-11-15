import SwiftUI
import WidgetKit

struct MainWidget: Widget {
  let kind: String = "info.eoinkelly.WellyBus.Widgets.WellyBusWidget"

  var body: some WidgetConfiguration {
    StaticConfiguration(kind: kind, provider: MainWidgetTimelineProvider()) { entry in
      MainWidgetView(entry: entry)
        .containerBackground(.background, for: .widget)
    }
    .configurationDisplayName("Welly Bus")
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
