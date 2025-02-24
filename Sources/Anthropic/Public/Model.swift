//
//  Model.swift
//
//
//  Created by James Rochabrun on 2/24/24.
//

import Foundation

/// Currently available models
/// We currently offer two families of models:
///
/// - Claude Instant: low-latency, high throughput.
/// - Claude: superior performance on tasks that require complex reasoning.
///
/// See our pricing page for pricing details.
///
/// When making requests to APIs, you must specify the model to perform the completion using the model parameter.
///
/// API model name          Model family
/// - claude-instant-1.2    Claude Instant
/// - claude-2.1                Claude
/// - claude-2.0                Claude
/// 
/// Anthropic offer two families of models:
///
/// *Claude Instant:* low-latency, high throughput.
/// *Claude:* superior performance on tasks that require complex reasoning.
///
/// When making requests to APIs, you must specify the model to perform the completion using the model parameter.
///
/// Family   Latest version
/// Claude Instant   claude-instant-1.2
/// Claude   claude-2.1
/// Note that we previously supported specifying only the major version number, e.g., claude-2, which would result in new minor versions being used automatically as they are released. However, we no longer recommend this integration pattern, and the new Messages API does not support it.
///
/// Each model has a maximum total context window size and a maximum completion length.
///
/// Model   Context window size   Max completion length
/// claude-2.1   200,000 tokens   4,096 tokens
/// claude-2.0   100,000 tokens   4,096 tokens
/// claude-instant-1.2   100,000 tokens   4,096 tokens
/// The total context window size includes both the request prompt length and response completion length. If the prompt length approaches the context window size, the max output length will be reduced to fit within the context window size.
///
/// If you encounter "stop_reason": "max_tokens" in a completion response and want Claude to continue from where it left off, you can make a new request with the previous completion appended to the previous prompt.

/// [More](https://docs.anthropic.com/claude/reference/selecting-a-model)
/// [Models](https://docs.anthropic.com/en/docs/about-claude/models)
public enum Model {
   
   case claudeInstant12
   case claude2 
   case claude21
   case claude3Opus
   case claude3Sonnet
   case claude35Sonnet
   case claude3Haiku
   case claude35Haiku
   case claude37Sonnet
   
   case other(String)

   public var value: String {
      switch self {
      case .claudeInstant12: return "claude-instant-1.2"
      case .claude2: return "claude-2.0"
      case .claude21: return "claude-2.1"
      case .claude3Opus: return "claude-3-opus-20240229"
      case .claude3Sonnet: return "claude-3-sonnet-20240229"
      case .claude35Sonnet: return "claude-3-5-sonnet-latest"
      case .claude3Haiku: return "claude-3-haiku-20240307"
      case .claude35Haiku: return "claude-3-5-haiku-latest"
      case .claude37Sonnet: return "claude-3-7-sonnet-latest"
      case .other(let model): return model
      }
   }
}
