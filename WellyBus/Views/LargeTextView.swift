//
//  LargeTextView.swift
//  WellyBus
//
//  Created by Eoin Kelly on 26/10/2024.
//

import SwiftUI

struct LargeTextView: View {
  @State private var myText: String = "Loading..."

  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 16) {
        Text("Bus Stops")
          .font(.title)
          .fontWeight(.bold)
          .padding(.bottom, 8)

        Text(myText)
          .onAppear {
            Task {
              myText = await BusTracker().main()
              logger.log("Finished loading")
              logger.log("Fetched text: \(myText)")
            }
          }
          .font(.body)
          .lineSpacing(4)
          .fixedSize(horizontal: false, vertical: true)
          .multilineTextAlignment(.leading)
      }
      .padding()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color(.systemBackground))
  }
}

// Preview provider for SwiftUI canvas
struct LargeTextView_Previews: PreviewProvider {
  static var previews: some View {
    LargeTextView()
  }
}
