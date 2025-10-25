//
//  SkillParameter.swift
//
//
//  Created by James Rochabrun on 10/25/25.
//

import Foundation

// MARK: - Skill Creation Parameters

/// Parameters for creating a new skill.
/// See [Create Skill API](https://docs.anthropic.com/claude/reference/skills/create-skill)
public struct SkillCreateParameter {

   /// Display title for the skill.
   /// This is a human-readable label that is not included in the prompt sent to the model.
   public let displayTitle: String?

   /// Files to upload for the skill.
   /// All files must be in the same top-level directory and must include a SKILL.md file at the root.
   /// Total upload size must be under 8MB.
   public let files: [SkillFile]

   public init(
      displayTitle: String? = nil,
      files: [SkillFile]
   ) {
      self.displayTitle = displayTitle
      self.files = files
   }
}

/// Represents a file to be uploaded as part of a skill
public struct SkillFile {
   /// The file name with path relative to skill root (e.g., "skill_name/SKILL.md")
   public let filename: String
   /// The file data
   public let data: Data
   /// The MIME type of the file (e.g., "text/markdown", "text/x-python")
   public let mimeType: String?

   public init(
      filename: String,
      data: Data,
      mimeType: String? = nil
   ) {
      self.filename = filename
      self.data = data
      self.mimeType = mimeType
   }
}

// MARK: - Skill Version Parameters

/// Parameters for creating a new version of an existing skill.
/// See [Create Skill Version API](https://docs.anthropic.com/claude/reference/skills/create-skill-version)
public struct SkillVersionCreateParameter {

   /// Files to upload for the skill version.
   /// All files must be in the same top-level directory and must include a SKILL.md file at the root.
   /// Total upload size must be under 8MB.
   public let files: [SkillFile]

   public init(files: [SkillFile]) {
      self.files = files
   }
}

// MARK: - List Skills Parameters

/// Parameters for listing skills with optional filtering.
/// See [List Skills API](https://docs.anthropic.com/claude/reference/skills/list-skills)
public struct ListSkillsParameter {

   /// Pagination token for fetching a specific page of results.
   /// Pass the value from a previous response's `nextPage` field to get the next page.
   public let page: String?

   /// Number of results to return per page.
   /// Maximum value is 100. Defaults to 20.
   public let limit: Int?

   /// Filter skills by source.
   /// - "custom": only return user-created skills
   /// - "anthropic": only return Anthropic-created skills
   public let source: SkillSource?

   public enum SkillSource: String {
      case custom
      case anthropic
   }

   public init(
      page: String? = nil,
      limit: Int? = nil,
      source: SkillSource? = nil
   ) {
      self.page = page
      self.limit = limit
      self.source = source
   }
}

// MARK: - List Skill Versions Parameters

/// Parameters for listing versions of a specific skill.
/// See [List Skill Versions API](https://docs.anthropic.com/claude/reference/skills/list-skill-versions)
public struct ListSkillVersionsParameter {

   /// Pagination token for fetching a specific page of results.
   public let page: String?

   /// Number of results to return per page.
   /// Maximum value is 100. Defaults to 20.
   public let limit: Int?

   public init(
      page: String? = nil,
      limit: Int? = nil
   ) {
      self.page = page
      self.limit = limit
   }
}
