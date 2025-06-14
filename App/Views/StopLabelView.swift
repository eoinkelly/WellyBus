import SwiftUI

struct StopLabelView: View {
  @State public var busStop: BusStop

  var body: some View {
    Label("\(busStop.nickName)", systemImage: "bus")
      .font(.title3)
      .frame(maxWidth: .infinity, alignment: .leading)
  }
}
