//
//  MessageDemoView.swift
//  SwiftAnthropicExample
//
//  Created by James Rochabrun on 2/24/24.
//

import Foundation
import SwiftAnthropic
import SwiftUI

struct MessageDemoView: View {
   
   let observable: MessageDemoObservable
   @State private var selectedSegment: ChatConfig = .messageStream
   @State private var prompt = ""

   enum ChatConfig {
      case message
      case messageStream
   }
   
   var body: some View {
      ScrollView {
         VStack {
            picker
            textArea
            Text(observable.errorMessage)
               .foregroundColor(.red)
            messageView
         }
         .padding()
      }
      .overlay(
         Group {
            if observable.isLoading {
               ProgressView()
            } else {
               EmptyView()
            }
         }
      )
   }
   
   var textArea: some View {
      HStack(spacing: 4) {
         TextField("Enter prompt", text: $prompt, axis: .vertical)
            .textFieldStyle(.roundedBorder)
            .padding()
         Button {
            Task {
               let messages = [MessageParameter.Message(role: "user", content: prompt)]
               prompt = ""
               let parameters = MessageParameter(
                  model: .claude2,
                  messages: messages,
                  maxTokens: 1024)
               switch selectedSegment {
               case .message:
                  try await observable.createMessage(parameters: parameters)
               case .messageStream:
                  try await observable.streamMessage(parameters: parameters)
               }
            }
         } label: {
            Image(systemName: "paperplane")
         }
         .buttonStyle(.bordered)
      }
      .padding()
   }
   
   var picker: some View {
      Picker("Options", selection: $selectedSegment) {
         Text("Message").tag(ChatConfig.message)
         Text("Message Stream").tag(ChatConfig.messageStream)
      }
      .pickerStyle(SegmentedPickerStyle())
      .padding()
   }
   
   /// stream = `true`
   var messageView: some View {
      VStack(spacing: 24) {
         Button("Cancel") {
            observable.cancelStream()
         }
         Button("Clear Message") {
            observable.clearMessage()
         }
         Text(observable.message)
      }
   }
}
