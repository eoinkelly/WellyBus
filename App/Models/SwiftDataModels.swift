import SwiftData

// TODO: extract these when the names settle down a bit

// naming ideas
//
// BusStopViewModel = NO
//   these models are the data storage ones - they are not UI specific
//
//
// these models can likely replace the non-2 suffixed ones when they are ready

@Model
class BusStop2 {
  var name: String
  var nickname: String
  var routes: [BusRoute2]
  var sortOrder: Int

  init(name: String, nickname: String, sortOrder: Int = 0, routes: [BusRoute2] = []) {
    self.name = name
    self.nickname = nickname
    self.sortOrder = sortOrder
    self.routes = routes
  }
}

@Model
class BusRoute2 {
  var routeName: String
  var isPriorityRoute: Bool

  init(routeName: String, isPriorityRoute: Bool = false) {
    self.routeName = routeName
    self.isPriorityRoute = isPriorityRoute
  }
}
