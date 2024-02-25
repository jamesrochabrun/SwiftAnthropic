//
//  MessageDemoObservable.swift
//  SwiftAnthropicExample
//
//  Created by James Rochabrun on 2/24/24.
//

import Foundation
import SwiftAnthropic
import SwiftUI

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
            self.message = message.content.first?.text ?? ""
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
            for try await result in stream {
               let content = result.delta?.text ?? ""
               self.message += content
            }
            isLoading = false
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

