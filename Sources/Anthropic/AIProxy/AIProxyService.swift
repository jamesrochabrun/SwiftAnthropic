//
//  AIProxyService.swift
//
//
//  Created by Lou Zell on 7/31/24.
//

import Foundation

private let aiproxySecureDelegate = AIProxyCertificatePinningDelegate()


struct AIProxyService: AnthropicService {

   let session: URLSession
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
      self.session = URLSession(
         configuration: .default,
         delegate: aiproxySecureDelegate,
         delegateQueue: nil
      )
      let decoderWithSnakeCaseStrategy = JSONDecoder()
      decoderWithSnakeCaseStrategy.keyDecodingStrategy = .convertFromSnakeCase
      self.decoder = decoderWithSnakeCaseStrategy
      self.partialKey = partialKey
      self.serviceURL = serviceURL
      self.clientID = clientID
      self.apiVersion = apiVersion
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
}


