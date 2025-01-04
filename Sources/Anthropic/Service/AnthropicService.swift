//
//  AnthropicService.swift
//
//
//  Created by James Rochabrun on 1/28/24.
//

import Foundation

// MARK: Error

public enum APIError: Error {
   
   case requestFailed(description: String)
   case responseUnsuccessful(description: String)
   case invalidData
   case jsonDecodingFailure(description: String)
   case dataCouldNotBeReadMissingData(description: String)
   case bothDecodingStrategiesFailed
   case timeOutError
   
   public var displayDescription: String {
      switch self {
      case .requestFailed(let description): return description
      case .responseUnsuccessful(let description): return description
      case .invalidData: return "Invalid data"
      case .jsonDecodingFailure(let description): return description
      case .dataCouldNotBeReadMissingData(let description): return description
      case .bothDecodingStrategiesFailed: return "Decoding strategies failed."
      case .timeOutError: return "Time Out Error."
      }
   }
}

// MARK: Service

/// A protocol defining the required services for interacting with Anthropic's API.
///
/// The protocol outlines methods for fetching data and streaming responses,
/// as well as handling JSON decoding and networking tasks.
public protocol AnthropicService {
   
   /// The `URLSession` responsible for executing all network requests.
   ///
   /// This session is configured according to the needs of Anthropic's API,
   /// and it's used for tasks like sending and receiving data.
   var session: URLSession { get }
   /// The `JSONDecoder` instance used for decoding JSON responses.
   ///
   /// This decoder is used to parse the JSON responses returned by the API
   /// into model objects that conform to the `Decodable` protocol.
   var decoder: JSONDecoder { get }
   
   // MARK: Message
   
   /// Creates a message with the provided parameters.
   ///
   /// - Parameters:
   ///   - parameters: Parameters for the create message request.
   ///
   /// - Returns: A [MessageResponse](https://docs.anthropic.com/claude/reference/messages_post).
   ///
   /// - Throws: An error if the request fails.
   ///
   /// For more information, refer to [Anthropic's Message API documentation](https://docs.anthropic.com/claude/reference/messages_post).
   func createMessage(
      _ parameter: MessageParameter)
      async throws -> MessageResponse
   
   /// Creates a message stream with the provided parameters.
   ///
   /// - Parameters:
   ///   - parameters: Parameters for the create message request.
   ///
   /// - Returns: A streamed sequence of `MessageStreamResponse`.
   ///   For more details, see [MessageStreamResponse](https://docs.anthropic.com/claude/reference/messages-streaming).
   ///
   /// - Throws: An error if the request fails.
   ///
   /// For more information, refer to [Anthropic's Stream Message API documentation](https://docs.anthropic.com/claude/reference/messages-streaming).
   func streamMessage(
      _ parameter: MessageParameter)
      async throws -> AsyncThrowingStream<MessageStreamResponse, Error>
   
   /// Counts the number of tokens that would be used by a message for a given model.
   ///
   /// - Parameters:
   ///   - parameter: The parameters used to count tokens, including the model, messages, system prompt, and tools.
   ///
   /// - Returns: A `MessageInputTokens` object containing the count of input tokens.
   ///
   /// - Throws: An error if the token counting request fails.
   ///
   /// Example usage:
   /// ```swift
   /// let parameter = MessageTokenCountParameter(
   ///     model: .claude3Sonnet,
   ///     messages: [
   ///         .init(
   ///             role: .user,
   ///             content: .text("Hello, Claude!")
   ///         )
   ///     ]
   /// )
   ///
   /// let tokenCount = try await client.countTokens(parameter: parameter)
   /// print("Input tokens: \(tokenCount.inputTokens)")
   /// ```
   ///
   /// For more details, see [Count Message tokens](https://docs.anthropic.com/en/api/messages-count-tokens)
   func countTokens(
       parameter: MessageTokenCountParameter)
      async throws -> MessageInputTokens

   
   // MARK: Text Completion
   
   /// - Parameter parameters: Parameters for the create text completion request.
   /// - Returns: A [TextCompletionResponse](https://docs.anthropic.com/claude/reference/complete_post).
   /// - Throws: An error if the request fails.
   ///
   /// For more information, refer to [Anthropic's Text Completion API documentation](https://docs.anthropic.com/claude/reference/complete_post).
   func createTextCompletion(
      _ parameter: TextCompletionParameter)
      async throws -> TextCompletionResponse
   
   /// - Parameter parameters: Parameters for the create stream text completion request.
   /// - Returns: A [TextCompletionResponse](https://docs.anthropic.com/claude/reference/streaming).
   /// - Throws: An error if the request fails.
   ///
   /// For more information, refer to [Anthropic's Text Completion API documentation](https://docs.anthropic.com/claude/reference/streaming).
   func createStreamTextCompletion(
      _ parameter: TextCompletionParameter)
      async throws -> AsyncThrowingStream<TextCompletionStreamResponse, Error>
}

extension AnthropicService {
   
   /// Asynchronously fetches a decodable data type from Anthropic's API.
   ///
   /// - Parameters:
   ///   - type: The `Decodable` type that the response should be decoded to.
   ///   - request: The `URLRequest` describing the API request.
   ///   - debugEnabled: If true the service will print events on DEBUG builds.
   /// - Throws: An error if the request fails or if decoding fails.
   /// - Returns: A value of the specified decodable type.
   public func fetch<T: Decodable>(
      type: T.Type,
      with request: URLRequest,
      debugEnabled: Bool)
      async throws -> T
   {
      if debugEnabled {
         printCurlCommand(request)
      }
      let (data, response) = try await session.data(for: request)
      guard let httpResponse = response as? HTTPURLResponse else {
         throw APIError.requestFailed(description: "invalid response unable to get a valid HTTPURLResponse")
      }
      if debugEnabled {
         printHTTPURLResponse(httpResponse, data: data)
      }
      guard httpResponse.statusCode == 200 else {
         var errorMessage = "status code \(httpResponse.statusCode)"
         do {
            let errorResponse = try decoder.decode(ErrorResponse.self, from: data)
            errorMessage += errorResponse.error.message
         } catch {
            // If decoding fails, proceed with a general error message
            errorMessage = "status code \(httpResponse.statusCode)"
         }
         throw APIError.responseUnsuccessful(description: errorMessage)
      }
      #if DEBUG
      if debugEnabled {
         print("DEBUG JSON FETCH API = \(try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any])")
      }
      #endif
      do {
         return try decoder.decode(type, from: data)
      } catch let DecodingError.keyNotFound(key, context) {
         let debug = "Key '\(key.stringValue)' not found: \(context.debugDescription)"
         let codingPath = "codingPath: \(context.codingPath)"
         let debugMessage = debug + codingPath
      #if DEBUG
         if debugEnabled {
            print(debugMessage)
         }
      #endif
         throw APIError.dataCouldNotBeReadMissingData(description: debugMessage)
      } catch {
      #if DEBUG
         if debugEnabled {
            print("\(error)")
         }
      #endif
         throw APIError.jsonDecodingFailure(description: error.localizedDescription)
      }
   }
   
   /// Asynchronously fetches a stream of decodable data types from Anthropic's API for chat completions.
   ///
   /// This method is primarily used for streaming chat completions.
   ///
   /// - Parameters:
   ///   - type: The `Decodable` type that each streamed response should be decoded to.
   ///   - request: The `URLRequest` describing the API request.
   ///   - debugEnabled: If true the service will print events on DEBUG builds.
   /// - Throws: An error if the request fails or if decoding fails.
   /// - Returns: An asynchronous throwing stream of the specified decodable type.
   public func fetchStream<T: Decodable>(
      type: T.Type,
      with request: URLRequest,
      debugEnabled: Bool)
      async throws -> AsyncThrowingStream<T, Error>
   {
      if debugEnabled {
         printCurlCommand(request)
      }
      
      let (data, response) = try await session.bytes(for: request)
      guard let httpResponse = response as? HTTPURLResponse else {
         throw APIError.requestFailed(description: "invalid response unable to get a valid HTTPURLResponse")
      }
      if debugEnabled {
         printHTTPURLResponse(httpResponse)
      }
      guard httpResponse.statusCode == 200 else {
         var errorMessage = "status code \(httpResponse.statusCode)"
         do {
            let data = try await data.reduce(into: Data()) { data, byte in
               data.append(byte)
            }
            let errorResponse = try decoder.decode(ErrorResponse.self, from: data)
            errorMessage += errorResponse.error.message
         } catch {
            // If decoding fails, proceed with a general error message
            errorMessage = "status code \(httpResponse.statusCode)"
         }
         throw APIError.responseUnsuccessful(description: errorMessage)
      }
      return AsyncThrowingStream { continuation in
         let task = Task {
            do {
               for try await line in data.lines {
                  // TODO: Test the `event` line
                  if line.hasPrefix("data:"),
                     let data = line.dropFirst(5).data(using: .utf8) {
                     #if DEBUG
                     if debugEnabled {
                        print("DEBUG JSON STREAM LINE = \(try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any])")
                     }
                     #endif
                     do {
                        let decoded = try self.decoder.decode(T.self, from: data)
                        continuation.yield(decoded)
                     } catch let DecodingError.keyNotFound(key, context) {
                        let debug = "Key '\(key.stringValue)' not found: \(context.debugDescription)"
                        let codingPath = "codingPath: \(context.codingPath)"
                        let debugMessage = debug + codingPath
                     #if DEBUG
                        if debugEnabled {
                           print(debugMessage)
                        }
                     #endif
                        throw APIError.dataCouldNotBeReadMissingData(description: debugMessage)
                     } catch {
                     #if DEBUG
                        if debugEnabled {
                           debugPrint("CONTINUATION ERROR DECODING \(error.localizedDescription)")
                        }
                     #endif
                        continuation.finish(throwing: error)
                     }
                  }
               }
               continuation.finish()
            } catch let DecodingError.keyNotFound(key, context) {
               let debug = "Key '\(key.stringValue)' not found: \(context.debugDescription)"
               let codingPath = "codingPath: \(context.codingPath)"
               let debugMessage = debug + codingPath
               #if DEBUG
               if debugEnabled {
                  print(debugMessage)
               }
               #endif
               throw APIError.dataCouldNotBeReadMissingData(description: debugMessage)
            } catch {
               #if DEBUG
               if debugEnabled {
                  print("CONTINUATION ERROR DECODING \(error.localizedDescription)")
               }
               #endif
               continuation.finish(throwing: error)
            }
         }
         continuation.onTermination = { @Sendable _ in
            task.cancel()
         }
      }
   }
   
   // MARK: Debug Helpers

   private func prettyPrintJSON(
      _ data: Data)
      -> String?
   {
      guard
         let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
         let prettyData = try? JSONSerialization.data(withJSONObject: jsonObject, options: [.prettyPrinted]),
         let prettyPrintedString = String(data: prettyData, encoding: .utf8)
      else { return nil }
      return prettyPrintedString
   }
   
   private func printCurlCommand(
      _ request: URLRequest)
   {
      guard let url = request.url, let httpMethod = request.httpMethod else {
         debugPrint("Invalid URL or HTTP method.")
         return
      }
      
      var baseCommand = "curl \(url.absoluteString)"
      
      // Add method if not GET
      if httpMethod != "GET" {
         baseCommand += " -X \(httpMethod)"
      }
      
      // Add headers if any, masking the Authorization token
      if let headers = request.allHTTPHeaderFields {
         for (header, value) in headers {
            let maskedValue = header.lowercased() == "authorization" ? maskAuthorizationToken(value) : value
            baseCommand += " \\\n-H \"\(header): \(maskedValue)\""
         }
      }
      
      // Add body if present
      if let httpBody = request.httpBody, let bodyString = prettyPrintJSON(httpBody) {
         // The body string is already pretty printed and should be enclosed in single quotes
         baseCommand += " \\\n-d '\(bodyString)'"
      }
      
      // Print the final command
   #if DEBUG
      print(baseCommand)
   #endif
   }
   
   private func prettyPrintJSON(
      _ data: Data)
      -> String
   {
      guard
         let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
         let prettyData = try? JSONSerialization.data(withJSONObject: jsonObject, options: [.prettyPrinted]),
         let prettyPrintedString = String(data: prettyData, encoding: .utf8) else { return "Could not print JSON - invalid format" }
      return prettyPrintedString
   }
   
   private func printHTTPURLResponse(
      _ response: HTTPURLResponse,
      data: Data? = nil)
   {
   #if DEBUG
      print("\n- - - - - - - - - - INCOMING RESPONSE - - - - - - - - - -\n")
      print("URL: \(response.url?.absoluteString ?? "No URL")")
      print("Status Code: \(response.statusCode)")
      print("Headers: \(response.allHeaderFields)")
      if let mimeType = response.mimeType {
         print("MIME Type: \(mimeType)")
      }
      if let data = data, response.mimeType == "application/json" {
         print("Body: \(prettyPrintJSON(data))")
      } else if let data = data, let bodyString = String(data: data, encoding: .utf8) {
         print("Body: \(bodyString)")
      }
      print("\n- - - - - - - - - - - - - - - - - - - - - - - - - - - -\n")
   #endif
   }
   
   private func maskAuthorizationToken(_ token: String) -> String {
      if token.count > 6 {
         let prefix = String(token.prefix(3))
         let suffix = String(token.suffix(3))
         return "\(prefix)................\(suffix)"
      } else {
         return "INVALID TOKEN LENGTH"
      }
   }
}
