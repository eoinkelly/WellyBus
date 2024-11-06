//
//  StopPredictionView.swift
//  WellyBus
//
//  Created by Eoin Kelly on 29/10/2024.
//

import SwiftUI

struct StopPredictionView: View {
  @State public var stopPrediction: StopPrediction

  let numDeparturesToShow = 5

  var body: some View {
    VStack(alignment: .leading) {
      //      Divider()
      StopPredictionHeaderView(
        stopPrediction: stopPrediction, fontStyle: .headline, imageScale: .large)
      //      .border(.red)
      AllDeparturesForStopView(stopPrediction: stopPrediction, maxDeparturesToShow: 6)
    }
  }
}
