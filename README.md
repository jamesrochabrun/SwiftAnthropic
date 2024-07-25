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
- [Collaboration](#collaboration)

## Description

`SwiftAnthropic` is an open-source Swift package that streamlines interactions with Anthropic's API endpoints.

### Anthropic ENDPOINTS

- [Text Completion](#text-completion)
- [Text Completion Stream](#text-completion-stream)
- [Message](#message)
   - [Function Calling](#function-calling)
- [Message Stream](#message-stream)
- [Vision](#vision)
- [Examples](#demo)

## Getting an API Key

⚠️ **Important**

> Remember that your API key is a secret! Do not share it with others or expose
> it in any client-side code (browsers, apps). Production requests must be
> routed through your own backend server where your API key can be securely
> loaded from an environment variable or key management service.

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
   
   /// **[beta]** Definitions of tools that the model may use.
   ///
   /// If you include tools in your API request, the model may return tool_use content blocks that represent the model's use of those tools. You can then run those tools using the tool input generated by the model and then optionally return results back to the model using tool_result content blocks.
   ///
   /// Each tool definition includes:
   ///
   /// **name**: Name of the tool.
   ///
   /// **description**: Optional, but strongly-recommended description of the tool.
   ///
   /// **input_schema**: JSON schema for the tool input shape that the model will produce in tool_use output content blocks.
   let tools: [Tool]?
   
   struct Message: Encodable {
      let role: String
      let content: Content
      
      enum Role {
         case user
         case assistant
      }
      
      public enum Content: Encodable {
         case text(String)
         case list([ContentObject])
         
         public enum ContentObject: Encodable {
            case text(String)
            case image(ImageSource)
            
            public struct ImageSource: Encodable {
               let type: String
               let mediaType: String
               let data: String
         }
      }
      
      public init(
         role: String,
         content: String)
      {
         self.role = role
         self.content = content
      }
   }
   
   struct MetaData: Encodable {
      // An external identifier for the user who is associated with the request.
      // This should be a uuid, hash value, or other opaque identifier. Anthropic may use this id to help detect abuse. Do not include any identifying information such as name, email address, or phone number.
      let userId: UUID
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

<span style="background-color: #D3D3D3">
🎉
Tool use public beta

Anthropic is excited to announce that tool use is now in public beta! To access this feature, you'll need to include the anthropic-beta: tools-2024-04-04 header in your API requests.

They will be iterating on this open beta over the coming weeks, so feel free to provide feedback using this [form](https://forms.gle/BFnYc6iCkWoRzFgk7).
</span>

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

<span style="background-color: #D3D3D3">
⚠️ Please note that during the beta period:

Streaming (stream=true) is not yet supported. They plan to add streaming support in a future beta version.
While the feature is production-ready, they may introduce multiple beta versions before the final release.
Tool use is not yet available on third-party platforms like Vertex AI or AWS Bedrock, but is coming soon.
</span>

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
      public let inputTokens: Int
      
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

## Collaboration
Open a PR for any proposed change pointing it to `main` branch. Unit tests are highly appreciated ❤️
