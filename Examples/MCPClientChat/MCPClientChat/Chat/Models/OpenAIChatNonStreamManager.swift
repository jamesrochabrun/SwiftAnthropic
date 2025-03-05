//
//  OpenAIChatNonStreamModel.swift
//  MCPClientChat
//
//  Created by James Rochabrun on 3/3/25.
//

import Foundation
import MCPInterface
import MCPClient
import SwiftUI
import SwiftOpenAI

@MainActor
@Observable
// Handle a chat conversation without stream for OpenAI.
final class OpenAIChatNonStreamManager: ChatManager {
   
   /// Messages sent from the user or received from OpenAI
   var messages = [ChatMessage]()
   
   /// Service to communicate with OpenAI API
   private let service: OpenAIService
   
   /// Message history for OpenAI's context
   private var openAIMessages: [SwiftOpenAI.ChatCompletionParameters.Message] = []
   
   /// Current task handling OpenAI API request
   private var task: Task<Void, Never>? = nil
   
   /// Error message if something goes wrong
   var errorMessage: String = ""
   
   /// Loading state indicator
   var isLoading = false
   
   private var mcpClient: MCPClient?
   
   init(service: OpenAIService) {
      self.service = service
   }
   
   /// Returns true if OpenAI is still processing a response
   var isProcessing: Bool {
      return isLoading
   }
   
   func updateClient(_ client: MCPClient) {
      mcpClient = client
   }
   
   /// Send a new message to OpenAI and get the complete response
   func send(message: ChatMessage) {
      self.messages.append(message)
      self.processUserMessage(prompt: message.text)
   }
   
   /// Cancel the current processing task
   func stop() {
      self.task?.cancel()
      self.task = nil
      self.isLoading = false
   }
   
   private func processUserMessage(prompt: String) {
      // Add a placeholder for OpenAI's response
      self.messages.append(ChatMessage(text: "", role: .assistant, isWaitingForFirstText: true))
      
      // Add user message to history
      openAIMessages.append(SwiftOpenAI.ChatCompletionParameters.Message(
         role: .user,
         content: .text(prompt)
      ))
      
      task = Task {
         do {
            isLoading = true
            
            guard let mcpClient else {
               throw NSError(domain: "OpenAIChat", code: 1, userInfo: [NSLocalizedDescriptionKey: "mcpClient is nil"])
            }
            // Get available tools from MCP
            let tools = try await mcpClient.tools()
            
            // Send request and process response
            try await continueConversation(tools: tools)
            
            isLoading = false
         } catch {
            errorMessage = "\(error)"
            
            // Update UI to show error
            if var last = messages.popLast() {
               last.isWaitingForFirstText = false
               last.text = "Sorry, there was an error: \(error.localizedDescription)"
               messages.append(last)
            }
            
            isLoading = false
         }
      }
   }
   
   private func continueConversation(tools: [SwiftOpenAI.ChatCompletionParameters.Tool]) async throws {
      guard let mcpClient else {
         throw NSError(domain: "OpenAIChat", code: 1, userInfo: [NSLocalizedDescriptionKey: "mcpClient is nil"])
      }
      
      let parameters = SwiftOpenAI.ChatCompletionParameters(
         messages: openAIMessages,
         model: .gpt4o,
         toolChoice: .auto,
         tools: tools
      )
      
      // Make non-streaming request to OpenAI
      let response = try await service.startChat(parameters: parameters)
      
      guard let choices = response.choices,
            let firstChoice = choices.first,
            let message = firstChoice.message else {
         throw NSError(domain: "OpenAIChat", code: 1, userInfo: [NSLocalizedDescriptionKey: "No message in response"])
      }
      
      // Process the regular text content
      if let messageContent = message.content, !messageContent.isEmpty {
         // Update the UI with the response
         if var last = messages.popLast() {
            last.isWaitingForFirstText = false
            last.text = messageContent
            messages.append(last)
         }
         
         // Add assistant response to history
         openAIMessages.append(SwiftOpenAI.ChatCompletionParameters.Message(
            role: .assistant,
            content: .text(messageContent)
         ))
      }
      
      // Process tool calls if any
      if let toolCalls = message.toolCalls, !toolCalls.isEmpty {
         for toolCall in toolCalls {
            
            let function = toolCall.function
            guard let id = toolCall.id,
                  let name = function.name,
                  let argumentsData = function.arguments.data(using: .utf8) else {
               continue
            }
            
            let toolId = id
            let toolName = name
            let argumentsString = function.arguments
            
            // Parse arguments from string to dictionary
            let arguments: [String: Any]
            do {
               guard let parsedArgs = try JSONSerialization.jsonObject(with: argumentsData) as? [String: Any] else {
                  continue
               }
               arguments = parsedArgs
            } catch {
               print("Error parsing tool arguments: \(error)")
               continue
            }
            
            print("Tool use detected - Name: \(toolName), ID: \(toolId)")
            
            // Update UI to show tool use
            if var last = messages.popLast() {
               last.isWaitingForFirstText = false
               last.text += "\n Using tool: \(toolName)..."
               messages.append(last)
            }
            
            // Add the assistant message with tool call to message history
            let toolCallObject = SwiftOpenAI.ToolCall(
               id: toolId,
               function: SwiftOpenAI.FunctionCall(
                  arguments: argumentsString,
                  name: toolName
               )
            )
            
            openAIMessages.append(SwiftOpenAI.ChatCompletionParameters.Message(
               role: .assistant,
               content: .text(""), // Content is null when using tool calls
               toolCalls: [toolCallObject]
            ))
            
            // Call tool via MCP
            let toolResponse = await mcpClient.callTool(name: toolName, input: arguments, debug: true)
            print("Tool response: \(String(describing: toolResponse))")
            
            // Add tool result to conversation
            if let toolResult = toolResponse {
               // Add the tool result as a tool message
               openAIMessages.append(SwiftOpenAI.ChatCompletionParameters.Message(
                  role: .tool,
                  content: .text(toolResult),
                  toolCallID: toolId
               ))
               
               // Now get a new response with the tool result
               try await continueConversation(tools: tools)
            } else {
               // Handle tool failure
               if var last = messages.popLast() {
                  last.isWaitingForFirstText = false
                  last.text = "There was an error using the tool \(toolName)."
                  messages.append(last)
               }
               
               // Add error response as tool message
               openAIMessages.append(SwiftOpenAI.ChatCompletionParameters.Message(
                  role: .tool,
                  content: .text("Error: Tool execution failed"),
                  toolCallID: toolId
               ))
            }
         }
      }
   }
   
   /// Clear the conversation
   func clearConversation() {
      messages.removeAll()
      openAIMessages.removeAll()
      errorMessage = ""
      isLoading = false
      task?.cancel()
      task = nil
   }
}
