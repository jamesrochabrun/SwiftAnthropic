//
//  ApiKeyIntroView.swift
//  SwiftAnthropicExample
//
//  Created by James Rochabrun on 2/24/24.
//

import SwiftUI
import SwiftAnthropic

struct ApiKeyIntroView: View {
   
   @State private var apiKey = ""
   
   var body: some View {
      NavigationStack {
         VStack {
            Spacer()
            VStack(spacing: 24) {
               TextField("Enter API Key", text: $apiKey)
            }
            .padding()
            .textFieldStyle(.roundedBorder)
            NavigationLink(destination: OptionsListView(service: AnthropicServiceFactory.service(
               apiKey: apiKey,
               betaHeaders: ["prompt-caching-2024-07-31", "max-tokens-3-5-sonnet-2024-07-15"]))) {
               Text("Continue")
                  .padding()
                  .padding(.horizontal, 48)
                  .foregroundColor(.white)
                  .background(
                     Capsule()
                        .foregroundColor(apiKey.isEmpty ? .gray.opacity(0.2) : Color(red: 186/255, green: 91/255, blue: 55/255)))
            }
            .disabled(apiKey.isEmpty)
            Spacer()
            Group {
               Text("You can find a blog post in how to use the `SwiftAnthropic` Package ") +  Text("[here](https://medium.com/@jamesrochabrun/anthropic-ios-sdk-032e1dc6afd8)")
               Text("If you don't have a valid API KEY yet, you can visit ") + Text("[this link](https://www.anthropic.com/earlyaccess)") + Text(" to get started.")
            }
            .font(.caption)
         }
         .padding()
         .navigationTitle("Enter Anthropic API KEY")
      }
   }
}

#Preview {
   ApiKeyIntroView()
}
