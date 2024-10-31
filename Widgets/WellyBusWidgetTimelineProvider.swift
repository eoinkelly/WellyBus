//
//  WellyBusWidgetTimelineProvider.swift
//  WellyBus
//
//  Created by Eoin Kelly on 01/11/2024.
//
import WidgetKit

struct WellyBusWidgetTimelineProvider: TimelineProvider {
  func placeholder(in context: Context) -> MainWidgetTimelineEntry {
    print("running placeholder")
    return MainWidgetTimelineEntry(date: Date(), stopPredictions: [])
  }

  func getSnapshot(in context: Context, completion: @escaping (MainWidgetTimelineEntry) -> Void) {
    print("running getSnapshot")
    let entry = MainWidgetTimelineEntry(date: Date(), stopPredictions: [])
    completion(entry)
  }

  func getTimeline(
    in context: Context, completion: @escaping (Timeline<MainWidgetTimelineEntry>) -> Void
  ) {

    print("running getTimeline")
    Task {
      do {
        // TODO: handle network errors properly
        let stopPredictions = await BusStopPredictor().stopPredictions()
        let entry = MainWidgetTimelineEntry(date: Date(), stopPredictions: stopPredictions)

        let refreshTime = Calendar.current.date(byAdding: .minute, value: 1, to: Date())!

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
