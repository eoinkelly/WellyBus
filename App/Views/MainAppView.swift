import SwiftUI
import WidgetKit

struct MainAppView: View {
  @State private var busStops: [BusStop] = []
  @State private var lastUpdatedAt = Date()
  @State private var refreshInProgress = false
  @State private var scheduledTimer: Timer? = nil

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
        .onChange(of: scenePhase, initial: true) { _, newPhase in
          if newPhase == .active {
            logNotice("Running onChange lambda")
            refresh()
          }
        }
      }
      .refreshable {
        // when the user pulls to refresh, we want to clear any existing timer and refresh
        // the data (which will schedule a new timer for the next refresh)
        invalidateAnyExistingTimer()
        refresh()
      }
      .onAppear {
        #if targetEnvironment(simulator)
          // Previews don't seem to notice the `onChange(of: scenePhase ...)` modifier
          // so we explicitly refresh
          logNotice("Running onAppear refresh for preview")
          refresh()
        #endif
      }
      .onDisappear {
        invalidateAnyExistingTimer()
      }

      Divider()
      LastUpdateView(lastUpdatedAt: $lastUpdatedAt, refreshInProgress: $refreshInProgress)
        .padding([.leading, .trailing], 12)
      HelpView()
    }
    .padding([.leading, .trailing], 16)

  }

  private func scheduleNextRefresh(at nextRefreshAt: Date) {
    logNotice("Scheduling next refresh: \(Debug.asRelativeTime(nextRefreshAt))")

    invalidateAnyExistingTimer()

    self.scheduledTimer = Timer.scheduledTimer(
      withTimeInterval: nextRefreshAt.timeIntervalSinceNow,
      repeats: false
    ) { _ in
      logNotice("Timer fired")
      refresh()
    }
  }

  private func invalidateAnyExistingTimer() {
    scheduledTimer?.invalidate()
    scheduledTimer = nil
  }

  private func refresh() {
    Task {
      logNotice("Starting refresh Task")
      markRefreshInProgress()

      self.busStops = await BusStopService.shared.fetchBusStopsFromMetlink(maxDeparturesPerStop: 6)

      if let nextDepartureAt = BusStopService.shared.nextDeparture(for: busStops) {
        scheduleNextRefresh(at: nextDepartureAt)
      } else {
        let fallBack = Date().addingTimeInterval(5 * 60)  // 5 mins
        logNotice(
          "No next departure found for any stop. Fallback refresh: \(Debug.asRelativeTime(fallBack))"
        )
        scheduleNextRefresh(at: fallBack)
      }

      markRefreshComplete()

      // Force a refresh of the widgets when the app gets refreshed
      refreshWidgets()
    }
  }

  private func refreshWidgets() {
    logNotice("Refreshing widget timeline")
    WidgetCenter.shared.reloadTimelines(ofKind: AppConfig.Widgets.MultiStopWidget.kind)
    WidgetCenter.shared.reloadTimelines(ofKind: AppConfig.Widgets.SingleStopWidget.kind)
  }

  private func markRefreshInProgress() {
    refreshInProgress = true
  }

  private func markRefreshComplete() {
    refreshInProgress = false
    lastUpdatedAt = Date()
  }

  private func logNotice(_ msg: String) {
    Log.notice(msg, logger: .mainApp)
  }
}

#Preview {
  MainAppView()
}
