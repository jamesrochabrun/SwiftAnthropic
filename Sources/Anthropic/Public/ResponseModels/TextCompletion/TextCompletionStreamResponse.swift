//
//  TextCompletionStreamResponse.swift
//
//
//  Created by James Rochabrun on 1/28/24.
//

import Foundation

/*
 Example Response:
 
 event: completion
 data: {"type": "completion", "completion": " Hello", "stop_reason": null, "model": "claude-2.0"}

 event: completion
 data: {"type": "completion", "completion": "!", "stop_reason": null, "model": "claude-2.0"}

 event: ping
 data: {"type": "ping"}

 event: completion
 data: {"type": "completion", "completion": " My", "stop_reason": null, "model": "claude-2.0"}

 event: completion
 data: {"type": "completion", "completion": " name", "stop_reason": null, "model": "claude-2.0"}

 event: completion
 data: {"type": "completion", "completion": " is", "stop_reason": null, "model": "claude-2.0"}

 event: completion
 data: {"type": "completion", "completion": " Claude", "stop_reason": null, "model": "claude-2.0"}

 event: completion
 data: {"type": "completion", "completion": ".", "stop_reason": null, "model": "claude-2.0"}

 event: completion
 data: {"type": "completion", "completion": "", "stop_reason": "stop_sequence", "model": "claude-2.0"}

 */

public struct TextCompletionStreamResponse: Decodable {
   
   public let type: String

   public let completion: String
   
   public let stopReason: String?
   
   public let model: String

}
