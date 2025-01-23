# SwiftAnthropic
<img width="1275" alt="Anthropic" src="https://github.com/jamesrochabrun/SwiftAnthropic/assets/5378604/52d1dd1a-b8ee-4a6b-b2de-6fbad440217b">

![iOS 15+](https://img.shields.io/badge/iOS-15%2B-blue.svg)
[![MIT license](https://img.shields.io/badge/License-MIT-blue.svg)](https://lbesson.mit-license.org/)
[![swift-version](https://img.shields.io/badge/swift-5.9-brightgreen.svg)](https://github.com/apple/swift)
[![swiftui-version](https://img.shields.io/badge/swiftui-brightgreen)](https://developer.apple.com/documentation/swiftui)
[![xcode-version](https://img.shields.io/badge/xcode-15%20-brightgreen)](https://developer.apple.com/xcode/)
[![swift-package-manager](https://img.shields.io/badge/package%20manager-compatible-brightgreen.svg?logo=data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz4KPHN2ZyB3aWR0aD0iNjJweCIgaGVpZ2h0PSI0OXB4IiB2aWV3Qm94PSIwIDAgNjIgNDkiIHZlcnNpb249IjEuMSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIiB4bWxuczp4bGluaz0iaHR0cDovL3d3dy53My5vcmcvMTk5OS94bGluayI+CiAgICA8IS0tIEdlbmVyYXRvcjogU2tldGNoIDYzLjEgKDkyNDUyKSAtIGh0dHBzOi8vc2tldGNoLmNvbSAtLT4KICAgIDx0aXRsZT5Hcm91cDwvdGl0bGU+CiAgICA8ZGVzYz5DcmVhdGVkIHdpdGggU2tldGNoLjwvZGVzYz4KICAgIDxnIGlkPSJQYWdlLTEiIHN0cm9rZT0ibm9uZSIgc3Ryb2tlLXdpZHRoPSIxIiBmaWxsPSJub25lIiBmaWxsLXJ1bGU9ImV2ZW5vZGQiPgogICAgICAgIDxnIGlkPSJHcm91cCIgZmlsbC1ydWxlPSJub256ZXJvIj4KICAgICAgICAgICAgPHBvbHlnb24gaWQ9IlBhdGgiIGZpbGw9IiNEQkI1NTEiIHBvaW50cz0iNTEuMzEwMzQ0OCAwIDEwLjY4OTY1NTIgMCAwIDEzLjUxNzI0MTQgMCA0OSA2MiA0OSA2MiAxMy41MTcyNDE0Ij48L3BvbHlnb24+CiAgICAgICAgICAgIDxwb2x5Z29uIGlkPSJQYXRoIiBmaWxsPSIjRjdFM0FGIiBwb2ludHM9IjI3IDI1IDMxIDI1IDM1IDI1IDM3IDI1IDM3IDE0IDI1IDE0IDI1IDI1Ij48L3BvbHlnb24+CiAgICAgICAgICAgIDxwb2x5Z29uIGlkPSJQYXRoIiBmaWxsPSIjRUZDNzVFIiBwb2ludHM9IjEwLjY4OTY1NTIgMCAwIDE0IDYyIDE0IDUxLjMxMDM0NDggMCI+PC9wb2x5Z29uPgogICAgICAgICAgICA8cG9seWdvbiBpZD0iUmVjdGFuZ2xlIiBmaWxsPSIjRjdFM0FGIiBwb2ludHM9IjI3IDAgMzUgMCAzNyAxNCAyNSAxNCI+PC9wb2x5Z29uPgogICAgICAgIDwvZz4KICAgIDwvZz4KPC9zdmc+)](https://github.com/apple/swift-package-manager)

An open-source Swift package designed for effortless interaction with [Anthropic's public API](https://docs.anthropic.com/claude/reference/getting-started-with-the-api).

## Table of Contents
- [Description](#description)
- [Getting an API Key](#getting-an-api-key)
- [Installation](#installation)
- [Usage](#usage)
- [AIProxy](#aiproxy)
- [Collaboration](#collaboration)

## Description

`SwiftAnthropic` is an open-source Swift package that streamlines interactions with Anthropic's API endpoints.

### Anthropic ENDPOINTS

- [Text Completion](#text-completion)
- [Text Completion Stream](#text-completion-stream)
- [Message](#message)
   - [Function Calling](#function-calling)
   - [Prompt Caching](#prompt-caching)
- [Message Stream](#message-stream)
- [Vision](#vision)
- [PDF Support](#pdf-support)
- [Citations](#citations)
- [Count Tokens](#count-tokens)
- [Examples](#demo)

## Getting an API Key

⚠️ **Important**

> Remember that your API key is a secret! Do not share it with others or expose
> it in any client-side code (browsers, apps). Production requests must be
> routed through your own backend server where your API key can be securely
> loaded from an environment variable or key management service.

SwiftAnthropic has built-in support for AIProxy, which is a backend for AI apps, to satisfy this requirement.
To configure AIProxy, see the instructions [here](#aiproxy).

Anthropic is rolling out Claude slowly and incrementally, as they work to ensure the safety and scalability of it, in alignment with their company values.

They are working with select partners to roll out Claude in their products. If you're interested in becoming one of those partners, they are [accepting applications](https://earlyaccess.anthropic.com/). Keep in mind that, due to the overwhelming interest they received so far, they may take a while to reply.

If you have been interacting with Claude via one interface (e.g. Claude in Slack), and wish to move to another interface (e.g. API access), you may reapply for access to each product separately.


## Installation

### Swift Package Manager

1. Open your Swift project in Xcode.
2. Go to `File` ->  `Add Package Dependency`.
3. In the search bar, enter [this URL](https://github.com/jamesrochabrun/SwiftAnthropic).
4. Choose the version you'd like to install.
5. Click `Add Package`.

## Usage

To use SwiftAnthropic in your project, first import the package:

```swift
import SwiftAnthropic
```

Then, initialize the service using your Anthropic API key:

```swift
let apiKey = "YOUR_ANTHROPIC_API_KEY"
let service = AnthropicServiceFactory.service(apiKey: apiKey)
```

If needed, the api version can be overriden:

```swift
let apiKey = "YOUR_ANTHROPIC_API_KEY"
let apiVersion = "YOUR_ANTHROPIC_API_VERSION" e.g: "2023-06-01".
let service = AnthropicServiceFactory.service(apiKey: apiKey, apiVersion: apiVersion)
```

If needed, the base path can also be overriden:

```swift
let apiKey = "YOUR_ANTHROPIC_API_KEY"
let apiVersion = "YOUR_ANTHROPIC_API_VERSION" e.g: "2023-06-01".
let basePath = "https://myservice.com"
let service = AnthropicServiceFactory.service(apiKey: apiKey, apiVersion: apiVersion, basePath: basePath)
```

For Beta features you MUST provide the Beta headers like this:

```swift
let apiKey = "YOUR_ANTHROPIC_API_KEY"
let betaHeaders = [prompt-caching-2024-07-31", "max-tokens-3-5-sonnet-2024-07-15"]
let service = AnthropicServiceFactory.service(apiKey: apiKey, betaHeaders: betaHeaders)
```

### Text Completion

Parameters:
```swift
public struct TextCompletionParameter: Encodable {
   
   /// The model that will complete your prompt.
   /// As we improve Claude, we develop new versions of it that you can query. The model parameter controls which version of Claude responds to your request. Right now we offer two model families: Claude, and Claude Instant. You can use them by setting model to "claude-2.1" or "claude-instant-1.2", respectively.
   /// See [models](https://docs.anthropic.com/claude/reference/selecting-a-model) for additional details and options.
   let model: String
   
   /// The prompt that you want Claude to complete.
   /// For proper response generation you will need to format your prompt using alternating \n\nHuman: and \n\nAssistant: conversational turns. For example: `"\n\nHuman: {userQuestion}\n\nAssistant:"`
   /// See [prompt validation](https://anthropic.readme.io/claude/reference/prompt-validation) and our guide to [prompt design](https://docs.anthropic.com/claude/docs/introduction-to-prompt-designhttps://docs.anthropic.com/claude/docs/introduction-to-prompt-design) for more details.
   let prompt: String
   
   /// The maximum number of tokens to generate before stopping.
   /// Note that our models may stop before reaching this maximum. This parameter only specifies the absolute maximum number of tokens to generate.
   let maxTokensToSample: Int
   
   /// Sequences that will cause the model to stop generating.
   /// Our models stop on "\n\nHuman:", and may include additional built-in stop sequences in the future. By providing the stop_sequences parameter, you may include additional strings that will cause the model to stop generating.
   let stopSequences: [String]?
   
   /// Use nucleus sampling.
   /// In nucleus sampling, we compute the cumulative distribution over all the options for each subsequent token in decreasing probability order and cut it off once it reaches a particular probability specified by top_p. You should either alter temperature or top_p, but not both.
   let temperature: Double?
   
   /// Only sample from the top K options for each subsequent token.
   // Used to remove "long tail" low probability responses. [Learn more technical details here](https://towardsdatascience.com/how-to-sample-from-language-models-682bceb97277).
   let topK: Int?
   
   /// An object describing metadata about the request.
   let metadata: MetaData?
   
   /// Whether to incrementally stream the response using server-sent events.
   /// See [streaming](https://docs.anthropic.com/claude/reference/text-completions-streaming) for details.
   var stream: Bool
   
   struct MetaData: Encodable {
      /// An external identifier for the user who is associated with the request.
      // This should be a uuid, hash value, or other opaque identifier. Anthropic may use this id to help detect abuse. Do not include any identifying information such as name, email address, or phone number.
      let userId: UUID
   }
}
```

Response
```swift
public struct TextCompletionResponse: Decodable {
   
   /// Unique object identifier.
   ///
   /// The format and length of IDs may change over time.
   public let id: String
   
   public let type: String
   
   /// The resulting completion up to and excluding the stop sequences.
   public let completion: String
   
   /// The reason that we stopped.
   ///
   /// This may be one the following values:
   ///
   /// - "stop_sequence": we reached a stop sequence — either provided by you via the stop_sequences parameter,
   /// or a stop sequence built into the model
   ///
   /// - "max_tokens": we exceeded max_tokens_to_sample or the model's maximum
   public let stopReason: String
   
   /// The model that handled the request.
   public let model: String
}
```

Usage
```swift
let maxTokensToSample = 1024
let prompt = "\n\nHuman: Hello, Claude\n\nAssistant:"
let parameters = TextCompletionParameter(model: .claude21, prompt: prompt, maxTokensToSample: 10)
let textCompletion = try await service.createTextCompletion(parameters)
```

### Text Completion Stream

Response
```swift
public struct TextCompletionStreamResponse: Decodable {
   
   public let type: String

   public let completion: String
   
   public let stopReason: String?
   
   public let model: String
}
```

Usage
```swift
let maxTokensToSample = 1024
let prompt = "\n\nHuman: Hello, Claude\n\nAssistant:"
let parameters = TextCompletionParameter(model: .claude21, prompt: prompt, maxTokensToSample: 10)
let textStreamCompletion = try await service.createStreamTextCompletion(parameters)
```

### Message

Parameters:
```swift
public struct MessageParameter: Encodable {
   
   /// The model that will complete your prompt.
   // As we improve Claude, we develop new versions of it that you can query. The model parameter controls which version of Claude responds to your request. Right now we offer two model families: Claude, and Claude Instant. You can use them by setting model to "claude-2.1" or "claude-instant-1.2", respectively.
   /// See [models](https://docs.anthropic.com/claude/reference/selecting-a-model) for additional details and options.
   public let model: String
   
   /// Input messages.
   /// Our models are trained to operate on alternating user and assistant conversational turns. When creating a new Message, you specify the prior conversational turns with the messages parameter, and the model then generates the next Message in the conversation.
   /// Each input message must be an object with a role and content. You can specify a single user-role message, or you can include multiple user and assistant messages. The first message must always use the user role.
   /// If the final message uses the assistant role, the response content will continue immediately from the content in that message. This can be used to constrain part of the model's response.
   public let messages: [Message]
   
   /// The maximum number of tokens to generate before stopping.
   /// Note that our models may stop before reaching this maximum. This parameter only specifies the absolute maximum number of tokens to generate.
   /// Different models have different maximum values for this parameter. See [input and output](https://docs.anthropic.com/claude/reference/input-and-output-sizes) sizes for details.
   public let maxTokens: Int
   
   /// System prompt.
   /// A system prompt is a way of providing context and instructions to Claude, such as specifying a particular goal or role. See our [guide to system prompts](https://docs.anthropic.com/claude/docs/how-to-use-system-prompts).
   /// System role can be either a simple String or an array of objects, use the objects array for prompt caching.
   /// [Prompt Caching](https://docs.anthropic.com/en/docs/build-with-claude/prompt-caching)
   public let system: System?
   
   /// An object describing metadata about the request.
   public let metadata: MetaData?
   
   /// Custom text sequences that will cause the model to stop generating.
   /// Our models will normally stop when they have naturally completed their turn, which will result in a response stop_reason of "end_turn".
   /// If you want the model to stop generating when it encounters custom strings of text, you can use the stop_sequences parameter. If the model encounters one of the custom sequences, the response stop_reason value will be "stop_sequence" and the response stop_sequence value will contain the matched stop sequence.
   public let stopSequences: [String]?
   
   /// Whether to incrementally stream the response using server-sent events.
   /// See [streaming](https://docs.anthropic.com/claude/reference/messages-streaming for details.
   public var stream: Bool
   
   /// Amount of randomness injected into the response.
   /// Defaults to 1. Ranges from 0 to 1. Use temp closer to 0 for analytical / multiple choice, and closer to 1 for creative and generative tasks.
   public let temperature: Double?
   
   /// Only sample from the top K options for each subsequent token.
   /// Used to remove "long tail" low probability responses. [Learn more technical details here](https://towardsdatascience.com/how-to-sample-from-language-models-682bceb97277).
   public let topK: Int?
   
   /// Use nucleus sampling.
   /// In nucleus sampling, we compute the cumulative distribution over all the options for each subsequent token in decreasing probability order and cut it off once it reaches a particular probability specified by top_p. You should either alter temperature or top_p, but not both.
   public let topP: Double?
   
   /// If you include tools in your API request, the model may return tool_use content blocks that represent the model's use of those tools. You can then run those tools using the tool input generated by the model and then optionally return results back to the model using tool_result content blocks.
   ///
   /// Each tool definition includes:
   ///
   /// **name**: Name of the tool.
   ///
   /// **description**: Optional, but strongly-recommended description of the tool.
   ///
   /// **input_schema**: JSON schema for the tool input shape that the model will produce in tool_use output content blocks.
   ///
   /// **cacheControl**: Prompt Caching
   let tools: [Tool]?
   
   ///   Forcing tool use
   ///
   ///    In some cases, you may want Claude to use a specific tool to answer the user’s question, even if Claude thinks it can provide an answer without using a tool. You can do this by specifying the tool in the tool_choice field like so:
   ///
   ///    tool_choice = {"type": "tool", "name": "get_weather"}
   ///    When working with the tool_choice parameter, we have three possible options:
   ///
   ///    `auto` allows Claude to decide whether to call any provided tools or not. This is the default value.
   ///    `any` tells Claude that it must use one of the provided tools, but doesn’t force a particular tool.
   ///    `tool` allows us to force Claude to always use a particular tool.
   let toolChoice: ToolChoice?
   
   public enum System: Encodable {
      case text(String)
      case list([Cache])
      
      public func encode(to encoder: Encoder) throws {
         var container = encoder.singleValueContainer()
         switch self {
         case .text(let string):
            try container.encode(string)
         case .list(let objects):
            try container.encode(objects)
         }
      }
   }
   
   public struct Message: Encodable {
      
      public let role: String
      public let content: Content
      
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
            case toolUse(String, String, MessageResponse.Content.Input)
            case toolResult(String, String)
            case cache(Cache)

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
               case .toolUse(let id, let name, let input):
                   try container.encode("tool_use", forKey: .type)
                   try container.encode(id, forKey: .id)
                   try container.encode(name, forKey: .name)
                   try container.encode(input, forKey: .input)
               case .toolResult(let toolUseId, let content):
                   try container.encode("tool_result", forKey: .type)
                   try container.encode(toolUseId, forKey: .toolUseId)
                   try container.encode(content, forKey: .content)
               case .cache(let cache):
                   try container.encode(cache.type.rawValue, forKey: .type)
                   try container.encode(cache.text, forKey: .text)
                   if let cacheControl = cache.cacheControl {
                       try container.encode(cacheControl, forKey: .cacheControl)
                   }
               }
            }
            
            enum CodingKeys: String, CodingKey {
               case type
               case source
               case text
               case id
               case name
               case input
               
               case toolUseId = "tool_use_id"
               case content
               case cacheControl = "cache_control"
            }
         }
         
         public struct ImageSource: Encodable {
            
            public let type: String
            public let mediaType: String
            public let data: String
            
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
      public let userId: UUID
   }
   
   public struct ToolChoice: Codable {
      public enum ToolType: String, Codable {
         case tool
         case auto
         case any
      }
      
      let type: ToolType
      let name: String?
      
      public init(
         type: ToolType,
         name: String? = nil)
      {
         self.type = type
         self.name = name
      }
   }
   
   public struct Tool: Codable, Equatable {
      
      /// The name of the function to be called. Must be a-z, A-Z, 0-9, or contain underscores and dashes, with a maximum length of 64.
      public let name: String
      /// A description of what the function does, used by the model to choose when and how to call the function.
      public let description: String?
      /// The parameters the functions accepts, described as a JSON Schema object. See the [guide](https://docs.anthropic.com/en/docs/build-with-claude/tool-use) for examples, and the [JSON Schema reference](https://json-schema.org/understanding-json-schema) for documentation about the format.
      /// To describe a function that accepts no parameters, provide the value `{"type": "object", "properties": {}}`.
      public let inputSchema: JSONSchema?
      /// [Prompt Caching](https://docs.anthropic.com/en/docs/build-with-claude/prompt-caching#caching-tool-definitions)
      public let cacheControl: CacheControl?
      
      public struct JSONSchema: Codable, Equatable {
         
         public let type: JSONType
         public let properties: [String: Property]?
         public let required: [String]?
         public let pattern: String?
         public let const: String?
         public let enumValues: [String]?
         public let multipleOf: Int?
         public let minimum: Int?
         public let maximum: Int?
         
         private enum CodingKeys: String, CodingKey {
            case type, properties, required, pattern, const
            case enumValues = "enum"
            case multipleOf, minimum, maximum
         }
         
         public struct Property: Codable, Equatable {
            
            public let type: JSONType
            public let description: String?
            public let format: String?
            public let items: Items?
            public let required: [String]?
            public let pattern: String?
            public let const: String?
            public let enumValues: [String]?
            public let multipleOf: Int?
            public let minimum: Double?
            public let maximum: Double?
            public let minItems: Int?
            public let maxItems: Int?
            public let uniqueItems: Bool?
            
            private enum CodingKeys: String, CodingKey {
               case type, description, format, items, required, pattern, const
               case enumValues = "enum"
               case multipleOf, minimum, maximum
               case minItems, maxItems, uniqueItems
            }
            
            public init(
               type: JSONType,
               description: String? = nil,
               format: String? = nil,
               items: Items? = nil,
               required: [String]? = nil,
               pattern: String? = nil,
               const: String? = nil,
               enumValues: [String]? = nil,
               multipleOf: Int? = nil,
               minimum: Double? = nil,
               maximum: Double? = nil,
               minItems: Int? = nil,
               maxItems: Int? = nil,
               uniqueItems: Bool? = nil)
            {
               self.type = type
               self.description = description
               self.format = format
               self.items = items
               self.required = required
               self.pattern = pattern
               self.const = const
               self.enumValues = enumValues
               self.multipleOf = multipleOf
               self.minimum = minimum
               self.maximum = maximum
               self.minItems = minItems
               self.maxItems = maxItems
               self.uniqueItems = uniqueItems
            }
         }
         
         public enum JSONType: String, Codable {
            case integer = "integer"
            case string = "string"
            case boolean = "boolean"
            case array = "array"
            case object = "object"
            case number = "number"
            case `null` = "null"
         }
         
         public struct Items: Codable, Equatable {
            
            public let type: JSONType
            public let properties: [String: Property]?
            public let pattern: String?
            public let const: String?
            public let enumValues: [String]?
            public let multipleOf: Int?
            public let minimum: Double?
            public let maximum: Double?
            public let minItems: Int?
            public let maxItems: Int?
            public let uniqueItems: Bool?
            
            private enum CodingKeys: String, CodingKey {
               case type, properties, pattern, const
               case enumValues = "enum"
               case multipleOf, minimum, maximum, minItems, maxItems, uniqueItems
            }
            
            public init(
               type: JSONType,
               properties: [String : Property]? = nil,
               pattern: String? = nil,
               const: String? = nil,
               enumValues: [String]? = nil,
               multipleOf: Int? = nil,
               minimum: Double? = nil,
               maximum: Double? = nil,
               minItems: Int? = nil,
               maxItems: Int? = nil,
               uniqueItems: Bool? = nil)
            {
               self.type = type
               self.properties = properties
               self.pattern = pattern
               self.const = const
               self.enumValues = enumValues
               self.multipleOf = multipleOf
               self.minimum = minimum
               self.maximum = maximum
               self.minItems = minItems
               self.maxItems = maxItems
               self.uniqueItems = uniqueItems
            }
         }
         
         public init(
            type: JSONType,
            properties: [String : Property]? = nil,
            required: [String]? = nil,
            pattern: String? = nil,
            const: String? = nil,
            enumValues: [String]? = nil,
            multipleOf: Int? = nil,
            minimum: Int? = nil,
            maximum: Int? = nil)
         {
            self.type = type
            self.properties = properties
            self.required = required
            self.pattern = pattern
            self.const = const
            self.enumValues = enumValues
            self.multipleOf = multipleOf
            self.minimum = minimum
            self.maximum = maximum
         }
      }
      
      public init(
         name: String,
         description: String?,
         inputSchema: JSONSchema?,
         cacheControl: CacheControl? = nil)
      {
         self.name = name
         self.description = description
         self.inputSchema = inputSchema
         self.cacheControl = cacheControl
      }
   }
   
   /// [Prompt Caching](https://docs.anthropic.com/en/docs/build-with-claude/prompt-caching)
   public struct Cache: Encodable {
      let type: CacheType
      let text: String
      let cacheControl: CacheControl?
      
      public init(
         type: CacheType = .text,
         text: String,
         cacheControl: CacheControl?)
      {
         self.type = type
         self.text = text
         self.cacheControl = cacheControl
      }
      
      public enum CacheType: String, Encodable {
         case text
      }
   }
   
   public struct CacheControl: Codable, Equatable {
      
      let type: CacheControlType
      
      public init(type: CacheControlType) {
         self.type = type
      }
      
      public enum CacheControlType: String, Codable {
         case ephemeral
      }
   }
   
   public init(
      model: Model,
      messages: [Message],
      maxTokens: Int,
      system: System? = nil,
      metadata: MetaData? = nil,
      stopSequences: [String]? = nil,
      stream: Bool = false,
      temperature: Double? = nil,
      topK: Int? = nil,
      topP: Double? = nil,
      tools: [Tool]? = nil,
      toolChoice: ToolChoice? = nil)
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
      self.tools = tools
      self.toolChoice = toolChoice
   }
}
```

Response
```swift
public struct MessageResponse: Decodable {
   
   /// Unique object identifier.
   ///
   /// The format and length of IDs may change over time.
   public let id: String
   
   /// e.g: "message"
   public let type: String
   
   /// The model that handled the request.
   public let model: String
   
   /// Conversational role of the generated message.
   ///
   /// This will always be "assistant".
   public let role: String
   
   /// Array of Content objects representing blocks of content generated by the model.
   ///
   /// Each content block has a `type` that determines its structure, with "text" being the currently available type.
   ///
   /// - Example:
   ///   ```
   ///   [{"type": "text", "text": "Hi, I'm Claude."}]
   ///   ```
   ///
   /// The response content seamlessly follows from the last turn if the request input ends with an assistant turn. This allows for a continuous output based on the last interaction.
   ///
   /// - Example Input:
   ///   ```
   ///   [
   ///     {"role": "user", "content": "What's the Greek name for Sun? (A) Sol (B) Helios (C) Sun"},
   ///     {"role": "assistant", "content": "The best answer is ("}
   ///   ]
   ///   ```
   ///
   /// - Example Output:
   ///   ```
   ///   [{"type": "text", "text": "B)"}]
   ///   ```
   ///
   ///   ***Beta***
   ///
   /// - Example tool use:
   ///   ```
   ///   [{"type": "tool_use", "id": "toolu_01A09q90qw90lq917835lq9", "name": "get_weather", "input": { "location": "San Francisco, CA", "unit": "celsius"}}]
   ///   ```
   /// This structure facilitates the integration and manipulation of model-generated content within your application.
   public let content: [Content]

   /// indicates why the process was halted.
   ///
   /// This property can hold one of the following values to describe the stop reason:
   /// - `"end_turn"`: The model reached a natural stopping point.
   /// - `"max_tokens"`: The requested `max_tokens` limit or the model's maximum token limit was exceeded.
   /// - `"stop_sequence"`: A custom stop sequence provided by you was generated.
   ///
   /// It's important to note that the values for `stopReason` here differ from those in `/v1/complete`, specifically in how `end_turn` and `stop_sequence` are distinguished.
   ///
   /// - In non-streaming mode, `stopReason` is always non-null, indicating the reason for stopping.
   /// - In streaming mode, `stopReason` is null in the `message_start` event and non-null in all other cases, providing context for the stoppage.
   ///
   /// This design allows for a detailed understanding of the process flow and its termination points.
   public let stopReason: String?

   /// Which custom stop sequence was generated.
   ///
   /// This value will be non-null if one of your custom stop sequences was generated.
   public let stopSequence: String?
   
   /// Container for the number of tokens used.
   public let usage: Usage
   
   public struct Content: Decodable {
      
      public let type: String
      
      public let text: String
   }
   
   public struct Usage: Decodable {
      
      /// The number of input tokens which were used.
      public let inputTokens: Int?
      
      /// The number of output tokens which were used.
      public let outputTokens: Int
      
      /// [Prompt Caching](https://docs.anthropic.com/en/docs/build-with-claude/prompt-caching#how-can-i-track-the-effectiveness-of-my-caching-strategy)
      /// You can monitor cache performance using the cache_creation_input_tokens and cache_read_input_tokens fields in the API response.
      
      public let cacheCreationInputTokens: Int?
      public let cacheReadInputTokens: Int?
   }
}
```

Usage
```swift
let maxTokens = 1024
let messageParameter = MessageParameter.Message(role: .user, content: "Hello, Claude")
let parameters = MessageParameter(model: .claude21, messages: [messageParameter], maxTokens: maxTokens)
let message = try await service.createMessage(parameters)
```

### Function Calling

Tool use (function calling). Claude is capable of interacting with external client-side tools and functions, allowing you to equip Claude with your own custom tools to perform a wider variety of tasks.

Here's an example of how to provide tools to Claude using the Messages API:

Usage
```swift
let maxTokens = 1024
let weatherTool = MessageParameter.Tool(
            name: "get_weather", 
            description: "Get the current weather in a given location",
            inputSchema: .init(
                           type: .object,
                           properties: [
                              "location": .init(type: .string, description: "The city and state, e.g. San Francisco, CA"),
                              "unit": .init(type: .string, description: "The unit of temperature, either celsius or fahrenheit")
                           ],
                           required: ["location"]))

let messageParameter = MessageParameter.Message(role: .user, content: "What is the weather like in San Francisco?")
let parameters = MessageParameter(model: .claude3Opus, messages: [messageParameter], maxTokens: maxTokens, tools: [weatherTool])

let message = try await service.createMessage(parameters)
```

When Claude decides to use one of the tools you've provided, it will return a response with a stop_reason of tool_use and one or more tool_use content blocks in the API response that include:

**id**: A unique identifier for this particular tool use block. This will be used to match up the tool results later.
**name**: The name of the tool being used.
**input**: An object containing the input being passed to the tool, conforming to the tool's input_schema.

Here's an example API response with a tool_use content block:

```json
{
  "id": "msg_01Aq9w938a90dw8q",
  "model": "claude-3-opus-20240229",
  "stop_reason": "tool_use",
  "role": "assistant",
  "content": [
    {
      "type": "text",
      "text": "<thinking>I need to use the get_weather, and the user wants SF, which is likely San Francisco, CA.</thinking>"
    },
    {
      "type": "tool_use",
      "id": "toolu_01A09q90qw90lq917835lq9",
      "name": "get_weather",
      "input": {"location": "San Francisco, CA", "unit": "celsius"}
    }
  ]
}
```

*Disabling parallel tool use*

By default, Claude may use multiple tools to answer a user query. You can disable this behavior by setting disable_parallel_tool_use=true in the tool_choice field.

When tool_choice type is auto, this ensures that Claude uses at most one tool
When tool_choice type is any or tool, this ensures that Claude uses exactly one tool

Usage
```swift
let toolChoice = ToolChoice(
    type: .auto,
    disableParallelToolUse: true
)

let messageParameter = MessageParameter(
    model: model,
    messages: messages,
    maxTokens: maxTokens,
    toolChoice: toolChoice
    // ... other parameters
)
```

🚀 Tool use with stream enabled, is also supported. Please visit the [demo project for details](https://github.com/jamesrochabrun/SwiftAnthropic/tree/main/Examples/SwiftAnthropicExample/SwiftAnthropicExample/FunctionCalling)

### Prompt Caching

Prompt Caching is a powerful feature that optimizes your API usage by allowing resuming from specific prefixes in your prompts. This approach significantly reduces processing time and costs for repetitive tasks or prompts with consistent elements.
For general guidance in Prompt Caching please visit the official [Anthropic Documentation](https://docs.anthropic.com/en/docs/build-with-claude/prompt-caching).

<span style="background-color: #D3D3D3">

/// Copied from Anthropic [website](https://docs.anthropic.com/en/docs/build-with-claude/prompt-caching#large-context-caching-example))

Prompt Caching is in beta

Prompt Caching is now in public beta! To access this feature, you’ll need to include the anthropic-beta: `prompt-caching-2024-07-31` header in your API requests.

</span>

How to use it with `SwiftAnthropic`:

You can use it as a `System` role:

```json
    "system": [
      {
        "type": "text", 
        "text": "You are an AI assistant tasked with analyzing literary works. Your goal is to provide insightful commentary on themes, characters, and writing style.\n"
      },
      {
        "type": "text", 
        "text": "<the entire contents of Pride and Prejudice>",
        "cache_control": {"type": "ephemeral"}
      }
    ],
```

The above is a system role, it translates to this in `SwiftAnthropic`

```swift
let systemPrompt = "You are an AI assistant tasked with analyzing literary works. Your goal is to provide insightful commentary on themes, characters, and writing style"
let someLargePieceOfContentLikeABook: String = "<the entire contents of Pride and Prejudice>"
let systemContent = MessageParameter.Cache(text: systemPrompt, cacheControl: nil)
let cache = MessageParameter.Cache(text: someLargePieceOfContentLikeABook, cacheControl:  .init(type: .ephemeral))
let usersMessage = MessageParameter.Message(role: .user, content: .text("Analyze the major themes in Pride and Prejudice."))
let parameters = MessageParameter(
   model: .claude35Sonnet,
   messages: [usersMessage],
   maxTokens: 1024,
   system: .list([
      systemContent,
      cache
   ]))
let request = try await service.createMessage(parameters)                
```

Using Prompt Caching in a Message:

```swift
let usersPrompt = "Summarize this transcription"
let videoTranscription = "<Some_Long_Text>"
let usersMessageContent = MessageParameter.Message.Content.ContentObject.text(usersPrompt)
let cache = MessageParameter.Message.Content.ContentObject.cache(.init(text: videoTranscription, cacheControl: .init(type: .ephemeral)))
let usersMessage = MessageParameter.Message(role: .user, content: .list([usersMessageContent, cache]))
      let parameters = MessageParameter(
         model: .claude35Sonnet,
         messages: [usersMessage],
         maxTokens: 1024,
         system: .text("You are an AI assistant tasked with analyzing literary works"))
```

Using Prompt Caching in a Tool:

```swift
MessageParameter.Tool(
   name: self.rawValue,
   description: "Get the current weather in a given location",
   inputSchema: .init(
                  type: .object,
                  properties: [
                     "location": .init(type: .string, description: "The city and state, e.g. San Francisco, CA"),
                     "unit": .init(type: .string, description: "The unit of temperature, either celsius or fahrenheit")
                  ],
                  required: ["location"]),
   cacheControl: .init(type: .ephemeral))
```


Swift Response
```swift
public struct MessageResponse: Decodable {
   
   /// Unique object identifier.
   ///
   /// The format and length of IDs may change over time.
   public let id: String
   
   /// e.g: "message"
   public let type: String
   
   /// The model that handled the request.
   public let model: String
   
   /// Conversational role of the generated message.
   ///
   /// This will always be "assistant".
   public let role: String
   
   /// Array of Content objects representing blocks of content generated by the model.
   public let content: [Content]

   /// indicates why the process was halted.
   public let stopReason: String?

   /// Which custom stop sequence was generated.
   ///
   /// This value will be non-null if one of your custom stop sequences was generated.
   public let stopSequence: String?
   
   /// Container for the number of tokens used.
   public let usage: Usage
   
   public enum Content: Decodable {
      
      public typealias Input = [String: DynamicContent]
      
      case text(String)
      case toolUse(id: String, name: String, input: Input)
      
      private enum CodingKeys: String, CodingKey {
         case type, text, id, name, input
      }
      
      public enum DynamicContent: Decodable {
         
         case string(String)
         case integer(Int)
         case double(Double)
         case dictionary([String: DynamicContent])
         case array([DynamicContent])
         case bool(Bool)
         case null
         
         public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if let intValue = try? container.decode(Int.self) {
               self = .integer(intValue)
            } else if let doubleValue = try? container.decode(Double.self) {
               self = .double(doubleValue)
            } else if let stringValue = try? container.decode(String.self) {
               self = .string(stringValue)
            } else if let boolValue = try? container.decode(Bool.self) {
               self = .bool(boolValue)
            } else if container.decodeNil() {
               self = .null
            } else if let arrayValue = try? container.decode([DynamicContent].self) {
               self = .array(arrayValue)
            } else if let dictionaryValue = try? container.decode([String: DynamicContent].self) {
               self = .dictionary(dictionaryValue)
            } else {
               throw DecodingError.dataCorruptedError(in: container, debugDescription: "Content cannot be decoded")
            }
         }
      }
      
      public init(from decoder: Decoder) throws {
         let container = try decoder.container(keyedBy: CodingKeys.self)
         let type = try container.decode(String.self, forKey: .type)
         switch type {
         case "text":
            let text = try container.decode(String.self, forKey: .text)
            self = .text(text)
         case "tool_use":
            let id = try container.decode(String.self, forKey: .id)
            let name = try container.decode(String.self, forKey: .name)
            let input = try container.decode(Input.self, forKey: .input)
            self = .toolUse(id: id, name: name, input: input)
         default:
            throw DecodingError.dataCorruptedError(forKey: .type, in: container, debugDescription: "Invalid type value found in JSON!")
         }
      }
   }
   
   public struct Usage: Decodable {
      
      /// The number of input tokens which were used.
      public let inputTokens: Int?
      
      /// The number of output tokens which were used.
      public let outputTokens: Int
   }
}
```

### Message Stream
Response
```swift
public struct MessageStreamResponse: Decodable {
   
   public let type: String
   
   public let index: Int?
   
   /// available in "content_block_start" event
   public let contentBlock: ContentBlock?
   
   /// available in "message_start" event
   public let message: MessageResponse?
   
   /// Available in "content_block_delta", "message_delta" events.
   public let delta: Delta?
   
   /// Available in "message_delta" events.
   public let usage: MessageResponse.Usage?
   
   public struct Delta: Decodable {
      
      public let type: String?
      
      public let text: String?
      
      /// type = tool_use
      public let partialJson: String?
      
      public let stopReason: String?
      
      public let stopSequence: String?
   }
   
   public struct ContentBlock: Decodable {
      
      // Can be of type `text` or `tool_use`
      public let type: String
      
      /// `text` type
      public let text: String?
      
      /// `tool_use` type
      
      public let input: [String: MessageResponse.Content.DynamicContent]?
      
      public let name: String?
      
      public let id: String?
      
      public var toolUse: MessageResponse.Content.ToolUse? {
         guard let name, let id else { return nil }
         return .init(id: id, name: name, input: input ?? [:])
      }
   }
   
   /// https://docs.anthropic.com/en/api/messages-streaming#event-types
   public enum StreamEvent: String {
      
      case contentBlockStart = "content_block_start"
      case contentBlockDelta = "content_block_delta"
      case contentBlockStop = "content_block_stop"
      case messageStart = "message_start"
      case messageDelta = "message_delta"
      case messageStop = "message_stop"
   }
}
```

Usage
```swift
let maxTokens = 1024
let messageParameter = MessageParameter.Message(role: .user, content: "Hello, Claude")
let parameters = MessageParameter(model: .claude21, messages: [messageParameter], maxTokens: maxTokens)
let message = try await service.streamMessage(parameters)
```

### Vision

<img width="619" alt="Anthropic docs" src="https://github.com/jamesrochabrun/SwiftAnthropic/assets/5378604/33b591d2-13dd-49b8-b2af-b8cad11e6575">

Usage
```swift
let maxTokens = 1024
let prompt = "What is this image about?"
let base64Image = "/9j/4AAQSkZJRg..."

/// Define the image source
let imageSource: MessageParameter.Message.Content.ContentObject = .image(.init(type: .base64, mediaType: .jpeg, data: base64Image))

/// Define the text message
let text: MessageParameter.Message.Content.ContentObject = .text(prompt)

/// Define the content for the message parameter
let content: MessageParameter.Message.Content = list([imageSource, text])

/// Define the messages parameter
let messagesParameter = [MessageParameter.Message(role: .user, content: content)]

/// Define the parameters
let parameters = MessageParameter(model: .claude3Sonnet, messages: messagesParameter, maxTokens: maxTokens)

let message = try await service.streamMessage(parameters)
```

### Demo

Check the [blog post](https://medium.com/@jamesrochabrun/anthropic-ios-sdk-032e1dc6afd8) for more details.

You can also run the Demo project located on the [Examples](https://github.com/jamesrochabrun/SwiftAnthropic/tree/main/Examples/SwiftAnthropicExample) folder on this Package.

<img width="350" alt="Anthropic" src="https://github.com/jamesrochabrun/SwiftAnthropic/assets/5378604/c2d39617-e8ab-44aa-ac2d-f01d94bb8bfc">

### PDF Support

Claude can now analyze PDFs through the Messages API. Here's a simple example:

```swift
let maxTokens = 1024
let prompt = "Please analyze this document"

// Load PDF data
let pdfData = // your PDF data
let base64PDF = pdfData.base64EncodedString()

// Create document source
let documentSource = try MessageParameter.Message.Content.DocumentSource.pdf(base64Data: base64PDF)

// Create message with document and prompt
let message = MessageParameter.Message(
    role: .user,
    content: .list([
        .document(documentSource),
        .text(prompt)
    ])
)

// Create parameters
let parameters = MessageParameter(
    model: .claude35Sonnet,
    messages: [message],
    maxTokens: maxTokens
)

// Send request
let response = try await service.createMessage(parameters)
```

### Citation Support

```swift
let maxTokens = 1024
let prompt = "Please analyze this document"

// Load PDF data
let pdfData = // your PDF data
let base64PDF = pdfData.base64EncodedString()

// Create document source
let documentSource = try MessageParameter.Message.Content.DocumentSource.pdf(base64Data: base64PDF, citations: .init(enabled: true))

// Create message with document and prompt
let message = MessageParameter.Message(
    role: .user,
    content: .list([
        .document(documentSource),
        .text(prompt)
    ])
)

// Create parameters
let parameters = MessageParameter(
    model: .claude35Sonnet,
    messages: [message],
    maxTokens: maxTokens
)

// Send request
let response = try await service.streamMessage(parameters)
```

For more information on how to use Citations in your app, please visit the official [Anthropic documentation](https://docs.anthropic.com/en/docs/build-with-claude/citations).

### Count Tokens

Parameters:
```swift
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
}
```

Response:
```swift
public struct MessageInputTokens: Decodable {
   
   /// The total number of tokens across the provided list of messages, system prompt, and tools.
   public let inputTokens: Int
}
```

Usage:
```swift
let messageParameter = MessageParameter.Message(role: .user, content: .text("Hello, Claude"))
let parameters = MessageTokenCountParameter(
    model: .claude3Sonnet,
    messages: [messageParameter]
)
let tokenCount = try await service.countTokens(parameter: parameters)
print("Input tokens: \(tokenCount.inputTokens)")
```

## AIProxy

### What is it?
[AIProxy](https://www.aiproxy.pro) is a backend for iOS apps that proxies requests from your app to Anthropic.
Using a proxy keeps your Anthropic key secret, protecting you from unexpectedly high bills due to key theft.
Requests are only proxied if they pass your defined rate limits and Apple's [DeviceCheck](https://developer.apple.com/documentation/devicecheck) verification.
We offer AIProxy support so you can safely distribute apps built with SwiftAnthropic.


### How does my SwiftAnthropic code change?

Proxy requests through AIProxy with two changes to your Xcode project:

1. Instead of initializing `service` with:

        let apiKey = "your_anthropic_api_key_here"
        let service = AnthropicServiceFactory.service(apiKey: apiKey)

Use:

        let service = AnthropicServiceFactory.service(
            aiproxyPartialKey: "your_partial_key_goes_here",
            aiproxyServiceURL: "your_service_url_goes_here"
        )

The `aiproxyPartialKey` and `aiproxyServiceURL` values are provided to you on the [AIProxy developer dashboard](https://developer.aiproxy.pro)

2. Add an `AIPROXY_DEVICE_CHECK_BYPASS' env variable to Xcode. This token is provided to you in the AIProxy
   developer dashboard, and is necessary for the iOS simulator to communicate with the AIProxy backend.
    - Go to `Product > Scheme > Edit Scheme` to open up the "Edit Schemes" menu in Xcode
    - Select `Run` in the sidebar
    - Select `Arguments` from the top nav
    - Add to the "Environment Variables" section (not the "Arguments Passed on Launch" section) an env
      variable with name `AIPROXY_DEVICE_CHECK_BYPASS` and value that we provided you in the AIProxy dashboard


⚠️  The `AIPROXY_DEVICE_CHECK_BYPASS` is intended for the simulator only. Do not let it leak into
a distribution build of your app (including a TestFlight distribution). If you follow the steps above,
then the constant won't leak because env variables are not packaged into the app bundle.

#### What is the `AIPROXY_DEVICE_CHECK_BYPASS` constant?

AIProxy uses Apple's [DeviceCheck](https://developer.apple.com/documentation/devicecheck) to ensure
that requests received by the backend originated from your app on a legitimate Apple device.
However, the iOS simulator cannot produce DeviceCheck tokens. Rather than requiring you to
constantly build and run on device during development, AIProxy provides a way to skip the
DeviceCheck integrity check. The token is intended for use by developers only. If an attacker gets
the token, they can make requests to your AIProxy project without including a DeviceCheck token, and
thus remove one level of protection.

#### What is the `aiproxyPartialKey` constant?

This constant is safe to include in distributed version of your app. It is one part of an
encrypted representation of your real secret key. The other part resides on AIProxy's backend.
As your app makes requests to AIProxy, the two encrypted parts are paired, decrypted, and used
to fulfill the request to Anthropic.

#### How to setup my project on AIProxy?

Please see the [AIProxy integration guide](https://www.aiproxy.pro/docs/integration-guide.html)


### ⚠️  Disclaimer

Contributors of SwiftAnthropic shall not be liable for any damages or losses caused by third parties.
Contributors of this library provide third party integrations as a convenience. Any use of a third
party's services are assumed at your own risk.


## Collaboration
Open a PR for any proposed change pointing it to `main` branch. Unit tests are highly appreciated ❤️
