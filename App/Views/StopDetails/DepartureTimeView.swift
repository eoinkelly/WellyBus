import SwiftUI

struct DepartureTimeView: View {
  @State public var departAt: Date
  @Binding public var now: Date

//  init(departAt: Date, now: Date) {
//    print("ZZZZZZZZZZZZZZZZZZZZZZZZZ")
//    print("\(now)")
//    print("==== ZZZZZZZZZZZZZZZZZZZZZZZZZ")
//    self.departAt = departAt
//    self.now = now
//  }
  
  var body: some View {
    VStack {
//      Text("DepartureTime: \(now.formatted(date: .omitted, time: .standard))")
//        .font(.caption)
//        .foregroundColor(.purple)
      HStack(alignment: .center, spacing: 4) {
        Text(departAt, style: .time)

        if departAt <= oneHourFromNow(now: now) {
          Text(" (\(numMinutesUntilDeparture(now: now)))")
        }
      }
    }
  }

  private func oneHourFromNow(now: Date) -> Date {
    Calendar.current.date(byAdding: .hour, value: 1, to: now)!
  }

  private func numMinutesUntilDeparture(now: Date) -> String {
    if let numMins = Calendar.current.dateComponents([.minute], from: now, to: departAt).minute {
      if numMins <= 0 {
        return "now"
      } else {
        // if there is 2m30s left show 2 to help users catch the bus
        return "\(numMins) mins"
      }
    } else {
      return ""
    }
  }

}
