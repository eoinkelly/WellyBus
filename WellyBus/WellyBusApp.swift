//
//  WellyBusApp.swift
//  WellyBus
//
//  Created by Eoin Kelly on 26/10/2024.
//

import SwiftData
import SwiftUI

@main
struct WellyBusApp: App {
  var sharedModelContainer: ModelContainer = {
    let schema = Schema([
      Item.self
    ])
    let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

    do {
      return try ModelContainer(for: schema, configurations: [modelConfiguration])
    } catch {
      fatalError("Could not create ModelContainer: \(error)")
    }
  }()

  var body: some Scene {
    WindowGroup {
      StopPredictionsView()
    }
    .modelContainer(sharedModelContainer)
  }
}
