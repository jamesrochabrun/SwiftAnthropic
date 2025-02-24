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
   private var collectedThinkingBlocks: [MessageParameter.Message.Content.ContentObject] = []
   
   // Track the current active content block
   private var currentThinking = ""
   private var currentBlockType: String?
   private var currentBlockIndex: Int?
   private var signature: String?
   
   private var thinkingStreamHandler = ThinkingStreamHandler()
   
   init(service: AnthropicService) {
      self.service = service
   }
   
   // Send a message to Claude with thinking enabled
   func sendMessage(prompt: String, budgetTokens: Int = 16000) async throws {
      guard !prompt.isEmpty else {
         errorMessage = "Please enter a prompt"
         return
      }
      
      // Add user message to conversation
      let userMessage = MessageParameter.Message(
         role: .user,
         content: .text(prompt)
      )
      messages.append(userMessage)
      
      // Clear current state for new response
      message = ""
      thinkingContentMessage = ""
      errorMessage = ""
      
      // Create parameters with thinking enabled
      let parameters = MessageParameter(
         model: .claude37Sonnet,
         messages: collectedThinkingBlocksAsMessages() + messages,
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
            thinkingStreamHandler.handleStreamEvent(result)
            processStreamEvent(result)
         }
         
         // Once streaming is complete, store assistant's response in conversation history
         if !message.isEmpty {
            let assistantMessage = MessageParameter.Message(
               role: .assistant,
               content: .text(message)
            )
            messages.append(assistantMessage)
            
            // Store thinking blocks for next turn
            collectedThinkingBlocks = thinkingStreamHandler.getThinkingBlocksForAPI()
         }
         
         isLoading = false
      } catch {
         isLoading = false
         errorMessage = "Error: \(error.localizedDescription)"
      }
   }
   
   // Helper to convert stored thinking blocks to messages array
   private func collectedThinkingBlocksAsMessages() -> [MessageParameter.Message] {
      if collectedThinkingBlocks.isEmpty {
         return []
      }
      
      // Create an assistant message with the collected thinking blocks
      return [
         MessageParameter.Message(
            role: .assistant,
            content: .list(collectedThinkingBlocks)
         )
      ]
   }
   
   // Process stream events
   private func processStreamEvent(_ event: MessageStreamResponse) {
      switch event.streamEvent {
      case .contentBlockStart:
         handleContentBlockStart(event)
      case .contentBlockDelta:
         handleContentBlockDelta(event)
      case .contentBlockStop:
         handleContentBlockStop()
      default:
         break
      }
   }
   
   private func handleContentBlockStart(_ event: MessageStreamResponse) {
      guard let contentBlock = event.contentBlock, let index = event.index else { return }
      
      currentBlockIndex = index
      currentBlockType = contentBlock.type
      
      // Initialize based on block type
      if contentBlock.type == "thinking" {
         currentThinking = contentBlock.thinking ?? ""
      } else if contentBlock.type == "redacted_thinking" {
         // Handle redacted thinking (encrypted content)
         print("Encountered redacted thinking block")
      }
   }
   
   private func handleContentBlockDelta(_ event: MessageStreamResponse) {
      guard let delta = event.delta, let index = event.index else { return }
      
      // Ensure we're tracking the correct block
      if currentBlockIndex != index {
         currentBlockIndex = index
      }
      
      // Process based on delta type
      switch delta.type {
      case "thinking_delta":
         if let thinking = delta.thinking {
            currentThinking += thinking
            
            // Update the thinking content message for display
            thinkingContentMessage = currentThinking
         }
      case "signature_delta":
         if let sig = delta.signature {
            signature = sig
         }
      case "text_delta":
         if let text = delta.text {
            message += text
         }
      default:
         break
      }
   }
   
   private func handleContentBlockStop() {
      currentBlockType = nil
   }
   
   func clearConversation() {
      message = ""
      thinkingContentMessage = ""
      errorMessage = ""
      messages.removeAll()
      collectedThinkingBlocks.removeAll()
      inputTokensCount = nil
   }
}
