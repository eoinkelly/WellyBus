import SwiftUI

struct StopPredictionView: View {
  @State public var busStop: BusStop

  var body: some View {
    VStack(alignment: .leading) {
      StopPredictionHeaderView(busStop: busStop, fontStyle: .headline, imageScale: .large)
      AllDeparturesForStopView(busStop: busStop)
    }
  }
}
