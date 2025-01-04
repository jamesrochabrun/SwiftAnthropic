//
//  DefaultAnthropicService.swift
//
//
//  Created by James Rochabrun on 1/28/24.
//

import Foundation

struct DefaultAnthropicService: AnthropicService {

   let session: URLSession
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
      configuration: URLSessionConfiguration = .default,
      debugEnabled: Bool)
   {
      self.session = URLSession(configuration: configuration)
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
      let request = try AnthropicAPI(base: basePath, apiPath: .messages).request(apiKey: apiKey, version: apiVersion, method: .post, params: localParameter, betaHeaders: betaHeaders)
      return try await fetch(type: MessageResponse.self, with: request, debugEnabled: debugEnabled)
   }
   
   func streamMessage(
      _ parameter: MessageParameter)
      async throws -> AsyncThrowingStream<MessageStreamResponse, Error>
   {
      var localParameter = parameter
      localParameter.stream = true
      let request = try AnthropicAPI(base: basePath, apiPath: .messages).request(apiKey: apiKey, version: apiVersion, method: .post, params: localParameter, betaHeaders: betaHeaders)
      return try await fetchStream(type: MessageStreamResponse.self, with: request, debugEnabled: debugEnabled)
   }
   
   func countTokens(
      parameter: MessageTokenCountParameter)
      async throws -> MessageInputTokens
   {
      let request = try AnthropicAPI(base: basePath, apiPath: .countTokens).request(apiKey: apiKey, version: apiVersion, method: .post, params: parameter, betaHeaders: betaHeaders)
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
      let request = try AnthropicAPI(base: basePath, apiPath: .textCompletions).request(apiKey: apiKey, version: apiVersion, method: .post, params: localParameter)
      return try await fetch(type: TextCompletionResponse.self, with: request, debugEnabled: debugEnabled)
   }
   
   func createStreamTextCompletion(
      _ parameter: TextCompletionParameter)
      async throws -> AsyncThrowingStream<TextCompletionStreamResponse, Error>
   {
      var localParameter = parameter
      localParameter.stream = true
      let request = try AnthropicAPI(base: basePath, apiPath: .textCompletions).request(apiKey: apiKey, version: apiVersion, method: .post, params: localParameter)
      return try await fetchStream(type: TextCompletionStreamResponse.self, with: request, debugEnabled: debugEnabled)
   }
   
}
