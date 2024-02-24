//
//  MessageStreamResponse.swift
//
//
//  Created by James Rochabrun on 1/28/24.
//

import Foundation

/// [Message Stream Response](https://docs.anthropic.com/claude/reference/messages-streaming).
///
/// ## Event Types
/// Each server-sent event is paired with a specific event type and accompanying JSON data. Events are named using SSE event names (e.g., `event: message_stop`) and include a corresponding event type within their data payload.
///
/// ### Event Flow
/// Events within a stream follow a predefined sequence:
///
/// - `message_start`: Signals the beginning of a message, carrying a Message object with no content.
///
/// - `content_block` events sequence:
///   - `content_block_start`: Marks the start of a content block, which is part of the final Message content. Each block has an index correlating to its position within the Message content array.
///   - `content_block_delta`: Represents interim updates within a content block. There can be one or more of these events for each content block.
///   - `content_block_stop`: Indicates the end of a content block.
///
/// - `message_delta` events: Reflect top-level modifications to the final Message object. There may be one or more such events.
///
/// - `message_stop`: Denotes the conclusion of the message transmission.
///
/// This structured sequence facilitates the orderly reception and processing of message components and overall changes.
public struct MessageStreamResponse: Decodable {
   
   public let type: String
   
   public let index: Int?
   
   public let contentBlock: ContentBlock?
   
   public let message: MessageResponse?
   
   public let delta: Delta?
   
   public struct Delta: Decodable {
      
      public let type: String?
      
      public let text: String?
      
      public let stopReason: String?
      
      public let stopSequence: String?
   }
   
   public struct ContentBlock: Decodable {
      
      public let type: String
      
      public let text: String
   }
}
