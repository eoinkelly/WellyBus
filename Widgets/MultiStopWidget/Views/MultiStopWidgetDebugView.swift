import SwiftUI

struct MultiStopWidgetDebugView: View {
  var entry: MultiStopWidgetTimelineProvider.Entry

  var body: some View {
    HStack(alignment: .center, spacing: 4) {
      Text("E:create:")
      Text(
        TimeDataSource<Date>.durationOffset(to: entry.debug.createdAt),
        format: .units(
          allowed: [.hours, .minutes, .seconds],
          width: .narrow,
          fractionalPart: .hide(rounded: .down)
        )
      )
      .frame(maxWidth: 100, alignment: .leading)

      Text("E:date =")
      Text(
        TimeDataSource<Date>.durationOffset(to: entry.date),
        format: .units(
          allowed: [.hours, .minutes, .seconds],
          width: .narrow,
          fractionalPart: .hide(rounded: .down)
        )
      )
      .frame(maxWidth: 100, alignment: .leading)

      Text(
        "TLE:\(entry.debug.containingTimelineIndex + 1)/\(entry.debug.containingTimelineLength)"
      )
    }
    .frame(maxWidth: .infinity, alignment: .topLeading)
    .font(.caption)
    .padding(4)
    .monospacedDigit()
    .foregroundColor(.gray)
  }
}
