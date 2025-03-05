//
//  ChatMessage.swift
//  MCPClientChat
//
//  Created by James Rochabrun on 3/3/25.
//

import Foundation

/// Data model to represent a chat message
struct ChatMessage: Identifiable, Equatable {
  /// Unique identifier
  let id = UUID()

  /// The body of the chat message
  var text: String

  /// The role of the message
  let role: Role

  /// Indicates that we are waiting for the first bit of message content from OpenAI
  var isWaitingForFirstText = false

  enum Role {
    case user
    case assistant
  }
}
