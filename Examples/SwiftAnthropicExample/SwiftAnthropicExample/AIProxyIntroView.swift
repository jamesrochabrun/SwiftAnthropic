//
//  AIProxyIntroView.swift
//  SwiftAnthropicExample
//
//  Created by Lou Zell on 7/31/24.
//

import SwiftUI
import SwiftAnthropic

struct AIProxyIntroView: View {

   @State private var partialKey = ""
   @State private var serviceURL = ""

   private var canProceed: Bool {
      return !(self.partialKey.isEmpty || self.serviceURL.isEmpty)
   }

   var body: some View {
      NavigationStack {
         VStack {
            Spacer()
            VStack(spacing: 24) {
               TextField("Enter partial key", text: $partialKey)
               TextField("Enter your service's URL", text: $serviceURL)
            }
            .padding()
            .textFieldStyle(.roundedBorder)

            Text("You receive a partial key and service URL when you configure an app in the AIProxy dashboard")
               .font(.caption)

            NavigationLink(destination: OptionsListView(service: aiproxyService)) {
               Text("Continue")
                  .padding()
                  .padding(.horizontal, 48)
                  .foregroundColor(.white)
                  .background(
                     Capsule()
                        .foregroundColor(canProceed ? Color(red: 186/255, green: 91/255, blue: 55/255) : .gray.opacity(0.2)))
            }
            .disabled(!canProceed)
            Spacer()
            Group {
               Text("AIProxy keeps your Anthropic API key secure. To configure AIProxy for your project, or to learn more about how it works, please see the docs at ") + Text("[this link](https://www.aiproxy.pro/docs).")
            }
            .font(.caption)
         }
         .padding()
         .navigationTitle("AIProxy Configuration")
      }
   }

   private var aiproxyService: AnthropicService {
      return AnthropicServiceFactory.service(
         aiproxyPartialKey: partialKey,
         aiproxyServiceURL: serviceURL
      )
   }
}

#Preview {
   ApiKeyIntroView()
}
