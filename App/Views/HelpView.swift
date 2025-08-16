import SwiftUI

struct HelpView: View {
  let formattedHelpText: AttributedString
  let formattedScheduledHelpText: AttributedString

  let rawHelpText: String = "Location tracked bus"
  let scheduledRawHelp: String = "Scheduled bus"

  init() {
    // These are simple, static markdown strings that should always parse successfully
    self.formattedHelpText = (try? AttributedString(markdown: rawHelpText)) ?? AttributedString(rawHelpText)
    self.formattedScheduledHelpText = (try? AttributedString(markdown: scheduledRawHelp)) ?? AttributedString(scheduledRawHelp)
  }

  var body: some View {
    HStack(alignment: .center, spacing: 4) {
      HStack(alignment: .center, spacing: 4) {
        Rectangle()
          .fill(AppColors.trackedBusColor.color)
          .frame(width: 6, height: 16)
          .cornerRadius(3)
        Text(formattedHelpText)
          .font(.footnote)
      }
      Spacer()
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
    .padding([.leading, .trailing], 12)
  }
}
