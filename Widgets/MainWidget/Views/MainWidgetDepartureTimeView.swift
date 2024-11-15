import SwiftUI

struct MainWidgetDepartureTimeView: View {
  @State public var departsAt: DepartureTimePresentation

  var body: some View {
    HStack(alignment: .center, spacing: 4) {

      switch departsAt {
      case .relativeTime(let remainingTime, _):
        //        Image(systemName: "timer")
        Text("\(Int(remainingTime / 60)) mins")  // TODO: Use a formatter or more accurate rounding
          //        Text(
          //          TimeDataSource<Date>.durationOffset(to: time),
          //          format: .units(
          //            allowed: [.hours, .minutes, .seconds],
          //            width: .narrow,
          //            fractionalPart: .hide(rounded: .down)
          //          )
          //        )
          .frame(maxWidth: .infinity, alignment: .leading)
      case .absoluteTime(let time):
        Text(time, style: .time)
      }
    }
  }
}
