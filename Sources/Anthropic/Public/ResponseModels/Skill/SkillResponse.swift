//
//  SkillResponse.swift
//
//
//  Created by James Rochabrun on 10/25/25.
//

import Foundation

// MARK: - Skill Response

/// Response for a single skill.
/// Returned by create, retrieve, and list operations.
/// See [Skills API](https://docs.anthropic.com/claude/reference/skills)
public struct SkillResponse: Decodable {
  
  /// Unique identifier for the skill.
  /// The format and length of IDs may change over time.
  /// - Example: "skill_01JAbcdefghijklmnopqrstuvw"
  public let id: String
  
  /// Object type. For Skills, this is always "skill".
  public let type: String
  
  /// Display title for the skill.
  /// This is a human-readable label that is not included in the prompt sent to the model.
  public let displayTitle: String?
  
  /// Source of the skill.
  /// - "custom": the skill was created by a user
  /// - "anthropic": the skill was created by Anthropic
  public let source: String
  
  /// The latest version identifier for the skill.
  /// This represents the most recent version of the skill that has been created.
  /// - For Anthropic skills: date-based like "20251013"
  /// - For custom skills: epoch timestamp like "1759178010641129"
  public let latestVersion: String?
  
  /// ISO 8601 timestamp of when the skill was created.
  /// - Example: "2024-10-30T23:58:27.427722Z"
  public let createdAt: String
  
  /// ISO 8601 timestamp of when the skill was last updated.
  /// - Example: "2024-10-30T23:58:27.427722Z"
  public let updatedAt: String
}

// MARK: - List Skills Response

/// Response for listing skills with pagination support.
/// See [List Skills API](https://docs.anthropic.com/claude/reference/skills/list-skills)
public struct ListSkillsResponse: Decodable {
  
  /// List of skills.
  public let data: [SkillResponse]
  
  /// Whether there are more results available.
  /// If `true`, there are additional results that can be fetched using the `nextPage` token.
  public let hasMore: Bool
  
  /// Token for fetching the next page of results.
  /// If `null`, there are no more results available.
  /// Pass this value to the `page` parameter in the next request to get the next page.
  public let nextPage: String?
}

// MARK: - Skill Version Response

/// Response for a skill version.
/// Returned by version create, retrieve, and list operations.
/// See [Skill Versions API](https://docs.anthropic.com/claude/reference/skills/versions)
public struct SkillVersionResponse: Decodable {
  
  /// Unique identifier for the skill.
  public let id: String
  
  /// Object type. For skill versions, this is always "skill_version".
  public let type: String
  
  /// Display title for the skill.
  public let displayTitle: String?
  
  /// Source of the skill ("custom" or "anthropic").
  public let source: String
  
  /// Version identifier for this specific version.
  /// - For Anthropic skills: date-based like "20251013"
  /// - For custom skills: epoch timestamp like "1759178010641129"
  public let version: String
  
  /// ISO 8601 timestamp of when the skill version was created.
  public let createdAt: String
}

// MARK: - List Skill Versions Response

/// Response for listing skill versions with pagination support.
/// See [List Skill Versions API](https://docs.anthropic.com/claude/reference/skills/list-skill-versions)
public struct ListSkillVersionsResponse: Decodable {
  
  /// List of skill versions.
  public let data: [SkillVersionResponse]
  
  /// Whether there are more results available.
  public let hasMore: Bool
  
  /// Token for fetching the next page of results.
  public let nextPage: String?
}
