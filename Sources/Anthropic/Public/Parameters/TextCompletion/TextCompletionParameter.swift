//
//  TextCompletionParameter.swift
//
//
//  Created by James Rochabrun on 1/28/24.
//

import Foundation

/// [Create a Text Completion](https://docs.anthropic.com/claude/reference/complete_post)
/// POST: https://api.anthropic.com/v1/complete
public struct TextCompletionParameter: Encodable {
   
   /// The model that will complete your prompt.
   /// As we improve Claude, we develop new versions of it that you can query. The model parameter controls which version of Claude responds 
   /// to your request. Right now we offer two model families: Claude, and Claude Instant. You can use them by setting model to "claude-2.1" or "claude-instant-1.2", respectively.
   /// See [models](https://docs.anthropic.com/claude/reference/selecting-a-model) for additional details and options.
   public let model: String
   
   /// The prompt that you want Claude to complete.
   ///
   /// For proper response generation you will need to format your prompt using alternating \n\nHuman: and \n\nAssistant: conversational turns. For example:
   /// ```
   /// "\n\nHuman: {userQuestion}\n\nAssistant:"`
   /// ```
   ///
   /// See [prompt validation](https://anthropic.readme.io/claude/reference/prompt-validation) and our guide to [prompt design](https://docs.anthropic.com/claude/docs/introduction-to-prompt-designhttps://docs.anthropic.com/claude/docs/introduction-to-prompt-design) for more details.
   public let prompt: String
   
   /// The maximum number of tokens to generate before stopping.
   /// Note that our models may stop before reaching this maximum. This parameter only specifies the absolute maximum number of tokens to generate.
   public let maxTokensToSample: Int
   
   /// Sequences that will cause the model to stop generating.
   /// Our models stop on `\n\nHuman:`, and may include additional built-in stop sequences in the future. By providing the stop_sequences parameter, you may include additional strings that will cause the model to stop generating.
   public let stopSequences: [String]?
   
   /// Amount of randomness injected into the response.
   ///
   /// Defaults to 1. Ranges from 0 to 1. Use temp closer to 0 for analytical / multiple choice, and closer to 1 for creative and generative tasks.
   public let temperature: Double?
   
   /// Use nucleus sampling.
   ///
   /// In nucleus sampling, we compute the cumulative distribution over all the options for each subsequent token in decreasing probability order and
   /// cut it off once it reaches a particular probability specified by top_p. You should either alter temperature or top_p, but not both.
   public let topP: Int?
   
   /// Only sample from the top K options for each subsequent token.
   ///
   /// Used to remove "long tail" low probability responses. [Learn more technical details here](https://towardsdatascience.com/how-to-sample-from-language-models-682bceb97277).
   public let topK: Int?
   
   /// An object describing metadata about the request.
   public let metadata: MetaData?
   
   /// Whether to incrementally stream the response using server-sent events.
   /// See [streaming](https://docs.anthropic.com/claude/reference/text-completions-streaming) for details.
   public var stream: Bool
   
   public struct MetaData: Encodable {
      /// An external identifier for the user who is associated with the request.
      /// This should be a uuid, hash value, or other opaque identifier. Anthropic may use this id to help detect abuse. Do not include any identifying information such as name, email address, or phone number.
      public let userId: UUID
   }
   
   public init(
      model: Model,
      prompt: String,
      maxTokensToSample: Int,
      stopSequences: [String]? = nil,
      temperature: Double? = nil,
      topP: Int? = nil,
      topK: Int? = nil,
      metadata: MetaData? = nil,
      stream: Bool = false)
   {
      self.model = model.value
      self.prompt = prompt
      self.maxTokensToSample = maxTokensToSample
      self.stopSequences = stopSequences
      self.temperature = temperature
      self.topP = topP
      self.topK = topK
      self.metadata = metadata
      self.stream = stream
   }
}
