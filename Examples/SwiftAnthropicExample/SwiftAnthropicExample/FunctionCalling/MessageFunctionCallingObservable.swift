//
//  MessageFunctionCallingObservable.swift
//
//
//  Created by James Rochabrun on 4/4/24.
//

import Foundation
import SwiftAnthropic
import SwiftUI

@MainActor
@Observable class MessageFunctionCallingObservable {
   
   let service: AnthropicService
   var errorMessage = ""
   var isLoading = false
   var message = ""
   var thinking = ""
   
   var toolUse: MessageResponse.Content.ToolUse?
   
   // Stream tool use response
   var totalJson: String = ""
   
   init(service: AnthropicService) {
      self.service = service
   }
   
   func createMessage(
      parameters: MessageParameter) async throws
   {
      task = Task {
         do {
            isLoading = true
            let message = try await service.createMessage(parameters)
            isLoading = false
            for content in message.content {
               switch content {
               case .text(let text, _):
                  self.message = text
               case .toolUse(let toolUSe):
                  toolUse = toolUSe
               case .thinking(let thinking):
                  self.thinking = thinking.thinking
               }
            }
         } catch {
            self.errorMessage = "\(error)"
         }
      }
   }
   
   func streamMessage(
      parameters: MessageParameter) async throws
   {
      task = Task {
         do {
            isLoading = true
            let stream = try await service.streamMessage(parameters)
            isLoading = false
            for try await result in stream {

               let content = result.delta?.text ?? ""
               self.message += content
               
               /// PartialJson is the JSON provided by tool use. Clients need to accumulate it.
               /// https://docs.anthropic.com/en/api/messages-streaming#input-json-delta
               self.totalJson += result.delta?.partialJson ?? ""
               
               switch result.streamEvent {
               case .contentBlockStart:
                  // Tool use data is only available in `content_block_start` events.
                  /*
                   event: content_block_start
                   data: {"type":"content_block_start","index":1,"content_block":{"type":"tool_use","id":"toolu_01KXkhDdRhvV1pnk23GiWmjo","name":"get_weather","input":{}} }
                   */
                  self.toolUse = result.contentBlock?.toolUse
               default: break
               }
            }
         } catch {
            self.errorMessage = "\(error)"
         }
      }
   }
   
   func cancelStream() {
      task?.cancel()
   }
   
   func clearMessage() {
      message = ""
      toolUse = nil
      totalJson = ""
   }
   
   // MARK: Private
   
   private var task: Task<Void, Never>? = nil

}

extension MessageResponse.Content.ToolUse {
   
   var inputDisplay: String {
      var display = ""
      for key in input.keys {
         display += key
         display += ","
         switch input[key] {
         case .string(let text):
            display += text
         default: break
         }
      }
      return display
   }
}
