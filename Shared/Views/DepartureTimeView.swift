import SwiftUI

struct DepartureTimeView: View {
  @State public var departAt: Date
  @State private var now: Date = .now

  private func oneHourFromNow(currentTime: Date) -> Date {
    Calendar.current.date(byAdding: .hour, value: 1, to: currentTime)!
  }

  var body: some View {
    HStack(alignment: .center, spacing: 4) {

      if departAt >= oneHourFromNow(currentTime: now) {
        Text(departAt, style: .time)
      } else {
        Image(systemName: "timer")
        //          .frame(maxWidth: .infinity, alignment: .leading)

        // My original way.
        // -- shows seconds
        // ++ counts down with the correct precision
        //
        Text(
          timerInterval: now...departAt,
          countsDown: true,
          showsHours: false
        )
        .frame(maxWidth: .infinity, alignment: .leading)
        //        .border(.red)

        // Option 2:
        // Broken but seems like it might be a bug in iOS - it seems like it
        // should work - it's probably user error though.
        //      Text(
        //        departAt,
        //        format: .timer(
        //          countingUpIn: now..<departAt,
        //          showsHours: false,
        //          maxFieldCount: 2,
        //          maxPrecision: .seconds(1)
        //        )
        //      )
        //      .border(.red)

        // Possibly viable option 2 but the times all show as negative
        // and it starts counting up when it hits 0
        //      Text(
        //        TimeDataSource<Date>.durationOffset(to: departAt),
        //        format: .units(
        //          allowed: [.hours, .minutes, .seconds],
        //          width: .narrow,
        //          fractionalPart: .hide(rounded: .down)
        //        )
        //      )
        //      .border(.green)

        // Couldn't get any of these to work as I wanted

        //       let styleA = Duration.TimeFormatStyle(pattern: .hourMinuteSecond(padHourToLength: 2))
        //       let styleB = Duration.TimeFormatStyle(pattern: .hourMinute(padHourToLength: 2, roundSeconds: .down))
        //       let styleC = Duration.TimeFormatStyle(pattern: .minuteSecond(padMinuteToLength: 2))
        //
        //       let durationC = Duration.seconds(departAt.timeIntervalSince(Date()))
        //       let tdsA = TimeDataSource<Date>.durationOffset(to: departAt)
        //
        //       let unitStyleA = Duration.UnitsFormatStyle(
        //       allowedUnits: [.hours, .minutes],
        //       width: .abbreviated,
        //       fractionalPart: .hide(rounded: .down)
        //       )
        //       Text(durationC, format: unitStyleA)
        //       .border(.yellow)
        //
        //       var timerDownStyle: SystemFormatStyle.Timer {
        //       .timer(countingDownIn: now..<departAt, showsHours: true, maxFieldCount: 2, maxPrecision: .seconds(1))
        //       }
        //
        //       Text(departAt, format: timerDownStyle)
        //       .border(.purple)
      }
    }
    //    .border(.blue)
  }
}
