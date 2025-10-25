//
//  AIProxyService.swift
//
//
//  Created by Lou Zell on 7/31/24.
//

#if !os(Linux)
import Foundation

private let aiproxySecureDelegate = AIProxyCertificatePinningDelegate()


struct AIProxyService: AnthropicService {
  
  let httpClient: HTTPClient
  let decoder: JSONDecoder
  
  /// Your partial key is provided during the integration process at dashboard.aiproxy.pro
  /// Please see the [integration guide](https://www.aiproxy.pro/docs/integration-guide.html) for acquiring your partial key
  private let partialKey: String
  
  /// Your service URL is also provided during the integration process.
  private let serviceURL: String
  
  /// Optionally supply your own client IDs to annotate requests with in the AIProxy developer dashboard.
  /// It is safe to leave this blank (most people do). If you leave it blank, AIProxy generates client IDs for you.
  private let clientID: String?
  
  /// Set this flag to TRUE if you need to print request events in DEBUG builds.
  private let debugEnabled: Bool
  
  /// Defaults to "2023-06-01"
  private var apiVersion: String
  
  private let betaHeaders: [String]?
  
  init(
    partialKey: String,
    serviceURL: String,
    clientID: String? = nil,
    apiVersion: String = "2023-06-01",
    betaHeaders: [String]?,
    debugEnabled: Bool)
  {
    let decoderWithSnakeCaseStrategy = JSONDecoder()
    decoderWithSnakeCaseStrategy.keyDecodingStrategy = .convertFromSnakeCase
    self.decoder = decoderWithSnakeCaseStrategy
    self.partialKey = partialKey
    self.serviceURL = serviceURL
    self.clientID = clientID
    self.apiVersion = apiVersion
    self.betaHeaders = betaHeaders
    self.debugEnabled = debugEnabled
    self.httpClient = URLSessionHTTPClientAdapter(
      urlSession: URLSession(
        configuration: .default,
        delegate: aiproxySecureDelegate,
        delegateQueue: nil
      )
    )
  }
  
  // MARK: Message
  
  func createMessage(
    _ parameter: MessageParameter)
  async throws -> MessageResponse
  {
    var localParameter = parameter
    localParameter.stream = false
    let request = try await AnthropicAPI(base: serviceURL, apiPath: .messages).request(aiproxyPartialKey: partialKey, clientID: clientID, version: apiVersion, method: .post, params: localParameter, betaHeaders: betaHeaders)
    return try await fetch(type: MessageResponse.self, with: request, debugEnabled: debugEnabled)
  }
  
  func streamMessage(
    _ parameter: MessageParameter)
  async throws -> AsyncThrowingStream<MessageStreamResponse, Error>
  {
    var localParameter = parameter
    localParameter.stream = true
    let request = try await AnthropicAPI(base: serviceURL, apiPath: .messages).request(aiproxyPartialKey: partialKey, clientID: clientID, version: apiVersion, method: .post, params: localParameter, betaHeaders: betaHeaders)
    return try await fetchStream(type: MessageStreamResponse.self, with: request, debugEnabled: debugEnabled)
  }
  
  func countTokens(
    parameter: MessageTokenCountParameter)
  async throws -> MessageInputTokens
  {
    let request = try await AnthropicAPI(base: serviceURL, apiPath: .countTokens).request(aiproxyPartialKey: partialKey, clientID: clientID, version: apiVersion, method: .post, params: parameter, betaHeaders: betaHeaders)
    return try await fetch(type: MessageInputTokens.self, with: request, debugEnabled: debugEnabled)
  }
  
  // MARK: Text Completion
  
  func createTextCompletion(
    _ parameter: TextCompletionParameter)
  async throws -> TextCompletionResponse
  {
    var localParameter = parameter
    localParameter.stream = false
    let request = try await AnthropicAPI(base: serviceURL, apiPath: .textCompletions).request(aiproxyPartialKey: partialKey, clientID: clientID, version: apiVersion, method: .post, params: localParameter)
    return try await fetch(type: TextCompletionResponse.self, with: request, debugEnabled: debugEnabled)
  }
  
  func createStreamTextCompletion(
    _ parameter: TextCompletionParameter)
  async throws -> AsyncThrowingStream<TextCompletionStreamResponse, Error>
  {
    var localParameter = parameter
    localParameter.stream = true
    let request = try await AnthropicAPI(base: serviceURL, apiPath: .textCompletions).request(aiproxyPartialKey: partialKey, clientID: clientID, version: apiVersion, method: .post, params: localParameter)
    return try await fetchStream(type: TextCompletionStreamResponse.self, with: request, debugEnabled: debugEnabled)
  }

  // MARK: Skills Management

  func createSkill(
    _ parameter: SkillCreateParameter)
  async throws -> SkillResponse
  {
    let request = try await AnthropicAPI(base: serviceURL, apiPath: .skills).multipartRequest(
      aiproxyPartialKey: partialKey,
      clientID: clientID,
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

    let request = try await AnthropicAPI(base: serviceURL, apiPath: .skills).request(
      aiproxyPartialKey: partialKey,
      clientID: clientID,
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
    let request = try await AnthropicAPI(base: serviceURL, apiPath: .skill(id: skillId)).request(
      aiproxyPartialKey: partialKey,
      clientID: clientID,
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
    let request = try await AnthropicAPI(base: serviceURL, apiPath: .skill(id: skillId)).request(
      aiproxyPartialKey: partialKey,
      clientID: clientID,
      version: apiVersion,
      method: .delete,
      betaHeaders: betaHeaders
    )
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
    let request = try await AnthropicAPI(base: serviceURL, apiPath: .skillVersions(skillId: skillId)).multipartRequest(
      aiproxyPartialKey: partialKey,
      clientID: clientID,
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

    let request = try await AnthropicAPI(base: serviceURL, apiPath: .skillVersions(skillId: skillId)).request(
      aiproxyPartialKey: partialKey,
      clientID: clientID,
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
    let request = try await AnthropicAPI(base: serviceURL, apiPath: .skillVersion(skillId: skillId, version: version)).request(
      aiproxyPartialKey: partialKey,
      clientID: clientID,
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
    let request = try await AnthropicAPI(base: serviceURL, apiPath: .skillVersion(skillId: skillId, version: version)).request(
      aiproxyPartialKey: partialKey,
      clientID: clientID,
      version: apiVersion,
      method: .delete,
      betaHeaders: betaHeaders
    )
    let httpRequest = try HTTPRequest(from: request)
    let (_, response) = try await httpClient.data(for: httpRequest)

    guard response.statusCode == 200 || response.statusCode == 204 else {
      throw APIError.responseUnsuccessful(description: "Failed to delete skill version: status code \(response.statusCode)")
    }
  }
}
#endif
