//
//  ThinkingModeMessageDemoObservable.swift
//  SwiftAnthropic
//
//  Created by James Rochabrun on 2/24/25.
//

import Foundation
import SwiftAnthropic
import SwiftUI

@MainActor
@Observable class ThinkingModeMessageDemoObservable {
   
   let service: AnthropicService
   var message: String = ""
   var thinkingContentMessage = ""
   var errorMessage: String = ""
   var isLoading = false
   var inputTokensCount: String?
   
   // State for managing conversation
   private var messages: [MessageParameter.Message] = []
   
   // Handler for processing thinking content
   private var streamHandler = StreamHandler()
   
   init(service: AnthropicService) {
      self.service = service
   }
   
   // Send a message to Claude with thinking enabled
   func sendMessage(prompt: String, budgetTokens: Int = 16000) async throws {
      guard !prompt.isEmpty else {
         errorMessage = "Please enter a prompt"
         return
      }
      
      // Reset state for new response
      message = ""
      thinkingContentMessage = ""
      errorMessage = ""
      streamHandler.reset() // Clear previous stream data
      
      // Add user message to conversation
      let userMessage = MessageParameter.Message(
         role: .user,
         content: .text(prompt)
      )
      messages.append(userMessage)
      
      // Create parameters with thinking enabled
      let parameters = MessageParameter(
         model: .claude37Sonnet,
         messages: messages,
         maxTokens: 20000,
         stream: true,
         thinking: .init(budgetTokens: budgetTokens)
      )
      
      // Count tokens (optional)
      let tokenCountParams = MessageTokenCountParameter(
         model: .claude37Sonnet,
         messages: messages
      )
      
      do {
         // Get token count
         let tokenCount = try await service.countTokens(parameter: tokenCountParams)
         inputTokensCount = "\(tokenCount.inputTokens)"
         
         // Stream the response
         isLoading = true
         let stream = try await service.streamMessage(parameters)
         
         // Process stream events
         for try await result in stream {
            // Use the ThinkingStreamHandler to process events
            streamHandler.handleStreamEvent(result)
            
            // Update UI elements based on event type
            updateUIFromStreamEvent(result)
         }
         
         // Once streaming is complete, store assistant's response in conversation history
         let finalMessage = streamHandler.textResponse
         if !finalMessage.isEmpty {
            // Get thinking blocks from the handler
            let thinkingBlocks = streamHandler.getThinkingBlocksForAPI()
            
            // Create content objects: thinking blocks + text
            var contentObjects = thinkingBlocks
            contentObjects.append(.text(finalMessage))
            
            // Create assistant message with both thinking blocks and text
            let assistantMessage = MessageParameter.Message(
               role: .assistant,
               content: .list(contentObjects)
            )
            
            // Add to conversation history
            messages.append(assistantMessage)
            message = finalMessage // Update UI
         }
         
         isLoading = false
      } catch {
         isLoading = false
         errorMessage = "Error: \(error.localizedDescription)"
      }
   }
   
   // Just update UI elements based on stream events, no need to track state
   private func updateUIFromStreamEvent(_ event: MessageStreamResponse) {
      // Update UI elements based on deltas
      if let delta = event.delta {
         switch delta.type {
         case "thinking_delta":
            if let thinking = delta.thinking {
               // Update the thinking content shown in UI
               thinkingContentMessage += thinking
            }
         case "text_delta":
            if let text = delta.text {
               // Update the message shown in UI
               message += text
            }
         default:
            break
         }
      }
   }
   
   func clearConversation() {
      message = ""
      thinkingContentMessage = ""
      errorMessage = ""
      messages.removeAll()
      inputTokensCount = nil
      streamHandler.reset()
   }
}
