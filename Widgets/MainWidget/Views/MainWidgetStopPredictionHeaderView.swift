import SwiftUI

struct MainWidgetStopPredictionHeaderView: View {
  @State public var stopPrediction: StopPrediction
  @State public var fontStyle: Font = .caption
  @State public var imageScale: Image.Scale = .small

  var body: some View {
    HStack(alignment: .center, spacing: 4) {
      Image(systemName: "location")
        .imageScale(imageScale)
      Text(stopPrediction.name)
        .font(fontStyle)
        .padding(0)

      Image(systemName: "arrow.forward")
        .imageScale(imageScale)

      switch stopPrediction.stopConfig.direction {
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
  }
}
