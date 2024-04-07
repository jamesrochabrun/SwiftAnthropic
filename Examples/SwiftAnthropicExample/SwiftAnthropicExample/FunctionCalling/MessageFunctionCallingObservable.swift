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
   var message: String = ""
   var errorMessage: String = ""
   var isLoading = false
   var toolResponse: ToolResponse?
   
   struct ToolResponse {
      let id: String
      let name: String
      let input: [String: String]
      
      var inputDisplay: String {
         var display = ""
         for key in input.keys {
            display += key
            display += ","
            display += input[key] ?? ""
         }
         return display
      }
   }
   
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
               case .text(let text):
                  self.message = text
               case .toolUse(let id, let name, let input):
                  toolResponse = .init(id: id, name: name, input: input)
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
   }
   
   // MARK: Private
   
   private var task: Task<Void, Never>? = nil

}

