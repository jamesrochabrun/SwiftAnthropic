//
//  TextCompletionResponse.swift
//
//
//  Created by James Rochabrun on 1/28/24.
//

import Foundation

/*
 {
   "id": "compl_018CKm6gsux7P8yMcwZbeCPw",
   "type": "completion",
   "completion": " Hello! My name is Claude.",
   "stop_reason": "stop_sequence",
   "model": "claude-2.1"
 }
 */

public struct TextCompletionResponse: Decodable {
   
   public let id: String
   
   public let type: String
   
   public let completion: String
   
   public let stopReason: String
   
   public let model: String
}
