//
//  MCPLLMClient.swift
//  MCPClientChat
//
//  Created by James Rochabrun on 3/3/25.
//

import Foundation
import MCPClient
import MCPInterface
import SwiftAnthropic
import SwiftOpenAI

// TODO: James+Gui decide where this should live so it can be reused.

// MARK: Anthropic

/**
 * Extension that bridges the MCP (Multi-Client Protocol) framework with [SwiftAnthropic](https://github.com/jamesrochabrun/SwiftAnthropic) library.
 *
 * This Extension provides methods to:
 * 1. Retrieve available tools from an MCP client and convert them to Anthropic's format
 * 2. Execute tools with provided parameters and handle their responses
 */
extension MCPClient {
   
   /**
    * Retrieves available tools from the MCP client and converts them to Anthropic's tool format.
    *
    * - Returns: An array of Anthropic-compatible tools
    * - Throws: Errors from the underlying MCP client or during conversion process
    */
   func anthropicTools() async throws -> [SwiftAnthropic.MessageParameter.Tool] {
      let tools = await tools
      return try tools.value.get().map { $0.toAnthropicTool() }
   }
   
   /**
     * Executes a tool with the specified name and input parameters.
     *
     * - Parameters:
     *   - name: The identifier of the tool to call
     *   - input: Dictionary of parameters to pass to the tool
     *   - debug: Flag to enable verbose logging during execution
     * - Returns: A string containing the tool's response, or `nil` if execution failed
     */
   func anthropicCallTool(
      name: String,
      input: [String: Any],
      debug: Bool)
      async -> String? {
      do {
         if debug {
            print("🔧 Calling tool '\(name)'...")
         }
         
         // Convert DynamicContent values to basic types
         var serializableInput: [String: Any] = [:]
         for (key, value) in input {
            if let dynamicContent = value as? MessageResponse.Content.DynamicContent {
               serializableInput[key] = dynamicContent.extractValue()
            } else {
               serializableInput[key] = value
            }
         }
         
         let inputData = try JSONSerialization.data(withJSONObject: serializableInput)
         let inputJSON = try JSONDecoder().decode(JSON.self, from: inputData)
         
         let result = try await callTool(named: name, arguments: inputJSON)
         
         if result.isError != true {
            if let content = result.content.first?.text?.text {
               if debug {
                  print("✅ Tool execution successful")
               }
               return content
            } else {
               if debug {
                  print("⚠️ Tool returned no text content")
               }
               return nil
            }
         } else {
            print("❌ Tool returned an error")
            if let errorText = result.content.first?.text?.text {
               if debug {
                  print("   Error: \(errorText)")
               }
            }
            return nil
         }
      } catch {
         if debug {
            print("⛔️ Error calling tool: \(error)")
         }
         return nil
      }
   }
}

// MARK: OpenAI

/**
 * Extension that bridges the MCP (Multi-Client Protocol) framework with [SwiftOpenAI](https://github.com/jamesrochabrun/SwiftOpenAI) library.
 *
 * This Extension provides methods to:
 * 1. Retrieve available tools from an MCP client and convert them to Anthropic's format
 * 2. Execute tools with provided parameters and handle their responses
 */
extension MCPClient {
   
   func tools() async throws -> [SwiftOpenAI.ChatCompletionParameters.Tool] {
      let tools = await tools
      return try tools.value.get().map { $0.toOpenAITool() }
   }
   
   func callTool(
      name: String,
      input: [String: Any],
      debug: Bool)
      async -> String? {
   
      do {
         if debug {
            print("🔧 Calling tool '\(name)'...")
         }
         
         // Convert OpenAI function call parameters to serializable format
         var serializableInput: [String: Any] = [:]
         for (key, value) in input {
            // Handle any special OpenAI types that might need conversion
            // This will depend on what types OpenAI uses in their response
            serializableInput[key] = value
         }
         
         let inputData = try JSONSerialization.data(withJSONObject: serializableInput)
         let inputJSON = try JSONDecoder().decode(JSON.self, from: inputData)
         
         let result = try await callTool(named: name, arguments: inputJSON)
         
         if result.isError != true {
            if let content = result.content.first?.text?.text {
               if debug {
                  print("✅ Tool execution successful")
               }
               return content
            } else {
               if debug {
                  print("⚠️ Tool returned no text content")
               }
               return nil
            }
         } else {
            print("❌ Tool returned an error")
            if let errorText = result.content.first?.text?.text {
               if debug {
                  print("   Error: \(errorText)")
               }
            }
            return nil
         }
      } catch {
         if debug {
            print("⛔️ Error calling tool: \(error)")
         }
         return nil
      }
   }
}
