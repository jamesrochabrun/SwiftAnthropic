//
//  ChatView.swift
//  MCPClientChat
//
//  Created by James Rochabrun on 3/3/25.
//

import Foundation
import SwiftUI

// MARK: - ChatView

@MainActor
struct ChatView: View {

  // MARK: Internal

  let chatManager: ChatManager

  var body: some View {
    List {
      ChatMessagesView(chatMessages: chatManager.messages)
    }
    .listStyle(.plain)
    .scrollContentBackground(.hidden)
    .safeAreaInset(edge: .bottom) {
      ChatInputView(
        isStreamingResponse: chatManager.isProcessing,
        didSubmit: { sendMessage($0) },
        didTapStop: { chatManager.stop() })
    }
  }

  // MARK: Private

  private func sendMessage(_ message: String) {
    guard !message.isEmpty else { return }
    chatManager.send(message: ChatMessage(text: message, role: .user))
  }
}

// MARK: - ChatMessagesView

private struct ChatMessagesView: View {
  /// Flags to prevent messages from animating in multiple times as dependencies that drive `body` change
  @State private var shouldAnimateMessageIn = [UUID: Bool]()
  let chatMessages: [ChatMessage]

  var body: some View {
    VStack(alignment: .leading) {
      ChatMessageView(message: ChatMessage(text: "How can I help you?", role: .assistant), animateIn: true)
        .listRowSeparator(.hidden)

      ForEach(chatMessages) { message in
        ChatMessageView(message: message, animateIn: shouldAnimateMessageIn[message.id] ?? true)
          .listRowSeparator(.hidden)
          .transition(.opacity)
          .onAppear {
            shouldAnimateMessageIn[message.id] = false
          }
          .padding(.bottom, 4)
      }
    }
    .padding()
  }
}
