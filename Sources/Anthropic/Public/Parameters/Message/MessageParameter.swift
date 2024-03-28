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
   

   // Functions the model can invoke in responses
   // When non-empty, `stopSequences` will automatically include "</function_calls>", per Anthropic's API docs
   let functions: [Function]

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
   var stopSequences: [String]
   
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
      
      public enum Content: Encodable {
         
         case text(String)
         case list([ContentObject])
         
         // Custom encoding to handle different cases
         public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            switch self {
            case .text(let text):
               try container.encode(text)
            case .list(let objects):
               try container.encode(objects)
            }
         }
         
         public enum ContentObject: Encodable {
            case text(String)
            case image(ImageSource)
            
            // Custom encoding to handle different cases
            public func encode(to encoder: Encoder) throws {
               var container = encoder.container(keyedBy: CodingKeys.self)
               switch self {
               case .text(let text):
                  try container.encode("text", forKey: .type)
                  try container.encode(text, forKey: .text)
               case .image(let source):
                  try container.encode("image", forKey: .type)
                  try container.encode(source, forKey: .source)
               }
            }
            
            enum CodingKeys: String, CodingKey {
               case type
               case source
               case text
            }
         }
         
         public struct ImageSource: Encodable {
            
            let type: String
            let mediaType: String
            let data: String
            
            public enum MediaType: String, Encodable {
               case jpeg = "image/jpeg"
               case png = "image/png"
               case gif = "image/gif"
               case webp = "image/webp"
            }
            
            public enum ImageSourceType: String, Encodable {
               case base64
            }
            
            public init(
               type: ImageSourceType,
               mediaType: MediaType,
               data: String)
            {
               self.type = type.rawValue
               self.mediaType = mediaType.rawValue
               self.data = data
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
    
    public struct Function {
        let name: String
        let description: String
        let parameters: [Parameter]
  
        public init(name: String, description: String, parameters: [Parameter]) {
            self.name = name
            self.description = description
            self.parameters = parameters
        }
        
        public struct Parameter {
            let name: String
            let type: ParamType
            let description: String
            
            public init(name: String, type: ParamType, description: String) {
                self.name = name
                self.type = type
                self.description = description
            }
            
            public enum ParamType: String {
                case string
                case integer
                case number
            }

            public func toXML() -> String {
                return """
            <parameter>
                <name>\(name)</name>
                <type>\(type)</type>
                <description>\(description)</description>
            </parameter>
            """
            }
        }
        
        public func toXML() -> String {
            return """
        <tool_description>
            <tool_name>\(name)</tool_name>
            <description>\(description)</description>
            <parameters>
                \(parameters.map { $0.toXML() }.joined(separator:"\n\t\t"))
            </parameters>
        </tool_description>
        """
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case model
        case messages
        case maxTokens
        case system
        case metadata
        case stopSequences
        case stream
        case temperature
        case topK
        case topP
    }
    
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(model, forKey: .model)
        try container.encode(messages, forKey: .messages)
        try container.encode(maxTokens, forKey: .maxTokens)
        var systemStr = system ?? ""
        if functions.count > 0 {
            systemStr += toolsPreamble
            systemStr += functions.compactMap { $0.toXML() }.joined(separator: "\n")
        }
        try container.encode(systemStr, forKey: .system)
        try container.encode(metadata, forKey: .metadata)
        try container.encode(stopSequences, forKey:  .stopSequences)
        try container.encode(stream, forKey: .stream)
        try container.encode(temperature, forKey: .temperature)
        try container.encode(topK, forKey: .topK)
        try container.encode(topP, forKey: .topP)
    }
    
    private let toolsPreamble = """
In this environment you have access to a set of tools you can use to answer the user's question.

You may call them like this:
<function_calls>
<invoke>
<tool_name>$TOOL_NAME</tool_name>
<parameters>
<$PARAMETER_NAME>$PARAMETER_VALUE</$PARAMETER_NAME>
...
</parameters>
</invoke>
</function_calls>

Here are the tools available:
"""
    
    
   private static let functionCallStopSequence = "</function_calls>"

   public init(
      model: Model,
      messages: [Message],
      maxTokens: Int,
      system: String? = nil,
      functions: [Function] = [],
      metadata: MetaData? = nil,
      stopSequences: [String] = [],
      stream: Bool = false,
      temperature: Double? = nil,
      topK: Int? = nil,
      topP: Double? = nil)
   {
      self.model = model.value
      self.messages = messages
      self.functions = functions
      self.maxTokens = maxTokens
      self.system = system
      self.metadata = metadata
      self.stopSequences = stopSequences
      self.stream = stream
      self.temperature = temperature
      self.topK = topK
      self.topP = topP

      if self.functions.count > 0,
         !self.stopSequences.contains(Self.functionCallStopSequence) {
          self.stopSequences.append(Self.functionCallStopSequence)
      }
   }
}
