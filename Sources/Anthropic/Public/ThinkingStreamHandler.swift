//
//  ThinkingStreamHandler.swift
//  SwiftAnthropic
//
//  Created by James Rochabrun on 2/24/25.
//

import Foundation

public final class ThinkingStreamHandler {
   
   public init() {}
   
   // Process a stream event
   public func handleStreamEvent(_ event: MessageStreamResponse) {
      // First identify event type
      switch event.streamEvent {
      case .contentBlockStart:
         handleContentBlockStart(event)
      case .contentBlockDelta:
         handleContentBlockDelta(event)
      case .contentBlockStop:
         handleContentBlockStop()
      case .messageStart:
         // Just initialize as needed
         debugPrint("Stream started")
      case .messageDelta, .messageStop:
         // Handle message completion
         if event.streamEvent == .messageStop {
            debugPrint("\nStream complete!")
            printSummary()
         }
      case .none:
         debugPrint("Unknown event type: \(event.type)")
      }
   }
   
   // Get all content blocks for use in subsequent API calls
   public func getContentBlocksForAPI() -> [MessageParameter.Message.Content.ContentObject] {
      var blocks: [MessageParameter.Message.Content.ContentObject] = []
      
      // Add regular thinking blocks
      for block in thinkingBlocks {
         if let signature = block.signature {
            blocks.append(.thinking(block.thinking, signature))
         }
      }
      
      // Add redacted thinking blocks if any
      for data in redactedThinkingBlocks {
         blocks.append(.redactedThinking(data))
      }
      
      // Add tool use blocks if any
      for toolUse in toolUseBlocks {
         blocks.append(.toolUse(toolUse.id, toolUse.name, toolUse.input))
      }
      
      return blocks
   }
   
   // Get only thinking blocks for use in subsequent API calls
   public func getThinkingBlocksForAPI() -> [MessageParameter.Message.Content.ContentObject] {
      var blocks: [MessageParameter.Message.Content.ContentObject] = []
      
      // Add regular thinking blocks
      for block in thinkingBlocks {
         if let signature = block.signature {
            blocks.append(.thinking(block.thinking, signature))
         }
      }
      
      // Add redacted thinking blocks if any
      for data in redactedThinkingBlocks {
         blocks.append(.redactedThinking(data))
      }
      
      return blocks
   }
   
   // Get text response content
   public var textResponse: String {
      return currentResponse
   }
   
   // Get tool use blocks
   public func getToolUseBlocks() -> [ToolUseBlock] {
      return toolUseBlocks
   }
   
   // Current thinking content being collected
   private var currentThinking = ""
   // Current signature being collected
   private var signature: String?
   // Current text response being collected
   private var currentResponse = ""
   // Current tool use block being collected
   private var currentToolUse: ToolUseBlock?
   
   // Track the current active content block index and type
   private var currentBlockIndex: Int? = nil
   private var currentBlockType: String? = nil
   
   // Store all collected thinking blocks
   private var thinkingBlocks: [(thinking: String, signature: String?)] = []
   // Stored redacted thinking blocks
   private var redactedThinkingBlocks: [String] = []
   // Stored tool use blocks
   private var toolUseBlocks: [ToolUseBlock] = []
   
   // Structure to store tool use information
   public struct ToolUseBlock {
      public let id: String
      public let name: String
      public let input: MessageResponse.Content.Input
   }
   
   private func handleContentBlockStart(_ event: MessageStreamResponse) {
      guard let contentBlock = event.contentBlock, let index = event.index else { return }
      
      currentBlockIndex = index
      currentBlockType = contentBlock.type
      
      switch contentBlock.type {
      case "thinking":
         currentThinking = contentBlock.thinking ?? ""
         debugPrint("\nStarting thinking block...")
      case "redacted_thinking":
         if let data = contentBlock.data {
            redactedThinkingBlocks.append(data)
            debugPrint("\nEncountered redacted thinking block")
         }
      case "text":
         currentResponse = contentBlock.text ?? ""
         debugPrint("\nStarting text response...")
      case "tool_use":
         if let id = contentBlock.id, let name = contentBlock.name {
            currentToolUse = ToolUseBlock(id: id, name: name, input: contentBlock.input ?? [:])
            debugPrint("\nStarting tool use block: \(name)")
         }
      default:
         debugPrint("\nStarting \(contentBlock.type) block...")
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
            debugPrint(thinking, terminator: "")
         }
      case "signature_delta":
         if let sig = delta.signature {
            signature = sig
            debugPrint("\nReceived signature for thinking block")
         }
      case "text_delta":
         if let text = delta.text {
            currentResponse += text
            debugPrint(text, terminator: "")
         }
      case "tool_use":
         if let partialJson = delta.partialJson {
            debugPrint("\nReceived partial tool use JSON: \(partialJson)")
            // In a real implementation, you might need to handle partial JSON updates
         }
      default:
         if let type = delta.type {
            debugPrint("\nUnknown delta type: \(type)")
         }
      }
   }
   
   private func handleContentBlockStop() {
      // When a block is complete, store it if needed
      if currentBlockType == "thinking" && !currentThinking.isEmpty {
         thinkingBlocks.append((thinking: currentThinking, signature: signature))
         
         // Reset for next block
         currentThinking = ""
         signature = nil
      } else if currentBlockType == "tool_use" && currentToolUse != nil {
         if let toolUse = currentToolUse {
            toolUseBlocks.append(toolUse)
         }
         currentToolUse = nil
      }
      
      // Reset tracking
      currentBlockType = nil
   }
   
   // Reset all stored data
   public func reset() {
      currentThinking = ""
      signature = nil
      currentResponse = ""
      currentToolUse = nil
      currentBlockIndex = nil
      currentBlockType = nil
      thinkingBlocks.removeAll()
      redactedThinkingBlocks.removeAll()
      toolUseBlocks.removeAll()
   }
   
   // Print a summary of what was collected
   private func printSummary() {
      debugPrint("\n\n===== SUMMARY =====")
      debugPrint("Number of thinking blocks: \(thinkingBlocks.count)")
      debugPrint("Number of redacted thinking blocks: \(redactedThinkingBlocks.count)")
      debugPrint("Number of tool use blocks: \(toolUseBlocks.count)")
      debugPrint("Final response length: \(currentResponse.count) characters")
   }
}
