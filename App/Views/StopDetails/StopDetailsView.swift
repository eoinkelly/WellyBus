import SwiftUI

struct StopDetailsView: View {
  @State private var scheduledTimer: Timer? = nil
  @State public var busStop: BusStop
  @State public var now: Date

  init(busStop: BusStop) {
    self.busStop = busStop
    self.now = Date.now
    setTimer()
  }

  func setTimer() {
    scheduledTimer = Timer.scheduledTimer(
      withTimeInterval: 3,
      repeats: true
    ) { _timer in
      self.now = Date()
      print("Timer fired. Date.now=\(Date()) now=\(self.now)")
    }
  }

  var body: some View {
    //    TimelineView(.periodic(from: Date.now, by: 5.0)) { context in
    //      TimelineView(.everyMinute) { context in
    VStack {
      Group {
        Text("Rendered: \(Date.now.formatted(date: .omitted, time: .standard))")
        //          Text("StopDetails: \(context.date.formatted(date: .omitted, time: .standard))")
      }
      .foregroundColor(.red)
      ForEach(departuresAfter(date: now)) { departure in
        DepartureView(departure: departure, busStop: busStop, now: $now)
          .frame(maxWidth: .infinity)
      }
    }
    .onDisappear {
      invalidateAnyExistingTimer()
    }
    //    }
  }

  private func departuresAfter(date: Date) -> [BusDeparture] {
    busStop.departures.filter {
      if let guess = $0.bestDepartureTimeGuess {
        return guess > date
      } else {
        return false
      }
    }
  }

  private func invalidateAnyExistingTimer() {
    scheduledTimer?.invalidate()
    scheduledTimer = nil
  }

}
