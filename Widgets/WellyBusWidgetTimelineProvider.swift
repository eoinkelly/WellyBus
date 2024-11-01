//
//  WellyBusWidgetTimelineProvider.swift
//  WellyBus
//
//  Created by Eoin Kelly on 01/11/2024.
//
import WidgetKit

struct WellyBusWidgetTimelineProvider: TimelineProvider {
  func placeholder(in context: Context) -> MainWidgetTimelineEntry {
    return MainWidgetTimelineEntry(date: Date(), stopPredictions: [])
  }

  func getSnapshot(in context: Context, completion: @escaping (MainWidgetTimelineEntry) -> Void) {
    let entry = MainWidgetTimelineEntry(date: Date(), stopPredictions: [])
    completion(entry)
  }

  func getTimeline(
    in context: Context, completion: @escaping (Timeline<MainWidgetTimelineEntry>) -> Void
  ) {

    Task {
      do {
        // TODO: handle network errors properly
        // TODO: do this network request in background to avoid system killing widget before response arrives
        let stopPredictions = await BusStopPredictor().stopPredictions()
        let now = Date()
        let entry = MainWidgetTimelineEntry(date: now, stopPredictions: stopPredictions)

        // Docs say 5min is minimum widget refresh time
        // https://developer.apple.com/documentation/WidgetKit/Keeping-a-Widget-Up-To-Date
        let refreshTime = Calendar.current.date(byAdding: .minute, value: 5, to: now)!
        let timeline = Timeline(entries: [entry], policy: .after(refreshTime))

        completion(timeline)
      } catch {
        print(error.localizedDescription)
      }
    }
  }

  //    func relevances() async -> WidgetRelevances<Void> {
  //        // Generate a list containing the contexts this widget is relevant in.
  //    }
}
