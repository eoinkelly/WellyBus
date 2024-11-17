import SwiftUI

struct MainWidgetDepartureTimeView: View {
  @State public var departsAt: Date

  let nowSource: TimeDataSource<Date> = .currentDate

  // TODO: Date.now is probalby wrong here because the view is maybe rendered well before it is shown
  var body: some View {
    HStack(alignment: .center, spacing: 4) {
      Group {
        if departsAt.timeIntervalSince(Date.now) >= 3600 {
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

// A history widget friendly dynamic timer stuff I tried ...

// OPTION  ***************************************
// My super raw version
// ++ total format control
// -- totally static - does not change until the next timeline entry is loaded
// Text("\(Int(remainingTime / 60)) mins")

// OPTION  ***************************************
// 1:46 PM
// -- the time doesn't change - it's a static value
// Conclusion: no good
//        Text(
//          time,
//          format: Date.FormatStyle().hour(.defaultDigits(amPM: .abbreviated)).minute().second()
//            .attributedStyle
//        )

// OPTION  ***************************************
// not really suitable because it's more for describing a timestamp not a duration
//                Text(
//                  Date(),
//                  format: .reference(
//                    to: time,
//                    allowedFields: [.hour, .minute],
//                    thresholdField: .minute
//                  )
//                )

// OPTION  ***************************************
//        Text(
//          time,
//          format: .offset(
//            to: Date(),
//            allowedFields: [.hour, .minute]
//          )
//        )

// OPTION  ***************************************
// A humanised comparison to a reference time
// pretty close to what i need but forces "in __ minutes" as text which is too wide
// ?? can i make a custom formatter?
// Conclusion: maybe
//        Text(
//          tdNow,
//          format: .reference(to: time, allowedFields: [.hour, .minute], thresholdField: .minute)
//        )

// OPTION  ***************************************
// Designed to be a "humanised" offset but doesn't give me enough control
// Conclusion: Nope
//        Text(
//          tdNow,
//          format: .offset(to: time, allowedFields: [.hour, .minute, .second])
//        )

// OPTION  ***************************************
// -- No control over m/min/minutes
// Conclusion: not suitable
//        let range = Date()..<time
//        Text(
//          tdNow,
//          format: .timer(countingDownIn: range, showsHours: true, maxPrecision: .seconds(60))
//        )

// OPTION  ***************************************
// Conclusion: Not suitable
//                Text(
//                  tdNow,
//                  format: Date.FormatStyle().hour(.defaultDigits(amPM: .abbreviated)).minute().second()
//                    .attributedStyle
//                )

// OPTION  ***************************************
// ++ Dynamically updates in widget
// -- shows a negative countdown to the departure and then keeps counting up when hits 0
// ++ I can hide the seconds and hours easily
// ++ I can control whether it uses m/min/minutes
// Conclusion: Not suitable for this use
//        let tdDur = TimeDataSource<Duration>.durationOffset(to: time)
//        Text(
//          tdDur,
//          format: .units(
//            allowed: [.minutes],
//            width: .condensedAbbreviated,
//            maximumUnitCount: 1,
//            fractionalPart: .hide(rounded: .down)
//          )
//        )

// OPTION  ***************************************
// Does'tn update seconds on the second on it's own
// ++ closer to what I want but forces the "in " prefix on me
// Example: In 23 min
// ?? I could make a custom formatter maybe?
// Conclusion: maybe with custom formatter or I could just live with it
// I can't redraw the widget at-will so I need a built-in time view
//        Text(
//          time,
//          format: Date.RelativeFormatStyle(
//            presentation: .numeric,
//            unitsStyle: .narrow
//          )
//        )
//        .frame(maxWidth: .infinity, alignment: .leading)
//        .monospacedDigit()
