# SwiftAnthropic
<img width="1090" alt="repoOpenAI" src="https://github.com/jamesrochabrun/DelegateTutorialFinal/assets/5378604/410ee7f2-752d-4cde-994c-3ae4cd952ffa">

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
- [Message Stream](#message-stream)

## Getting an API Key

⚠️ **Important**

Anthropic is rolling out Claude slowly and incrementally, as we work to ensure the safety and scalability of it, in alignment with our company values.

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
let apiVersion = "YOUR_ANTHROPIC_API_VERSION" e.g: "2023-06-01".
let service = AnthropicServiceFactory.service(apiKey: apiKey, apiVersion: apiVersion)
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
   // For proper response generation you will need to format your prompt using alternating \n\nHuman: and \n\nAssistant: conversational turns. For example: `"\n\nHuman: {userQuestion}\n\nAssistant:"`
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
   
   public let id: String
   
   public let type: String
   
   public let completion: String
   
   public let stopReason: String
   
   public let model: String
}
```

Usage
```swift
let model = "claude-2.1"
let maxTokensToSample = 1024
let prompt = "\n\nHuman: Hello, Claude\n\nAssistant:"
let parameters = TextCompletionParameter(model: model, prompt: prompt, maxTokensToSample: 10)
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
let model = "claude-2.1"
let maxTokensToSample = 1024
let prompt = "\n\nHuman: Hello, Claude\n\nAssistant:"
let parameters = TextCompletionParameter(model: model, prompt: prompt, maxTokensToSample: 10)
let textStreamCompletion = try await service.createStreamTextCompletion(parameters)
```

### Message

Parameters:
```swift
public struct MessageParameter: Encodable {
   
   /// The model that will complete your prompt.
   // As we improve Claude, we develop new versions of it that you can query. The model parameter controls which version of Claude responds to your request. Right now we offer two model families: Claude, and Claude Instant. You can use them by setting model to "claude-2.1" or "claude-instant-1.2", respectively.
   ///See [models](https://docs.anthropic.com/claude/reference/selecting-a-model) for additional details and options.
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
   ///A system prompt is a way of providing context and instructions to Claude, such as specifying a particular goal or role. See our [guide to system prompts](https://docs.anthropic.com/claude/docs/how-to-use-system-prompts).
   let system: String?
   
   /// An object describing metadata about the request.
   let metadata: MetaData?
   
   /// Custom text sequences that will cause the model to stop generating.
   /// Our models will normally stop when they have naturally completed their turn, which will result in a response stop_reason of "end_turn".
   /// If you want the model to stop generating when it encounters custom strings of text, you can use the stop_sequences parameter. If the model encounters one of the custom sequences, the response stop_reason value will be "stop_sequence" and the response stop_sequence value will contain the matched stop sequence.
   let stopSequences: [String]?
   
   /// Whether to incrementally stream the response using server-sent events.
   ///See [streaming](https://docs.anthropic.com/claude/reference/messages-streaming for details.
   var stream: Bool
   
   /// Amount of randomness injected into the response.
   /// Defaults to 1. Ranges from 0 to 1. Use temp closer to 0 for analytical / multiple choice, and closer to 1 for creative and generative tasks.
   let temperature: Double?
   
   /// Only sample from the top K options for each subsequent token.
   /// Used to remove "long tail" low probability responses. [Learn more technical details here](https://towardsdatascience.com/how-to-sample-from-language-models-682bceb97277).
   let topK: Int?
   
   /// Use nucleus sampling.
   ///In nucleus sampling, we compute the cumulative distribution over all the options for each subsequent token in decreasing probability order and cut it off once it reaches a particular probability specified by top_p. You should either alter temperature or top_p, but not both.
   let topP: Double?
   
   struct Message: Encodable {
      let role: String
      let content: String
      
      enum Role {
         case user
         case assistant
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
   
   public let id: String
   
   public let type: String
   
   public let model: String
   
   public let role: String
   
   public let content: Content
   
   public let stopReason: String
   
   public let stopSequence: String
   
   
   public struct Content: Decodable {
      
      public let type: String
      
      public let text: String
   }
}
```

Usage
```swift
let model = "claude-2.1"
let maxTokens = 1024
let message = MessageParameter.Message(role: "user", content: "Hello, Claude")
let parameters = MessageParameter(model: model, messages: [message], maxTokens: maxTokens)
let message = try await service.createMessage(parameters)
```

### Message Stream
Response
```swift
public struct MessageStreamResponse: Decodable {
   
   public let type: String
   
   public let index: Int?
   
   public let delta: Delta?
   
   public struct Delta: Decodable {
      
      public let type: String
      
      public let text: String
   }
}
```

Usage
```swift
let model = "claude-2.1"
let maxTokens = 1024
let message = MessageParameter.Message(role: "user", content: "Hello, Claude")
let parameters = MessageParameter(model: model, messages: [message], maxTokens: maxTokens)
let message = try await service.createMessage(parameters)
```
