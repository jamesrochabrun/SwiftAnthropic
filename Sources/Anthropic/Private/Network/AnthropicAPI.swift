//
//  AnthropicAPI.swift
//
//
//  Created by James Rochabrun on 1/28/24.
//

import Foundation

// MARK: AnthropicAPI

struct AnthropicAPI {
   
   let base: String
   let apiPath: APIPath
   
   enum APIPath {
      case messages
      case textCompletions
      case countTokens
   }
}

// MARK: AnthropicAPI+Endpoint

extension AnthropicAPI: Endpoint {
   
   var path: String {
      switch apiPath {
      case .messages: return "/v1/messages"
      case .countTokens: return "/v1/messages/count_tokens"
      case .textCompletions: return "/v1/complete"
      }
   }
}
