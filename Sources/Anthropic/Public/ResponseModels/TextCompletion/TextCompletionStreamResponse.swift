//
//  TextCompletionStreamResponse.swift
//
//
//  Created by James Rochabrun on 1/28/24.
//

import Foundation

/// [Text Completion Response](https://docs.anthropic.com/claude/reference/streaming)
public struct TextCompletionStreamResponse: Decodable {
   
   public let type: String

   public let completion: String?
   
   public let stopReason: String?
   
   public let model: String?

}
