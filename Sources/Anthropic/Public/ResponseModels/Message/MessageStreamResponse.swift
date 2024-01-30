//
//  MessageStreamResponse.swift
//
//
//  Created by James Rochabrun on 1/28/24.
//

import Foundation


/*
 Example Response:
 
 event: message_start
 data: {"type": "message_start", "message": {"id": "msg_1nZdL29xx5MUA1yADyHTEsnR8uuvGzszyY", "type": "message", "role": "assistant", "content": [], "model": "claude-2.1", "stop_reason": null, "stop_sequence": null}}
 
 event: content_block_start
 data: {"type": "content_block_start", "index":0, "content_block": {"type": "text", "text": ""}}
 
 event: ping
 data: {"type": "ping"}
 
 event: content_block_delta
 data: {"type": "content_block_delta", "index": 0, "delta": {"type": "text_delta", "text": "Hello"}}
 
 event: content_block_delta
 data: {"type": "content_block_delta", "index": 0, "delta": {"type": "text_delta", "text": "!"}}
 
 event: content_block_stop
 data: {"type": "content_block_stop", "index": 0}
 
 event: message_delta
 data: {"type": "message_delta", "delta": {"stop_reason": "end_turn", "stop_sequence":null}}
 
 event: message_stop
 data: {"type": "message_stop"}
 */

public struct MessageStreamResponse: Decodable {
   
   public let type: String
   
   public let index: Int?
   
   public let message: Message?
   
   public let delta: Delta?
   
   public struct Message: Decodable {
      
      public let id: String?
      
      public let type: String?
      
      public let role: String?
      
      public let content: [Content]?
      
      public let usage: Usage?
      
      let model: String?
      
      public let stopReason: String?
      
      public let stopSequence: String?
      
      public struct Content: Decodable {
         
         public let type: String
         
         public let text: String
      }
      
      public struct Usage: Decodable {
         
         public let inputTokens: Int?
         
         public let outputTokens: Int?
      }
   }
   
   public struct Delta: Decodable {
      
      public let type: String
      
      public let text: String
      
      public let stopReason: String?
      
      public let stopSequence: String?
   }
}
