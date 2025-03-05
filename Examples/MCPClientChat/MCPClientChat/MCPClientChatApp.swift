//
//  MCPClientChatApp.swift
//  MCPClientChat
//
//  Created by James Rochabrun on 3/3/25.
//

import SwiftUI
import SwiftAnthropic
import SwiftOpenAI

@main
struct MCPClientChatApp: App {
   
   @State private var chatManager: ChatManager
   private let githubClient = GIthubMCPClient()
   
   init() {
      let service = AnthropicServiceFactory.service(apiKey: "", betaHeaders: nil, debugEnabled: true)
      
      let initialManager = AnthropicNonStreamManager(service: service)
      
      _chatManager = State(initialValue: initialManager)
      
      // Uncomment this and comment the above for OpenAI Demo
      
      //      let openAIService = OpenAIServiceFactory.service(apiKey: "", debugEnabled: true)
      //
      //      let openAIChatNonStreamManager = OpenAIChatNonStreamManager(service: openAIService)
      //
      //      _chatManager = State(initialValue: openAIChatNonStreamManager)
   }
   
   var body: some Scene {
      WindowGroup {
         ChatView(chatManager: chatManager)
            .toolbar(removing: .title)
            .containerBackground(
               .thinMaterial, for: .window
            )
            .toolbarBackgroundVisibility(
               .hidden, for: .windowToolbar
            )
            .task {
               if let client = try? await githubClient.getClientAsync() {
                  chatManager.updateClient(client)
               }
            }
      }
      .windowStyle(.hiddenTitleBar)
   }
}
