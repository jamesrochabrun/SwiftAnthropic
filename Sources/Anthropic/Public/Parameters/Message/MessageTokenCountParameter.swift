//
//  MessageTokenCountParameter.swift
//  SwiftAnthropic
//
//  Created by James Rochabrun on 1/3/25.
//

import Foundation

public struct MessageTokenCountParameter: Encodable {
   
   /// The model that will complete your prompt.
   /// See [models](https://docs.anthropic.com/claude/reference/selecting-a-model) for additional details and options.
   public let model: String
   
   /// Input messages.
   /// Our models are trained to operate on alternating user and assistant conversational turns.
   /// Each input message must be an object with a role and content.
   public let messages: [MessageParameter.Message]
   
   /// System prompt.
   /// A system prompt is a way of providing context and instructions to Claude.
   /// System role can be either a simple String or an array of objects, use the objects array for prompt caching.
   public let system: MessageParameter.System?
   
   /// Tools that can be used in the messages
   public let tools: [MessageParameter.Tool]?
   
   public init(
      model: Model,
      messages: [MessageParameter.Message],
      system: MessageParameter.System? = nil,
      tools: [MessageParameter.Tool]? = nil)
   {
      self.model = model.value
      self.messages = messages
      self.system = system
      self.tools = tools
   }
}
