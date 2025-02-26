//
//  MessageStreamResponse.swift
//
//
//  Created by James Rochabrun on 1/28/24.
//

import Foundation

/// [Message Stream Response](https://docs.anthropic.com/claude/reference/messages-streaming).
///
/// Each server-sent event includes a named event type and associated JSON data. Each event will use an SSE event name (e.g. event: message_stop), and include the matching event type in its data.
///
/// Each stream uses the following event flow:
///
/// message_start: contains a Message object with empty content.
/// A series of content blocks, each of which have a content_block_start, one or more content_block_delta events, and a content_block_stop event. Each content block will have an index that corresponds to its index in the final Message content array.
/// One or more message_delta events, indicating top-level changes to the final Message object.
/// A final message_stop event.
///
/// This structured sequence facilitates the orderly reception and processing of message components and overall changes.
public struct MessageStreamResponse: Decodable {
   
   public let type: String
   
   public let index: Int?
   
   /// available in "content_block_start" event
   public let contentBlock: ContentBlock?
   
   /// available in "message_start" event
   public let message: MessageResponse?
   
   /// Available in "content_block_delta", "message_delta" events.
   public let delta: Delta?
    
   /// Available in "message_delta" events.
   public let usage: MessageResponse.Usage?
   
   public var streamEvent: StreamEvent? {
      StreamEvent(rawValue: type)
   }
   
   public let error: Error?
   
   public struct Delta: Decodable {
      
      public let type: String?
      
      /// type = text
      public let text: String?
      
      /// type = thinking_delta
      public let thinking: String?
      
      /// type = signature_delta
      public let signature: String?
      
      /// type = tool_use
      public let partialJson: String?
      
      // type = citations_delta
      public let citation: MessageResponse.Citation?

      public let stopReason: String?
      
      public let stopSequence: String?
   }
   
   public struct ContentBlock: Decodable {
      
      // Can be of type `text`, `tool_use`, `thinking`, or `redacted_thinking`
      public let type: String
      
      /// `text` type
      public let text: String?
      
      /// `thinking` type
      public let thinking: String?
      
      /// `redacted_thinking` type
      public let data: String?
      
      // Citations for text type
      public let citations: [MessageResponse.Citation]?
      
      /// `tool_use` type
      public let input: [String: MessageResponse.Content.DynamicContent]?
      
      public let name: String?
      
      public let id: String?
      
      public var toolUse: MessageResponse.Content.ToolUse? {
         guard let name, let id else { return nil }
         return .init(id: id, name: name, input: input ?? [:])
      }
   }
   
   public struct Error: Decodable {
      
      /// The error type, for example "overloaded_error"
      public let type: String
      
      /// The error message, for example "Overloaded"
      public let message: String
   }
   
   /// https://docs.anthropic.com/en/api/messages-streaming#event-types
   public enum StreamEvent: String {
      
      case contentBlockStart = "content_block_start"
      case contentBlockDelta = "content_block_delta"
      case contentBlockStop = "content_block_stop"
      case messageStart = "message_start"
      case messageDelta = "message_delta"
      case messageStop = "message_stop"
   }
}

extension MessageStreamResponse {
   
   /// Helper to check if the delta contains thinking content
   public var isThinkingDelta: Bool {
      return delta?.type == "thinking_delta"
   }
   
   /// Helper to check if the delta contains a signature update
   public var isSignatureDelta: Bool {
      return delta?.type == "signature_delta"
   }
   
   /// Helper to check if the content block is a thinking block
   public var isThinkingBlock: Bool {
      return contentBlock?.type == "thinking"
   }
   
   /// Helper to check if the content block is a redacted thinking block
   public var isRedactedThinkingBlock: Bool {
      return contentBlock?.type == "redacted_thinking"
   }
}
