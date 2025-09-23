import SwiftUI

struct AppFooterView: View {
  @Binding var lastUpdatedAt: Date
  @Binding var refreshInProgress: Bool

  var body: some View {
    NavigationStack {
      VStack(alignment: .center) {
        Divider()
        LastUpdateView(lastUpdatedAt: $lastUpdatedAt, refreshInProgress: $refreshInProgress)
          .padding([.leading, .trailing], 12)
        HelpView()
      }
    }
  }

}
