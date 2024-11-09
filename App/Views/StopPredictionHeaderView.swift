import SwiftUI

struct StopPredictionHeaderView: View {
  @State public var busStop: BusStop
  @State public var fontStyle: Font = .title
  @State public var imageScale: Image.Scale = .large

  var body: some View {
    HStack(alignment: .center, spacing: 4) {
      Image(systemName: "location")
        .imageScale(imageScale)
      Text(busStop.nickName)
        .font(fontStyle)
        .padding(0)

      Image(systemName: "arrow.forward")
        .imageScale(imageScale)

      switch busStop.direction {
      case .toHome:
        Image(systemName: "house")
          .imageScale(imageScale)
        Text("Home")
          .font(fontStyle)
      case .toTown:
        Image(systemName: "building.2")
          .imageScale(imageScale)
        Text("Town")
          .font(fontStyle)
      }
    }
    .padding([.top], 24)
  }
}
