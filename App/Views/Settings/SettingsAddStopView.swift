import SwiftData
import SwiftUI

struct SettingsAddStopView: View {
  @Environment(\.modelContext) private var modelContext
  @Environment(\.dismiss) private var dismiss

  @State private var name = ""
  @State private var nickname = ""

  var body: some View {
    NavigationStack {
      Form {
        Section("Stop Details") {
          TextField("Official Stop Name", text: $name)
          TextField("Nickname (Optional)", text: $nickname)
        }
        Section("Routes") {
          Text("TODO")
        }
      }
      .navigationTitle("Add Bus Stop")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .cancellationAction) {
          Button("Cancel") {
            dismiss()
          }
        }
        ToolbarItem(placement: .confirmationAction) {
          Button("Add") {
            let newStop = BusStop2(
              name: name,
              nickname: nickname,
              sortOrder: maxExistingSortOrder() + 1
            )

            modelContext.insert(newStop)
            dismiss()
          }
          .disabled(name.isEmpty)
        }
      }
    }
  }

  private func maxExistingSortOrder() -> Int {
    var fetchDescriptor = FetchDescriptor<BusStop2>(sortBy: [
      SortDescriptor(\.sortOrder, order: .reverse)
    ])
    fetchDescriptor.fetchLimit = 1

    let stopsInReverseSortOrder = try? modelContext.fetch(fetchDescriptor)

    return stopsInReverseSortOrder?.first?.sortOrder ?? 0
  }
}
