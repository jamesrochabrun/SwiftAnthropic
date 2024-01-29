//
//  MessageResponse.swift
//
//
//  Created by James Rochabrun on 1/28/24.
//

import Foundation

/*
 {
   "id": "msg_013Zva2CMHLNnXjNJJKqJ2EF",
   "type": "message",
   "model": "claude-2.1",
   "role": "assistant",
   "content": [
     {
       "type": "text",
       "text": "Blue is often seen as a calming and soothing color."
     }
   ],
   "stop_reason": "end_turn",
   "stop_sequence": null
 }
 */

public struct MessageResponse: Decodable {
   
   public let id: String
   
   public let type: String
   
   public let model: String
   
   public let role: String
   
   public let content: Content
   
   public let stopReason: String
   
   public let stopSequence: String
   
   
   public struct Content: Decodable {
      
      public let type: String
      
      public let text: String
   }
}
