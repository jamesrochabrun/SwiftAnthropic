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
   var selectedPDF: Data? = nil
   var inputTokensCount: String?
   
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
            case .text(let text, let citations):
               // We need to concatenate the text response.
               self.message = text
               if let citations {
                  dump(citations)
               }
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
            var citationCitedText = ""
            isLoading = true
            let stream = try await service.streamMessage(parameters)
            isLoading = false
            for try await result in stream {
               let content = result.delta?.text ?? ""
               self.message += content
               switch result.delta?.citation {
               case .charLocation(let charLocation):
                  citationCitedText += charLocation.citedText ?? ""
               case .contentBlockLocation(let blockLocation):
                  citationCitedText += blockLocation.citedText ?? ""
               case .pageLocation(let pageLocation):
                  citationCitedText += pageLocation.citedText ?? ""
               default: break
               }
            }
            if !citationCitedText.isEmpty {
               debugPrint("Citation Text: \n \(citationCitedText)")
            }
         } catch {
            self.errorMessage = "\(error)"
         }
      }
   }
   
   func countTokens(parameters: MessageTokenCountParameter) async throws {
      let inputTokens = try await service.countTokens(parameter: parameters)
      inputTokensCount = "\(inputTokens.inputTokens)"
   }
   
   func analyzePDF(prompt: String, selectedSegment: MessageDemoView.ChatConfig) async throws {
      guard let pdfData = selectedPDF else {
         errorMessage = "No PDF selected"
         return
      }
      
      // Convert PDF to base64
      let base64PDF = pdfData.base64EncodedString()
      
      do {
         // Create document source with citations enabled
         let documentSource = try MessageParameter.Message.Content.DocumentSource.pdf(base64Data: base64PDF, citations: .init(enabled: true))
         
         // Create message with document and prompt
         let message = MessageParameter.Message(
            role: .user,
            content: .list([
               .document(documentSource),
               .text(prompt.isEmpty ? "Please analyze this document and provide a summary" : prompt)
            ])
         )
         
         // Create parameters
         let parameters = MessageParameter(
            model: .claude35Sonnet,
            messages: [message],
            maxTokens: 1024
         )
         
         // Send request based on selected mode
         switch selectedSegment {
         case .message:
            try await createMessage(parameters: parameters)
         case .messageStream:
            try await streamMessage(parameters: parameters)
         }
         
      } catch MessageParameter.Message.Content.DocumentSource.DocumentError.exceededSizeLimit {
         errorMessage = "PDF exceeds size limit (32MB)"
      } catch MessageParameter.Message.Content.DocumentSource.DocumentError.invalidBase64Data {
         errorMessage = "Invalid PDF data"
      } catch {
         errorMessage = "Error analyzing PDF: \(error.localizedDescription)"
      }
   }
   
   func cancelStream() {
      task?.cancel()
   }
   
   func clearMessage() {
      message = ""
      selectedPDF = nil
      errorMessage = ""
   }
   
   // MARK: Private
   private var task: Task<Void, Never>? = nil
   // Track the current active content block
   private var currentThinking = ""
   private var currentBlockType: String?
   private var currentBlockIndex: Int?
}
