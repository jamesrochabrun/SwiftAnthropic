//
//  MessageParameter.swift
//
//
//  Created by James Rochabrun on 1/28/24.
//

import Foundation

/*
 Create a Message.
 Send a structured list of input messages, and the model will generate the next message in the conversation.
 Messages can be used for either single queries to the model or for multi-turn conversations.
 The Messages API is currently in beta. During beta, you must send the anthropic-beta: messages-2023-12-15 header in your requests. If you are using our client SDKs, this is handled for you automatically.
 */


/// [Create a message.](https://docs.anthropic.com/claude/reference/messages_post)
///  POST -  https://api.anthropic.com/v1/messages
public struct MessageParameter: Encodable {
   
   /// The model that will complete your prompt.
   // As we improve Claude, we develop new versions of it that you can query. The model parameter controls which version of Claude responds to your request. Right now we offer two model families: Claude, and Claude Instant. You can use them by setting model to "claude-2.1" or "claude-instant-1.2", respectively.
   /// See [models](https://docs.anthropic.com/claude/reference/selecting-a-model) for additional details and options.
   let model: String
   
   /// Input messages.
   /// Our models are trained to operate on alternating user and assistant conversational turns. When creating a new Message, you specify the prior conversational turns with the messages parameter, and the model then generates the next Message in the conversation.
   /// Each input message must be an object with a role and content. You can specify a single user-role message, or you can include multiple user and assistant messages. The first message must always use the user role.
   /// If the final message uses the assistant role, the response content will continue immediately from the content in that message. This can be used to constrain part of the model's response.
   let messages: [Message]
   
   /// The maximum number of tokens to generate before stopping.
   /// Note that our models may stop before reaching this maximum. This parameter only specifies the absolute maximum number of tokens to generate.
   /// Different models have different maximum values for this parameter. See [input and output](https://docs.anthropic.com/claude/reference/input-and-output-sizes) sizes for details.
   let maxTokens: Int
   
   /// System prompt.
   /// A system prompt is a way of providing context and instructions to Claude, such as specifying a particular goal or role. See our [guide to system prompts](https://docs.anthropic.com/claude/docs/how-to-use-system-prompts).
   let system: String?
   
   /// An object describing metadata about the request.
   let metadata: MetaData?
   
   /// Custom text sequences that will cause the model to stop generating.
   /// Our models will normally stop when they have naturally completed their turn, which will result in a response stop_reason of "end_turn".
   /// If you want the model to stop generating when it encounters custom strings of text, you can use the stop_sequences parameter. If the model encounters one of the custom sequences, the response stop_reason value will be "stop_sequence" and the response stop_sequence value will contain the matched stop sequence.
   let stopSequences: [String]?
   
   /// Whether to incrementally stream the response using server-sent events.
   /// See [streaming](https://docs.anthropic.com/claude/reference/messages-streaming for details.
   var stream: Bool
   
   /// Amount of randomness injected into the response.
   /// Defaults to 1. Ranges from 0 to 1. Use temp closer to 0 for analytical / multiple choice, and closer to 1 for creative and generative tasks.
   let temperature: Double?
   
   /// Only sample from the top K options for each subsequent token.
   /// Used to remove "long tail" low probability responses. [Learn more technical details here](https://towardsdatascience.com/how-to-sample-from-language-models-682bceb97277).
   let topK: Int?
   
   /// Use nucleus sampling.
   /// In nucleus sampling, we compute the cumulative distribution over all the options for each subsequent token in decreasing probability order and cut it off once it reaches a particular probability specified by top_p. You should either alter temperature or top_p, but not both.
   let topP: Double?
   
   public struct Message: Encodable {
      
      let role: String
      let content: Content
      
      public enum Role: String {
         case user
         case assistant
      }
      
      public enum Content: Codable {
         
         case single(String)
         case multiple([ContentBlock])
         
         public init(from decoder: Decoder) throws {
            if let singleString = try? decoder.singleValueContainer().decode(String.self) {
               self = .single(singleString)
            } else {
               self = .multiple(try [ContentBlock](from: decoder))
            }
         }
         
         public func encode(to encoder: Encoder) throws {
            switch self {
            case .single(let string):
               var container = encoder.singleValueContainer()
               try container.encode(string)
            case .multiple(let blocks):
               try blocks.encode(to: encoder)
            }
         }
         
         public struct ContentBlock: Codable {
            let type: ContentType
            let text: String?
            let source: ImageSource?
            
            enum ContentType: String, Codable {
               case text
               case image
            }
            
            public struct ImageSource: Codable {
               
               let type: String
               let mediaType: String?
               let data: String?
               
               public enum SourceType: String, Encodable {
                  case text
                  case image
               }
               
               public enum MediaType: String, Encodable {
                  case jpeg
                  case png
                  case gif
                  case webp
                  
                  var value: String {
                     "image/\(self)"
                  }
               }
               
               public init(
                  type: SourceType,
                  mediaType: MediaType?,
                  data: String?)
               {
                  self.type = type.rawValue
                  self.mediaType = mediaType?.value
                  self.data = data
               }
            }
         }
      }
      
      public init(
         role: Role,
         content: Content)
      {
         self.role = role.rawValue
         self.content = content
      }
   }
   
   public struct MetaData: Encodable {
      // An external identifier for the user who is associated with the request.
      // This should be a uuid, hash value, or other opaque identifier. Anthropic may use this id to help detect abuse. Do not include any identifying information such as name, email address, or phone number.
      let userId: UUID
   }
   
   public init(
      model: Model,
      messages: [Message],
      maxTokens: Int,
      system: String? = nil,
      metadata: MetaData? = nil,
      stopSequences: [String]? = nil,
      stream: Bool = false,
      temperature: Double? = nil,
      topK: Int? = nil,
      topP: Double? = nil)
   {
      self.model = model.value
      self.messages = messages
      self.maxTokens = maxTokens
      self.system = system
      self.metadata = metadata
      self.stopSequences = stopSequences
      self.stream = stream
      self.temperature = temperature
      self.topK = topK
      self.topP = topP
   }
}
