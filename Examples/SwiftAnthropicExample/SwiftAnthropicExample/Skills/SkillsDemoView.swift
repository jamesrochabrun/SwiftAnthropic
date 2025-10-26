//
//  SkillsDemoView.swift
//  SwiftAnthropicExample
//
//  Created by James Rochabrun on 10/25/25.
//

import SwiftUI
import SwiftAnthropic

struct SkillsDemoView: View {

   @State var observable: SkillsDemoObservable

   var body: some View {
      ScrollView {
         VStack(alignment: .leading, spacing: 20) {

            // Info Section
            GroupBox {
               VStack(alignment: .leading, spacing: 8) {
                  Text("Skills API Demo")
                     .font(.headline)
                  Text("Test the new Skills functionality including listing available skills and using them in messages.")
                     .font(.caption)
                     .foregroundStyle(.secondary)

                  if let containerId = observable.containerId {
                     Divider()
                     Text("Container ID: \(containerId)")
                        .font(.caption2)
                        .foregroundStyle(.blue)
                  }
               }
            }

            // Action Buttons
            VStack(spacing: 12) {
               Button(action: {
                  Task { await observable.listSkills() }
               }) {
                  Label("List Available Skills", systemImage: "list.bullet")
                     .frame(maxWidth: .infinity)
                     .padding()
                     .background(Color.blue)
                     .foregroundColor(.white)
                     .cornerRadius(10)
               }
               .disabled(observable.isLoading)

               Button(action: {
                  Task { await observable.createMessageWithSkill() }
               }) {
                  Label("Create Budget with XLSX Skill", systemImage: "doc.text")
                     .frame(maxWidth: .infinity)
                     .padding()
                     .background(Color.green)
                     .foregroundColor(.white)
                     .cornerRadius(10)
               }
               .disabled(observable.isLoading)

               Button(action: {
                  Task { await observable.streamMessageWithSkill() }
               }) {
                  Label("Stream Chart with XLSX Skill", systemImage: "chart.bar")
                     .frame(maxWidth: .infinity)
                     .padding()
                     .background(Color.purple)
                     .foregroundColor(.white)
                     .cornerRadius(10)
               }
               .disabled(observable.isLoading)
            }

            // Response Section
            if observable.isLoading {
               ProgressView()
                  .frame(maxWidth: .infinity)
                  .padding()
            }

            if !observable.errorMessage.isEmpty {
               GroupBox {
                  VStack(alignment: .leading) {
                     Label("Error", systemImage: "exclamationmark.triangle")
                        .font(.headline)
                        .foregroundColor(.red)
                     Text(observable.errorMessage)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                  }
               }
               .backgroundStyle(.red.opacity(0.1))
            }

            if !observable.message.isEmpty {
               GroupBox {
                  VStack(alignment: .leading, spacing: 8) {
                     Label("Response", systemImage: "text.bubble")
                        .font(.headline)

                     ScrollView {
                        Text(observable.message)
                           .font(.system(.body, design: .monospaced))
                           .textSelection(.enabled)
                           .frame(maxWidth: .infinity, alignment: .leading)
                     }
                     .frame(maxHeight: 400)
                  }
               }
            }

            // Skills List
            if !observable.availableSkills.isEmpty {
               GroupBox {
                  VStack(alignment: .leading, spacing: 12) {
                     Label("Available Skills", systemImage: "square.stack.3d.up")
                        .font(.headline)

                     ForEach(observable.availableSkills, id: \.id) { skill in
                        VStack(alignment: .leading, spacing: 4) {
                           Text(skill.displayTitle ?? "No title")
                              .font(.subheadline)
                              .fontWeight(.medium)
                           HStack {
                              Text("ID: \(skill.id)")
                                 .font(.caption2)
                              Spacer()
                              Text(skill.source.uppercased())
                                 .font(.caption2)
                                 .padding(.horizontal, 6)
                                 .padding(.vertical, 2)
                                 .background(skill.source == "anthropic" ? Color.blue.opacity(0.2) : Color.orange.opacity(0.2))
                                 .cornerRadius(4)
                           }
                           .foregroundStyle(.secondary)
                        }
                        .padding(.vertical, 4)

                        if skill.id != observable.availableSkills.last?.id {
                           Divider()
                        }
                     }
                  }
               }
            }

            Spacer()
         }
         .padding()
      }
      .navigationTitle("Skills Demo")
      .navigationBarTitleDisplayMode(.inline)
   }
}

#Preview {
   NavigationStack {
      SkillsDemoView(
         observable: .init(
            service: AnthropicServiceFactory.service(
               apiKey: "test-key",
               betaHeaders: ["skills-2025-10-02", "code-execution-2025-08-25"]
            )
         )
      )
   }
}
