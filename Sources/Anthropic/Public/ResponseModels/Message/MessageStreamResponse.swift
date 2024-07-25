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
   
   public struct Delta: Decodable {
      
      public let type: String?
      
      /// type = text
      public let text: String?
      
      /// type = tool_use
      public let partialJson: String?

      public let stopReason: String?
      
      public let stopSequence: String?
   }
   
   public struct ContentBlock: Decodable {
      
      // Can be of type `text` or `tool_use`
      public let type: String
      
      /// `text` type
      public let text: String?
      
      /// `tool_use` type
      
      public let input: [String: MessageResponse.Content.DynamicContent]?
      
      public let name: String?
      
      public let id: String?
      
      public var toolUse: MessageResponse.Content.ToolUse? {
         guard let name, let id else { return nil }
         return .init(id: id, name: name, input: input ?? [:])
      }
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
