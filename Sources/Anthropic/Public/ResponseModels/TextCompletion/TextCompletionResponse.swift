//
//  TextCompletionResponse.swift
//
//
//  Created by James Rochabrun on 1/28/24.
//

import Foundation

/// [Completion Response](https://docs.anthropic.com/claude/reference/complete_post)
public struct TextCompletionResponse: Decodable {
   
   /// Unique object identifier.
   ///
   /// The format and length of IDs may change over time.
   public let id: String
   
   public let type: String
   
   /// The resulting completion up to and excluding the stop sequences.
   public let completion: String
   
   /// The reason that we stopped.
   ///
   /// This may be one the following values:
   ///
   /// - "stop_sequence": we reached a stop sequence — either provided by you via the stop_sequences parameter,
   /// or a stop sequence built into the model
   ///
   /// - "max_tokens": we exceeded max_tokens_to_sample or the model's maximum
   public let stopReason: String
   
   /// The model that handled the request.
   public let model: String
}
