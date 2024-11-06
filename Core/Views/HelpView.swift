import SwiftUI

struct HelpView: View {
  let formattedHelpText: AttributedString
  let formattedScheduledHelpText: AttributedString

  let rawHelpText: String = """
    Bus is reporting real-time location to MetLink.
    """

  let scheduledRawHelp: String = """
    Scheduled bus departure time.
    """

  init() {
    self.formattedHelpText = try! AttributedString(markdown: rawHelpText)
    self.formattedScheduledHelpText = try! AttributedString(markdown: scheduledRawHelp)
  }

  var body: some View {
    VStack(alignment: .leading, spacing: 4) {
      HStack(alignment: .center, spacing: 4) {
        Rectangle()
          .fill(AppColors.trackedBusColor.color)
          .frame(width: 6, height: 16)
          .cornerRadius(3)
        Text(formattedHelpText)
          .font(.footnote)
      }

      HStack(alignment: .center, spacing: 4) {
        Rectangle()
          .fill(AppColors.scheduledBusColor.color)
          .frame(width: 6, height: 16)
          .cornerRadius(3)

        Text(formattedScheduledHelpText)
          .font(.footnote)
      }
    }
    .frame(maxWidth: .infinity, alignment: .leading)
  }
}
