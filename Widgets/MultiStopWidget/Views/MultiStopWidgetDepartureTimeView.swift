import SwiftUI

struct MultiStopWidgetDepartureTimeView: View {
  @State public var departsAt: Date

  let nowSource: TimeDataSource<Date> = .currentDate

  // TODO: Date() might be wrong here because the view is maybe rendered well before it is shown
  var body: some View {
    HStack(alignment: .center, spacing: 4) {
      Group {
        if departsAt.timeIntervalSince(Date()) >= 3600 {
          Text(departsAt, style: .time)
        } else {
          Text(
            nowSource,
            format: .reference(
              to: departsAt, allowedFields: [.hour, .minute], thresholdField: .minute)
          )
        }
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      .monospacedDigit()
    }
  }
}
