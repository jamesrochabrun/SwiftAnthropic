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

    // Skills endpoints
    case skills
    case skill(id: String)
    case skillVersions(skillId: String)
    case skillVersion(skillId: String, version: String)
  }
}

// MARK: AnthropicAPI+Endpoint

extension AnthropicAPI: Endpoint {

  var path: String {
    switch apiPath {
    case .messages: return "/v1/messages"
    case .countTokens: return "/v1/messages/count_tokens"
    case .textCompletions: return "/v1/complete"

    // Skills endpoints
    case .skills: return "/v1/skills"
    case .skill(let id): return "/v1/skills/\(id)"
    case .skillVersions(let skillId): return "/v1/skills/\(skillId)/versions"
    case .skillVersion(let skillId, let version): return "/v1/skills/\(skillId)/versions/\(version)"
    }
  }
}
