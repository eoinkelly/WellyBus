import WidgetKit

struct SingleStopWidgetTimelineProvider: TimelineProvider {
  let placeholder: SingleStopWidgetTimelineEntry = SingleStopWidgetTimelineEntry(
    date: Date(),
    busStop: BusStop(
      stopName: "123",
      nickName: "Example Stop",
      departures: [],
      direction: .toHome,
      departuresFetchedAt: Date.now
    ),
    containingTimelineLength: 0,
    containingTimelineIndex: 0
  )

  func placeholder(in context: Context) -> SingleStopWidgetTimelineEntry {
    return placeholder
  }

  func getSnapshot(
    in context: Context, completion: @escaping (SingleStopWidgetTimelineEntry) -> Void
  ) {
    let entry = placeholder
    completion(entry)
  }

  func getTimeline(
    in context: Context,
    completion: @escaping (Timeline<SingleStopWidgetTimelineEntry>) -> Void
  ) {
    Task {
      // Fetch all available data from MetLink about our bus stops of interest
      let stops: [BusStop] = await BusStopService.shared.fetchBusStopsFromMetlink()
      let busStop = stops[1]  // FIXME: do better

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

      // The first TimelineEntry should have a `date` property set to the
      // current timestamp because we want WidgetKit to show it a.s.a.p.
      var entries = [
        SingleStopWidgetTimelineEntry(
          date: Date.now,
          busStop: busStop,
          containingTimelineLength: busStop.departures.count,
          containingTimelineIndex: 0
        )
      ]

      // We create as many timeline entries as we have departures
      // Add a timeline entry to be rendered a few seconds after each bus departs
      for (i, departure) in busStop.departures.enumerated() {
        if let departsAt = departure.bestDepartureTimeGuess {
          entries.append(
            SingleStopWidgetTimelineEntry(
              date: Calendar.current.date(byAdding: .second, value: 3, to: departsAt)!,
              busStop: busStop,
              containingTimelineLength: busStop.departures.count,
              containingTimelineIndex: i
            )
          )
        }
      }

      let timeline = Timeline(entries: entries, policy: .atEnd)

      completion(timeline)
    }
  }
}
