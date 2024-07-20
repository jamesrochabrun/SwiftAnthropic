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
   /// Set this flag to TRUE if you need to print request events in DEBUG builds.
   private let debugEnabled: Bool
   
   private static let betaHeader = "max-tokens-3-5-sonnet-2024-07-15"

   init(
      apiKey: String,
      apiVersion: String = "2023-06-01",
      basePath: String,
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
      self.debugEnabled = debugEnabled
   }
   
   // MARK: Message

   func createMessage(
      _ parameter: MessageParameter)
      async throws -> MessageResponse
   {
      var localParameter = parameter
      localParameter.stream = false
      let request = try AnthropicAPI(base: basePath, apiPath: .messages).request(apiKey: apiKey, version: apiVersion, method: .post, params: localParameter, beta: Self.betaHeader)
      return try await fetch(type: MessageResponse.self, with: request, debugEnabled: debugEnabled)
   }
   
   func streamMessage(
      _ parameter: MessageParameter)
      async throws -> AsyncThrowingStream<MessageStreamResponse, Error>
   {
      var localParameter = parameter
      localParameter.stream = true
      let request = try AnthropicAPI(base: basePath, apiPath: .messages).request(apiKey: apiKey, version: apiVersion, method: .post, params: localParameter, beta: Self.betaHeader)
      return try await fetchStream(type: MessageStreamResponse.self, with: request, debugEnabled: debugEnabled)
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
