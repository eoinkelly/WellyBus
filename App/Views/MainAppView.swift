import SwiftUI

struct MainAppView: View {
  @State private var busStops: [BusStop] = []
  @State private var lastUpdatedAt = Date()
  @State private var refreshInProgress = false
  @State private var scheduledTimers: [Timer] = []

  @Environment(\.scenePhase) var scenePhase

  var body: some View {
    VStack(alignment: .center) {
      Text("Welly Bus")
        .font(.title3)
        .fontWeight(.bold)

      ScrollView {
        Grid {
          ForEach(busStops) { busStop in
            GridRow {
              StopPredictionView(busStop: busStop)
            }
          }
        }
        .onChange(of: scenePhase, initial: true) { _oldPhase, newPhase in
          if newPhase == .active {
            refresh()
          }
        }
      }
      .refreshable {
        // when the user pulls to refresh, we want to clear all existing timers and refresh
        // the data (which will schedule a new timer for the next refresh)
        clearAllTimers()
        refresh()
      }
      .onAppear {
        refresh()
      }
      .onDisappear {
        clearAllTimers()
      }

      LastUpdateView(lastUpdatedAt: $lastUpdatedAt, refreshInProgress: $refreshInProgress)
      Divider()
      HelpView()
    }
    .padding([.leading, .trailing], 16)
  }

  private func scheduleNextRefresh(at nextRefreshAt: Date) {
    Debug.dumpTime(time: nextRefreshAt, message: "Scheduling next refresh for")

    let timer = Timer.scheduledTimer(
      withTimeInterval: nextRefreshAt.timeIntervalSinceNow,
      repeats: false
    ) { _ in
      print("Running scheduled refresh closure")
      refresh()
    }

    clearAllTimers()
    scheduledTimers.append(timer)
    print("\(scheduledTimers.count) timers now scheduled")
  }

  private func clearAllTimers() {
    print("Clearing all timers")

    for timer in scheduledTimers {
      timer.invalidate()
    }

    scheduledTimers.removeAll()
  }

  private func refresh() {
    Task {
      print("Running refresh Task")
      markRefreshInProgress()

      busStops = await BusStopService.shared.fetchBusStopsFromMetlink()

      if let nextDepartureAt = BusStopService.shared.nextDeparture(for: busStops) {
        scheduleNextRefresh(at: nextDepartureAt)
      } else {
        let fallBack = Date().addingTimeInterval(5 * 60)  // 5 mins
        Debug.dumpTime(
          time: fallBack, message: "No next departure found at any stop. Fallback refresh at")
        scheduleNextRefresh(at: fallBack)
      }

      markRefreshComplete()
    }
  }

  private func markRefreshInProgress() {
    refreshInProgress = true
  }

  private func markRefreshComplete() {
    refreshInProgress = false
    lastUpdatedAt = Date()
  }
}

#Preview {
  MainAppView()
}
