//
//  ChatMessageView.swift
//  MCPClientChat
//
//  Created by James Rochabrun on 3/3/25.
//

import Foundation
import SwiftUI

struct ChatMessageView: View {

   /// The message to display
   let message: ChatMessage

   /// Whether to animate in the chat bubble
   let animateIn: Bool

   /// State used to animate in the chat bubble if `animateIn` is true
   @State private var animationTrigger = false

   var body: some View {
      HStack(alignment: .top, spacing: 12) {
         chatIcon
         VStack(alignment: .leading) {
            chatName
            chatBody
         }
      }
      .opacity(bubbleOpacity)
      .animation(.easeIn(duration: 0.75), value: animationTrigger)
      .onAppear {
         adjustAnimationTriggerIfNecessary()
      }
   }

   private var bubbleOpacity: Double {
      guard animateIn else {
         return 1
      }
      return animationTrigger ? 1 : 0
   }

   private func adjustAnimationTriggerIfNecessary() {
      guard animateIn else {
         return
      }
      animationTrigger = true
   }

   private var chatIcon: some View {
      Image(systemName: message.role == .user ? "person.circle.fill" : "lightbulb.circle")
         .font(.title2)
         .frame(width:24, height:24)
         .foregroundColor(message.role == .user ? .primary : .orange)
   }

   private var chatName: some View {
      Text(message.role == .user ? "You" : "Assistant")
         .fontWeight(.bold)
         .frame(maxWidth: .infinity, maxHeight:24, alignment: .leading)
   }

   @ViewBuilder
   private var chatBody: some View {
      if message.role == .user {
         Text(LocalizedStringKey(message.text))
            .fixedSize(horizontal: false, vertical: true)
            .foregroundColor(.primary)
      } else {
         if message.isWaitingForFirstText {
            ProgressView()
         } else {
            Text(LocalizedStringKey(message.text))
               .fixedSize(horizontal: false, vertical: true)
               .foregroundColor(.primary)
         }
      }
   }
}

#Preview {
   ChatMessageView(message: ChatMessage(text: "hello", role: .user), animateIn: false)
      .frame(maxWidth:.infinity)
      .padding()
}
