import WidgetKit

struct MainWidgetTimelineProvider: TimelineProvider {
  func placeholder(in context: Context) -> MainWidgetTimelineEntry {
    return MainWidgetTimelineEntry(
      date: Date(),
      busStops: [],
      containingTimelineLength: 0,
      containingTimelineIndex: 0
    )
  }

  func getSnapshot(in context: Context, completion: @escaping (MainWidgetTimelineEntry) -> Void) {
    let entry = MainWidgetTimelineEntry(
      date: Date(),
      busStops: [],
      containingTimelineLength: 0,
      containingTimelineIndex: 0
    )

    completion(entry)
  }

  func getTimeline(
    in context: Context,
    completion: @escaping (Timeline<MainWidgetTimelineEntry>) -> Void
  ) {
    Task {
      // Fetch all available data from MetLink about our bus stops of interest
      let busStops: [BusStop] = await BusStopService.shared.fetchBusStopsFromMetlink()

      let actualNow = Date()
      let justAfterStartOfCurrentMin = calcTimeStampJustAfterStartOfCurrentMin(actualNow)

      // We want a new TimelineEntry for each minute so the Widget will
      // (ideally) refresh each minute. But we also want data shown by the
      // widget to be as fresh as possible.
      //
      // We balance these two requirements by creating as few TimelineEntries as
      // WidgetKit will let us get away with, each one minute apart.
      //
      // The number of entries we create is the number of minutes before we ask
      // WidgetKit to calculate a new Timeline.  The docs say that typical
      // realistic timeline re-calculation rates are 40-70 times per day (or
      // every 20-35 minutes).
      let numTimelineEntries = 30

      // The first TimelineEntry should have a `date` property set to the
      // current timestamp because we want WidgetKit to show it a.s.a.p.
      var entries = [
        MainWidgetTimelineEntry(
          date: actualNow,
          busStops: busStops,
          containingTimelineLength: numTimelineEntries,
          containingTimelineIndex: 0
        )
      ]

      // All other TimelineEntries should have a `date` property set to the just
      // **after** a minute boundary. Buses may appear/disappear from the screen
      // when the minute boundary ticks over so we want to render just after
      // that moment.
      for i in 1..<numTimelineEntries {
        entries.append(
          MainWidgetTimelineEntry(
            date: Calendar.current.date(
              byAdding: .minute, value: i, to: justAfterStartOfCurrentMin)!,
            busStops: busStops,
            containingTimelineLength: numTimelineEntries,
            containingTimelineIndex: i
          )
        )
      }

      let timeline = Timeline(entries: entries, policy: .atEnd)

      completion(timeline)
    }
  }

  private func calcTimeStampJustAfterStartOfCurrentMin(_ now: Date) -> Date {
    let calendar = Calendar.current
    let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: now)
    let startOfCurrentMinute = calendar.date(from: components)!
    return Calendar.current.date(byAdding: .second, value: 3, to: startOfCurrentMinute)!
  }
}
