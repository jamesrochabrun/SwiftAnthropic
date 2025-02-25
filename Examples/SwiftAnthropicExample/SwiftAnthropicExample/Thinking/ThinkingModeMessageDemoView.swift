//
//  ThinkingModeMessageDemoView.swift
//  SwiftAnthropic
//
//  Created by James Rochabrun on 2/24/25.
//

import SwiftUI
import SwiftAnthropic

@MainActor
struct ThinkingModeMessageDemoView: View {
   
   let observable: ThinkingModeMessageDemoObservable
   @State private var prompt: String = ""
   @State private var thinkingBudget: Double = 16.0
   @State private var showThinking: Bool = true
   
   var body: some View {
      VStack {
         // Header with token count
         HStack {
            Text("Claude 3.7 with Extended Thinking")
               .font(.headline)
            Spacer()
            if let inputTokensCount = observable.inputTokensCount {
               Text("Tokens: \(inputTokensCount)")
                  .font(.caption)
                  .foregroundColor(.secondary)
            }
         }
         .padding()
         
         // Thinking budget slider
         VStack(alignment: .leading) {
            Text("Thinking Budget: \(Int(thinkingBudget * 1000)) tokens")
               .font(.caption)
            Slider(value: $thinkingBudget, in: 1...32)
         }
         .padding(.horizontal)
         
         // Show/hide thinking toggle
         Toggle("Show Thinking Process", isOn: $showThinking)
            .padding(.horizontal)
         
         // Error message
         if !observable.errorMessage.isEmpty {
            Text(observable.errorMessage)
               .foregroundColor(.red)
               .padding()
         }
         
         // Main content area (scrollable)
         ScrollView {
            VStack(alignment: .leading, spacing: 16) {
               // Thinking content (only shown if toggle is on)
               if showThinking && !observable.thinkingContentMessage.isEmpty {
                  VStack(alignment: .leading) {
                     Text("Claude's Thinking:")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                     
                     Text(observable.thinkingContentMessage)
                        .foregroundColor(.blue.opacity(0.8))
                        .padding()
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(8)
                  }
                  .padding(.horizontal)
               }
               
               // Model's response
               if !observable.message.isEmpty {
                  VStack(alignment: .leading) {
                     Text("Claude's Response:")
                        .font(.subheadline)
                        .fontWeight(.bold)
                     
                     Text(observable.message)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                  }
                  .padding(.horizontal)
               }
            }
            .padding(.bottom, 100) // Extra padding for input area
         }
         
         Spacer()
         
         // Input area (fixed at bottom)
         VStack {
            HStack {
               Button("Clear Conversation") {
                  observable.clearConversation()
                  prompt = ""
               }
               .buttonStyle(.bordered)
               
               Spacer()
            }
            .padding(.horizontal)
            
            HStack {
               TextField("Enter your message...", text: $prompt, axis: .vertical)
                  .textFieldStyle(.roundedBorder)
                  .lineLimit(1...5)
               
               Button {
                  Task {
                     try await observable.sendMessage(
                        prompt: prompt,
                        budgetTokens: Int(thinkingBudget * 1000)
                     )
                     prompt = ""
                  }
               } label: {
                  Image(systemName: "paperplane.fill")
                     .foregroundColor(.blue)
               }
               .disabled(prompt.isEmpty || observable.isLoading)
            }
            .padding()
         }
         .background(Color(UIColor.systemBackground))
      }
      .overlay(
         Group {
            if observable.isLoading {
               VStack {
                  ProgressView()
                     .scaleEffect(1.5)
                  Text("Claude is thinking...")
                     .padding(.top)
               }
               .padding()
               .background(Color(UIColor.systemBackground).opacity(0.8))
               .cornerRadius(10)
               .shadow(radius: 10)
            }
         }
      )
   }
}
