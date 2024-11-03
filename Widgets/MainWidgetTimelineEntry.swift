import WidgetKit

struct MainWidgetTimelineEntry: TimelineEntry {
  let date: Date
  let stopPredictions: [StopPrediction]
}
