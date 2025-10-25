//
//  SkillsDemoObservable.swift
//  SwiftAnthropicExample
//
//  Created by James Rochabrun on 10/25/25.
//

import SwiftUI
import SwiftAnthropic

@MainActor
@Observable class SkillsDemoObservable {

   let service: AnthropicService

   var message: String = ""
   var errorMessage: String = ""
   var isLoading = false
   var availableSkills: [SkillResponse] = []
   var containerId: String?

   init(service: AnthropicService) {
      self.service = service
   }

   /// Lists available skills
   func listSkills() async {
      isLoading = true
      errorMessage = ""

      do {
         let response = try await service.listSkills(parameter: nil)
         availableSkills = response.data
         message = "Found \(response.data.count) skill(s)\n\n"
         for skill in response.data {
            message += "📦 \(skill.displayTitle ?? "No title")\n"
            message += "   ID: \(skill.id)\n"
            message += "   Source: \(skill.source)\n"
            message += "   Version: \(skill.latestVersion ?? "none")\n\n"
         }
      } catch {
         errorMessage = error.localizedDescription
      }

      isLoading = false
   }

   /// Sends a message using a skill (e.g., XLSX skill)
   func createMessageWithSkill() async {
      isLoading = true
      errorMessage = ""
      message = ""

      do {
         // Example: Use the xlsx skill to create a spreadsheet
         let parameter = MessageParameter(
            model: .claude37Sonnet,
            messages: [
               .init(
                  role: .user,
                  content: .text("Create a simple budget spreadsheet with categories: Housing, Food, Transportation, and Entertainment. Add sample monthly amounts.")
               )
            ],
            maxTokens: 4096,
            tools: [
               .hosted(type: "code_execution_20250825", name: "code_execution")
            ],
            container: .init(
               id: containerId, // Reuse container if available
               skills: [
                  .init(type: .anthropic, skillId: "xlsx", version: "latest")
               ]
            )
         )

         let response = try await service.createMessage(parameter)

         // Save container ID for reuse
         if let newContainerId = response.container?.id {
            containerId = newContainerId
            message += "📦 Container ID: \(newContainerId)\n\n"
         }

         // Display response
         for content in response.content {
            switch content {
            case .text(let text, _):
               message += text + "\n"
            case .toolUse(let toolUse):
               message += "\n🔧 Tool: \(toolUse.name)\n"
               message += "Input: \(toolUse.input)\n"
            default:
               message += "Other content type\n"
            }
         }

         if let stopReason = response.stopReason {
            message += "\n⏹️ Stop reason: \(stopReason)"
         }

      } catch {
         errorMessage = error.localizedDescription
      }

      isLoading = false
   }

   /// Streams a message using a skill
   func streamMessageWithSkill() async {
      isLoading = true
      errorMessage = ""
      message = ""

      do {
         let parameter = MessageParameter(
            model: .claude37Sonnet,
            messages: [
               .init(
                  role: .user,
                  content: .text("Analyze this data and create a chart: Q1: $10k, Q2: $15k, Q3: $12k, Q4: $18k")
               )
            ],
            maxTokens: 4096,
            stream: true,
            tools: [
               .hosted(type: "code_execution_20250825", name: "code_execution")
            ],
            container: .init(
               id: containerId,
               skills: [
                  .init(type: .anthropic, skillId: "xlsx", version: "latest")
               ]
            )
         )

         let stream = try await service.streamMessage(parameter)

         for try await chunk in stream {
            if let delta = chunk.delta {
               if let text = delta.text {
                  message += text
               }
            }

            if let newContainerId = chunk.message?.container?.id {
               containerId = newContainerId
            }
         }

      } catch {
         errorMessage = error.localizedDescription
      }

      isLoading = false
   }
}
