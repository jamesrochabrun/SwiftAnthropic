//
//  MessageDemoObservable.swift
//  SwiftAnthropicExample
//
//  Created by James Rochabrun on 2/24/24.
//

import Foundation
import SwiftAnthropic
import SwiftUI

@MainActor
@Observable class MessageDemoObservable {
   
   let service: AnthropicService
   var message: String = ""
   var errorMessage: String = ""
   var isLoading = false

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
            switch message.content.first {
            case .text(let text):
               self.message = text
            default:
               /// Function call not implemented on this demo
               break
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

