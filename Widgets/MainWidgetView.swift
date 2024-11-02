//
//  WidgetView.swift
//  WellyBus
//
//  Created by Eoin Kelly on 01/11/2024.
//

import SwiftUI
import WidgetKit

struct MainWidgetView: View {
  var entry: WellyBusWidgetTimelineProvider.Entry

  @State private var lastUpdatedAt: Date
  @State private var refreshInProgress: Bool

  init(entry: WellyBusWidgetTimelineProvider.Entry) {
    self.entry = entry
    self.lastUpdatedAt = entry.date
    self.refreshInProgress = false
  }

  var body: some View {
    VStack(alignment: .leading) {
      LastUpdateView(lastUpdatedAt: $lastUpdatedAt, refreshInProgress: $refreshInProgress)
      MainWidgetAllStopPredictionsView(entry: entry)
    }
  }
}
