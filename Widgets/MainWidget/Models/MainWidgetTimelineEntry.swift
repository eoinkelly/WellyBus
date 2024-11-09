import WidgetKit

struct MainWidgetTimelineEntry: TimelineEntry {
  let date: Date
  let busStops: [BusStop]
}
