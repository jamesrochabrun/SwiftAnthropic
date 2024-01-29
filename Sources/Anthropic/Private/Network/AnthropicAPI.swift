//
//  AnthropicAPI.swift
//
//
//  Created by James Rochabrun on 1/28/24.
//

import Foundation

// MARK: AnthropicAPI

enum AnthropicAPI {
   case messages
   case textCompletions
}

// MARK: AnthropicAPI+Endpoint

extension AnthropicAPI: Endpoint {
   
   var base: String {
      "https://api.anthropic.com"
   }
   
   var path: String {
      switch self {
      case .messages: return "/v1/messages"
      case .textCompletions: return "/v1/complete"
      }
   }
}
