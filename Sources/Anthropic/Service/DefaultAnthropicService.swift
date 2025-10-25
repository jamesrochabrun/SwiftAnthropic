//
//  DefaultAnthropicService.swift
//
//
//  Created by James Rochabrun on 1/28/24.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

struct DefaultAnthropicService: AnthropicService {
  
  let httpClient: HTTPClient
  let decoder: JSONDecoder
  let apiKey: String
  let apiVersion: String
  let basePath: String
  let betaHeaders: [String]?
  /// Set this flag to TRUE if you need to print request events in DEBUG builds.
  private let debugEnabled: Bool
  
  init(
    apiKey: String,
    apiVersion: String = "2023-06-01",
    basePath: String,
    betaHeaders: [String]?,
    httpClient: HTTPClient,
    debugEnabled: Bool)
  {
    self.httpClient = httpClient
    let decoderWithSnakeCaseStrategy = JSONDecoder()
    decoderWithSnakeCaseStrategy.keyDecodingStrategy = .convertFromSnakeCase
    self.decoder = decoderWithSnakeCaseStrategy
    self.apiKey = apiKey
    self.apiVersion = apiVersion
    self.basePath = basePath
    self.betaHeaders = betaHeaders
    self.debugEnabled = debugEnabled
  }
  
  // MARK: Message
  
  func createMessage(
    _ parameter: MessageParameter)
  async throws -> MessageResponse
  {
    var localParameter = parameter
    localParameter.stream = false
    let request = try AnthropicAPI(base: basePath, apiPath: .messages).request(apiKey: apiKey, version: apiVersion, method: HTTPMethod.post, params: localParameter, betaHeaders: betaHeaders)
    return try await fetch(type: MessageResponse.self, with: request, debugEnabled: debugEnabled)
  }
  
  func streamMessage(
    _ parameter: MessageParameter)
  async throws -> AsyncThrowingStream<MessageStreamResponse, Error>
  {
    var localParameter = parameter
    localParameter.stream = true
    let request = try AnthropicAPI(base: basePath, apiPath: .messages).request(apiKey: apiKey, version: apiVersion, method: HTTPMethod.post, params: localParameter, betaHeaders: betaHeaders)
    return try await fetchStream(type: MessageStreamResponse.self, with: request, debugEnabled: debugEnabled)
  }
  
  func countTokens(
    parameter: MessageTokenCountParameter)
  async throws -> MessageInputTokens
  {
    let request = try AnthropicAPI(base: basePath, apiPath: .countTokens).request(apiKey: apiKey, version: apiVersion, method: HTTPMethod.post, params: parameter, betaHeaders: betaHeaders)
    return try await fetch(type: MessageInputTokens.self, with: request, debugEnabled: debugEnabled)
  }
  
  /// "messages-2023-12-15"
  // MARK: Text Completion
  
  func createTextCompletion(
    _ parameter: TextCompletionParameter)
  async throws -> TextCompletionResponse
  {
    var localParameter = parameter
    localParameter.stream = false
    let request = try AnthropicAPI(base: basePath, apiPath: .textCompletions).request(apiKey: apiKey, version: apiVersion, method: HTTPMethod.post, params: localParameter)
    return try await fetch(type: TextCompletionResponse.self, with: request, debugEnabled: debugEnabled)
  }
  
  func createStreamTextCompletion(
    _ parameter: TextCompletionParameter)
  async throws -> AsyncThrowingStream<TextCompletionStreamResponse, Error>
  {
    var localParameter = parameter
    localParameter.stream = true
    let request = try AnthropicAPI(base: basePath, apiPath: .textCompletions).request(apiKey: apiKey, version: apiVersion, method: HTTPMethod.post, params: localParameter)
    return try await fetchStream(type: TextCompletionStreamResponse.self, with: request, debugEnabled: debugEnabled)
  }

  // MARK: Skills Management

  func createSkill(
    _ parameter: SkillCreateParameter)
  async throws -> SkillResponse
  {
    let request = try AnthropicAPI(base: basePath, apiPath: .skills).multipartRequest(
      apiKey: apiKey,
      version: apiVersion,
      method: .post,
      displayTitle: parameter.displayTitle,
      files: parameter.files,
      betaHeaders: betaHeaders
    )
    return try await fetch(type: SkillResponse.self, with: request, debugEnabled: debugEnabled)
  }

  func listSkills(
    parameter: ListSkillsParameter?)
  async throws -> ListSkillsResponse
  {
    var queryItems: [URLQueryItem] = []
    if let page = parameter?.page {
      queryItems.append(URLQueryItem(name: "page", value: page))
    }
    if let limit = parameter?.limit {
      queryItems.append(URLQueryItem(name: "limit", value: "\(limit)"))
    }
    if let source = parameter?.source {
      queryItems.append(URLQueryItem(name: "source", value: source.rawValue))
    }

    let request = try AnthropicAPI(base: basePath, apiPath: .skills).request(
      apiKey: apiKey,
      version: apiVersion,
      method: .get,
      betaHeaders: betaHeaders,
      queryItems: queryItems
    )
    return try await fetch(type: ListSkillsResponse.self, with: request, debugEnabled: debugEnabled)
  }

  func retrieveSkill(
    skillId: String)
  async throws -> SkillResponse
  {
    let request = try AnthropicAPI(base: basePath, apiPath: .skill(id: skillId)).request(
      apiKey: apiKey,
      version: apiVersion,
      method: .get,
      betaHeaders: betaHeaders
    )
    return try await fetch(type: SkillResponse.self, with: request, debugEnabled: debugEnabled)
  }

  func deleteSkill(
    skillId: String)
  async throws
  {
    let request = try AnthropicAPI(base: basePath, apiPath: .skill(id: skillId)).request(
      apiKey: apiKey,
      version: apiVersion,
      method: .delete,
      betaHeaders: betaHeaders
    )
    // For DELETE requests, we just need to check the response status
    let httpRequest = try HTTPRequest(from: request)
    let (_, response) = try await httpClient.data(for: httpRequest)

    guard response.statusCode == 200 || response.statusCode == 204 else {
      throw APIError.responseUnsuccessful(description: "Failed to delete skill: status code \(response.statusCode)")
    }
  }

  // MARK: Skill Versions

  func createSkillVersion(
    skillId: String,
    _ parameter: SkillVersionCreateParameter)
  async throws -> SkillVersionResponse
  {
    let request = try AnthropicAPI(base: basePath, apiPath: .skillVersions(skillId: skillId)).multipartRequest(
      apiKey: apiKey,
      version: apiVersion,
      method: .post,
      displayTitle: nil,
      files: parameter.files,
      betaHeaders: betaHeaders
    )
    return try await fetch(type: SkillVersionResponse.self, with: request, debugEnabled: debugEnabled)
  }

  func listSkillVersions(
    skillId: String,
    parameter: ListSkillVersionsParameter?)
  async throws -> ListSkillVersionsResponse
  {
    var queryItems: [URLQueryItem] = []
    if let page = parameter?.page {
      queryItems.append(URLQueryItem(name: "page", value: page))
    }
    if let limit = parameter?.limit {
      queryItems.append(URLQueryItem(name: "limit", value: "\(limit)"))
    }

    let request = try AnthropicAPI(base: basePath, apiPath: .skillVersions(skillId: skillId)).request(
      apiKey: apiKey,
      version: apiVersion,
      method: .get,
      betaHeaders: betaHeaders,
      queryItems: queryItems
    )
    return try await fetch(type: ListSkillVersionsResponse.self, with: request, debugEnabled: debugEnabled)
  }

  func retrieveSkillVersion(
    skillId: String,
    version: String)
  async throws -> SkillVersionResponse
  {
    let request = try AnthropicAPI(base: basePath, apiPath: .skillVersion(skillId: skillId, version: version)).request(
      apiKey: apiKey,
      version: apiVersion,
      method: .get,
      betaHeaders: betaHeaders
    )
    return try await fetch(type: SkillVersionResponse.self, with: request, debugEnabled: debugEnabled)
  }

  func deleteSkillVersion(
    skillId: String,
    version: String)
  async throws
  {
    let request = try AnthropicAPI(base: basePath, apiPath: .skillVersion(skillId: skillId, version: version)).request(
      apiKey: apiKey,
      version: apiVersion,
      method: .delete,
      betaHeaders: betaHeaders
    )
    // For DELETE requests, we just need to check the response status
    let httpRequest = try HTTPRequest(from: request)
    let (_, response) = try await httpClient.data(for: httpRequest)

    guard response.statusCode == 200 || response.statusCode == 204 else {
      throw APIError.responseUnsuccessful(description: "Failed to delete skill version: status code \(response.statusCode)")
    }
  }

}
