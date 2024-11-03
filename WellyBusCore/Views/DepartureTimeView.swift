import SwiftUI

struct DepartureTimeView: View {
  @State public var departAt: Date

  var body: some View {
    let isSoon = Calendar.current.date(byAdding: .hour, value: 1, to: Date())! < departAt

    if isSoon {
      Text(departAt, style: .time)
    } else {
      Text(departAt, style: .relative)
    }
  }
}
