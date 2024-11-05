import SwiftUI

struct HelpView: View {
  let formattedHelpText: AttributedString
  let formattedScheduledHelpText: AttributedString

  let rawHelpText: String = """
    Bus is live tracked
    """

  let scheduledRawHelp: String = """
    Bus is scheduled 
    """

  init() {
    self.formattedHelpText = try! AttributedString(markdown: rawHelpText)
    self.formattedScheduledHelpText = try! AttributedString(markdown: scheduledRawHelp)
  }

  var body: some View {
    VStack(alignment: .leading, spacing: 4) {
      HStack(alignment: .center, spacing: 4) {
        Rectangle()
          .fill(.green)
          .frame(width: 6, height: 20)
          .cornerRadius(3)
        Text(formattedHelpText)
          .font(.footnote)
      }

      HStack(alignment: .top, spacing: 4) {
        Rectangle()
          .fill(.gray)
          .frame(width: 6, height: 20)
          .cornerRadius(3)

        Text(formattedScheduledHelpText)
          .font(.footnote)
      }
    }
    .frame(maxWidth: .infinity, alignment: .leading)
  }
}
