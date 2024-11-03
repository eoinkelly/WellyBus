import SwiftUI

struct HelpView: View {
  let formattedHelpText: AttributedString
  let rawHelpText: String = """
    Metlink describe this depature as **expected** not just **aimed for**. 
    """

  init() {
    self.formattedHelpText = try! AttributedString(markdown: rawHelpText)
  }

  var body: some View {
    HStack(alignment: .top, spacing: 4) {
      Text("123")
        .font(.caption)
        .foregroundStyle(.black)
        .padding(2)
        .background(.green)
        .cornerRadius(3)
      Text(formattedHelpText)
        .font(.footnote)
    }
  }
}
