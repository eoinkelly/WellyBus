import SwiftUI

struct SingleStopWidgetDebugView: View {
  var entry: SingleStopWidgetTimelineProvider.Entry

  var body: some View {
    Group {
      HStack(alignment: .center, spacing: 0) {
        Text("entry.create.ago:")
        Text(
          TimeDataSource<Date>.durationOffset(to: entry.debug.createdAt),
          format: .units(
            allowed: [.hours, .minutes, .seconds],
            width: .narrow,
            fractionalPart: .hide(rounded: .down)
          )
        )
        .frame(maxWidth: 50, alignment: .leading)

        Text("entry.date.ago:")
        Text(
          TimeDataSource<Date>.durationOffset(to: entry.date),
          format: .units(
            allowed: [.hours, .minutes, .seconds],
            width: .narrow,
            fractionalPart: .hide(rounded: .down)
          )
        )
        .frame(maxWidth: 50, alignment: .leading)

      }
      HStack(alignment: .center, spacing: 0) {
        Text("render.ago:")
        Text(
          TimeDataSource<Date>.durationOffset(to: Date.now),
          format: .units(
            allowed: [.hours, .minutes, .seconds],
            width: .narrow,
            fractionalPart: .hide(rounded: .down)
          )
        )
        .frame(maxWidth: 100, alignment: .leading)

        Text("timeline:")
        Text(
          "\(entry.debug.containingTimelineIndex + 1)/\(entry.debug.containingTimelineLength)"
        )
      }
    }
    .frame(maxWidth: .infinity, alignment: .topLeading)
    .font(.caption)
    .monospacedDigit()
  }
}
