//
//  ServiceSelectionView.swift
//  SwiftAnthropicExample
//
//  Created by Lou Zell on 7/31/24.
//

import SwiftUI

struct ServiceSelectionView: View {

   var body: some View {
      NavigationStack {
         List {
            Section("Select Service") {
               NavigationLink(destination: ApiKeyIntroView()) {
                  VStack(alignment: .leading) {
                     Text("Default Anthropic Service")
                        .padding(.bottom, 10)
                     Group {
                        Text("Use this service to test Anthropic functionality by providing your own Anthropic key.")
                     }
                     .font(.caption)
                     .fontWeight(.light)
                  }
               }

               NavigationLink(destination: AIProxyIntroView()) {
                  VStack(alignment: .leading) {
                     Text("AIProxy Service")
                        .padding(.bottom, 10)
                     Group {
                        Text("Use this service to test Anthropic functionality with requests proxied through AIProxy for key protection.")
                     }
                     .font(.caption)
                     .fontWeight(.light)
                  }
               }
            }
         }
      }
   }
}

#Preview {
   ServiceSelectionView()
}
