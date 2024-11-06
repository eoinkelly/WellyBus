import SwiftUI
import WidgetKit

struct MainWidget: Widget {
  let kind: String = "info.eoinkelly.WellyBus.Widgets.WellyBusWidget"

  var body: some WidgetConfiguration {
    StaticConfiguration(kind: kind, provider: WellyBusWidgetTimelineProvider()) { entry in
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
  let stopPredictions = await BusStopPredictor().refreshPredictions()
  MainWidgetTimelineEntry(date: Date(), stopPredictions: stopPredictions)
}
