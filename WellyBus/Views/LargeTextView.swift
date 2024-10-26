//
//  LargeTextView.swift
//  WellyBus
//
//  Created by Eoin Kelly on 26/10/2024.
//

import SwiftUI

struct LargeTextView: View {
  // Sample long text - replace with your content
  private let longText = await BusTracker().main()
  //    """
  //    Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.
  //
  //    Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
  //
  //    Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo.
  //    """

  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 16) {
        Text("Large Text Content")
          .font(.title)
          .fontWeight(.bold)
          .padding(.bottom, 8)

        Text(longText)
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

// Example usage in another view
//struct ContentView: View {
//    var body: some View {
//        NavigationView {
//            LargeTextView()
//                .navigationTitle("Documentation")
//        }
//    }
//}
