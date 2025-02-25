//
//  StreamHandler.swift
//  SwiftAnthropic
//
//  Created by James Rochabrun on 2/24/25.
//

import Foundation

public final class StreamHandler {
   
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
   
   // Get accumulated JSON for a specific tool use ID
   public func getAccumulatedJson(forToolUseId id: String) -> String? {
      return toolUseJsonMap[id]
   }
   
   // Current thinking content being collected
   private var currentThinking = ""
   // Current signature being collected
   private var signature: String?
   // Current text response being collected
   private var currentResponse = ""
   // Current tool use block being collected
   private var currentToolUse: ToolUseBlock?
   // Accumulated JSON for the current tool use
   private var currentToolUseJson = ""
   
   // Track the current active content block index and type
   private var currentBlockIndex: Int? = nil
   private var currentBlockType: String? = nil
   
   // Store all collected thinking blocks
   private var thinkingBlocks: [(thinking: String, signature: String?)] = []
   // Stored redacted thinking blocks
   private var redactedThinkingBlocks: [String] = []
   // Stored tool use blocks
   private var toolUseBlocks: [ToolUseBlock] = []
   // Map of tool use IDs to their accumulated JSON
   private var toolUseJsonMap: [String: String] = [:]
   
   // Structure to store tool use information
   public struct ToolUseBlock {
      public let id: String
      public let name: String
      public let input: MessageResponse.Content.Input
      
      // Added for convenience
      public var accumulatedJson: String?
      
      public init(id: String, name: String, input: MessageResponse.Content.Input, accumulatedJson: String? = nil) {
         self.id = id
         self.name = name
         self.input = input
         self.accumulatedJson = accumulatedJson
      }
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
            // Initialize the JSON accumulator for this tool use
            currentToolUseJson = ""
            // Create the tool use block with initial input (may be empty)
            currentToolUse = ToolUseBlock(id: id, name: name, input: contentBlock.input ?? [:])
            debugPrint("\nStarting tool use block: \(name) with ID: \(id)")
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
      case "tool_use_delta":
         if let partialJson = delta.partialJson, let currentId = currentToolUse?.id {
            // Accumulate the JSON
            currentToolUseJson += partialJson
            // Update the map
            toolUseJsonMap[currentId] = currentToolUseJson
            debugPrint("\nAccumulated tool use JSON for \(currentId): \(partialJson)")
            
            // Try to parse the accumulated JSON if it might be complete
            if isValidJson(currentToolUseJson) {
               debugPrint("\nValid JSON detected for tool use \(currentId)")
               // Here you could attempt to update the tool use input if needed
               updateToolUseInputIfPossible(toolUseId: currentId, json: currentToolUseJson)
            }
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
         if let toolUse = currentToolUse, let id = currentToolUse?.id {
            // Create a new ToolUseBlock with the accumulated JSON
            let updatedToolUse = ToolUseBlock(
               id: toolUse.id,
               name: toolUse.name,
               input: toolUse.input,
               accumulatedJson: toolUseJsonMap[id]
            )
            
            toolUseBlocks.append(updatedToolUse)
            debugPrint("\nStored tool use block with ID: \(id) and accumulated JSON")
         }
         currentToolUse = nil
         currentToolUseJson = ""
      }
      
      // Reset tracking
      currentBlockType = nil
   }
   
   // Check if a string is valid JSON
   private func isValidJson(_ jsonString: String) -> Bool {
      guard !jsonString.isEmpty else { return false }
      return (try? JSONSerialization.jsonObject(with: Data(jsonString.utf8))) != nil
   }
   
   // Try to update the tool use input from accumulated JSON
   private func updateToolUseInputIfPossible(toolUseId: String, json: String) {
      // This would be implemented based on your specific needs
      // For example, you might decode the JSON and update the corresponding input
      // This is just a placeholder for where you would implement that logic
      debugPrint("\nWould update tool use input for \(toolUseId) based on JSON if implemented")
   }
   
   // Reset all stored data
   public func reset() {
      currentThinking = ""
      signature = nil
      currentResponse = ""
      currentToolUse = nil
      currentToolUseJson = ""
      currentBlockIndex = nil
      currentBlockType = nil
      thinkingBlocks.removeAll()
      redactedThinkingBlocks.removeAll()
      toolUseBlocks.removeAll()
      toolUseJsonMap.removeAll()
   }
   
   // Print a summary of what was collected
   private func printSummary() {
      debugPrint("\n\n===== SUMMARY =====")
      debugPrint("Number of thinking blocks: \(thinkingBlocks.count)")
      debugPrint("Number of redacted thinking blocks: \(redactedThinkingBlocks.count)")
      debugPrint("Number of tool use blocks: \(toolUseBlocks.count)")
      debugPrint("Number of tool use JSON objects: \(toolUseJsonMap.count)")
      debugPrint("Final response length: \(currentResponse.count) characters")
   }
}
