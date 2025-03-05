//
//  MCPInterfaceTool+MessagePrameterTool.swift
//  MCPClientChat
//
//  Created by James Rochabrun on 3/3/25.
//

import Foundation
import MCPClient
import MCPInterface
import SwiftAnthropic

// TODO: James+Gui decide where this should live so it can be reused.

extension MCPInterface.Tool {

  // MARK: Public

  /// Converts an MCP interface tool to SwiftAnthropic's tool format.
  ///
  /// This function transforms the tool's metadata and schema structure from
  /// the MCP format to the format expected by the Anthropic API, ensuring
  /// compatibility between the two systems.
  ///
  /// - Returns: A `SwiftAnthropic.MessageParameter.Tool` representing the same
  ///   functionality as the original MCP tool.
  public func toAnthropicTool() -> SwiftAnthropic.MessageParameter.Tool {
    // Convert the JSON to SwiftAnthropic.JSONSchema
    let anthropicInputSchema: SwiftAnthropic.MessageParameter.Tool.JSONSchema?

    switch inputSchema {
    case .object(let value):
      anthropicInputSchema = convertToAnthropicJSONSchema(from: value)
    case .array:
      // Arrays are not directly supported in the schema root
      anthropicInputSchema = nil
    }

    return SwiftAnthropic.MessageParameter.Tool(
      name: name,
      description: description,
      inputSchema: anthropicInputSchema,
      cacheControl: nil)
  }

  // MARK: Private

  /// Converts MCP JSON object to SwiftAnthropic JSONSchema format.
  ///
  /// This helper function transforms a JSON schema object from MCP format to the
  /// corresponding Anthropic format, handling the root schema properties.
  ///
  /// - Parameter jsonObject: Dictionary containing MCP JSON schema properties
  /// - Returns: An equivalent SwiftAnthropic JSONSchema object, or nil if conversion fails
  private func convertToAnthropicJSONSchema(from jsonObject: [String: MCPInterface.JSON.Value]) -> SwiftAnthropic
    .MessageParameter.Tool.JSONSchema?
  {
    guard
      let typeValue = jsonObject["type"],
      case .string(let typeString) = typeValue,
      let jsonType = SwiftAnthropic.MessageParameter.Tool.JSONSchema.JSONType(rawValue: typeString)
    else {
      return nil
    }

    // Extract properties
    var properties: [String: SwiftAnthropic.MessageParameter.Tool.JSONSchema.Property]? = nil
    if
      let propertiesValue = jsonObject["properties"],
      case .object(let propertiesObject) = propertiesValue
    {
      properties = [:]
      for (key, value) in propertiesObject {
        if
          case .object(let propertyObject) = value,
          let property = convertToAnthropicProperty(from: propertyObject)
        {
          properties?[key] = property
        }
      }
    }

    // Extract required fields
    var required: [String]? = nil
    if
      let requiredValue = jsonObject["required"],
      case .array(let requiredArray) = requiredValue
    {
      required = []
      for item in requiredArray {
        if case .string(let field) = item {
          required?.append(field)
        }
      }
    }

    // Extract pattern
    var pattern: String? = nil
    if
      let patternValue = jsonObject["pattern"],
      case .string(let patternString) = patternValue
    {
      pattern = patternString
    }

    // Extract const
    var constValue: String? = nil
    if
      let constVal = jsonObject["const"],
      case .string(let constString) = constVal
    {
      constValue = constString
    }

    // Extract enum values
    var enumValues: [String]? = nil
    if
      let enumValue = jsonObject["enum"],
      case .array(let enumArray) = enumValue
    {
      enumValues = []
      for item in enumArray {
        if case .string(let value) = item {
          enumValues?.append(value)
        }
      }
    }

    // Extract multipleOf
    var multipleOf: Int? = nil
    if
      let multipleOfValue = jsonObject["multipleOf"],
      case .number(let multipleOfDouble) = multipleOfValue
    {
      multipleOf = Int(multipleOfDouble)
    }

    // Extract minimum
    var minimum: Int? = nil
    if
      let minimumValue = jsonObject["minimum"],
      case .number(let minimumDouble) = minimumValue
    {
      minimum = Int(minimumDouble)
    }

    // Extract maximum
    var maximum: Int? = nil
    if
      let maximumValue = jsonObject["maximum"],
      case .number(let maximumDouble) = maximumValue
    {
      maximum = Int(maximumDouble)
    }

    return SwiftAnthropic.MessageParameter.Tool.JSONSchema(
      type: jsonType,
      properties: properties,
      required: required,
      pattern: pattern,
      const: constValue,
      enumValues: enumValues,
      multipleOf: multipleOf,
      minimum: minimum,
      maximum: maximum)
  }

  /// Converts MCP property object to SwiftAnthropic Property format.
  ///
  /// This helper function transforms a property definition from MCP format to the
  /// corresponding Anthropic format, preserving all relevant attributes.
  ///
  /// - Parameter propertyObject: Dictionary containing MCP property schema
  /// - Returns: An equivalent SwiftAnthropic Property object, or nil if conversion fails
  private func convertToAnthropicProperty(from propertyObject: [String: MCPInterface.JSON.Value]) -> SwiftAnthropic
    .MessageParameter.Tool.JSONSchema.Property?
  {
    guard
      let typeValue = propertyObject["type"],
      case .string(let typeString) = typeValue,
      let jsonType = SwiftAnthropic.MessageParameter.Tool.JSONSchema.JSONType(rawValue: typeString)
    else {
      return nil
    }

    // Extract description
    var description: String? = nil
    if
      let descValue = propertyObject["description"],
      case .string(let descString) = descValue
    {
      description = descString
    }

    // Extract format
    var format: String? = nil
    if
      let formatValue = propertyObject["format"],
      case .string(let formatString) = formatValue
    {
      format = formatString
    }

    // Extract items
    var items: SwiftAnthropic.MessageParameter.Tool.JSONSchema.Items? = nil
    if
      let itemsValue = propertyObject["items"],
      case .object(let itemsObject) = itemsValue
    {
      items = convertToAnthropicItems(from: itemsObject)
    }

    // Extract required fields
    var required: [String]? = nil
    if
      let requiredValue = propertyObject["required"],
      case .array(let requiredArray) = requiredValue
    {
      required = []
      for item in requiredArray {
        if case .string(let field) = item {
          required?.append(field)
        }
      }
    }

    // Extract pattern
    var pattern: String? = nil
    if
      let patternValue = propertyObject["pattern"],
      case .string(let patternString) = patternValue
    {
      pattern = patternString
    }

    // Extract const
    var constValue: String? = nil
    if
      let constVal = propertyObject["const"],
      case .string(let constString) = constVal
    {
      constValue = constString
    }

    // Extract enum values
    var enumValues: [String]? = nil
    if
      let enumValue = propertyObject["enum"],
      case .array(let enumArray) = enumValue
    {
      enumValues = []
      for item in enumArray {
        if case .string(let value) = item {
          enumValues?.append(value)
        }
      }
    }

    // Extract multipleOf
    var multipleOf: Int? = nil
    if
      let multipleOfValue = propertyObject["multipleOf"],
      case .number(let multipleOfDouble) = multipleOfValue
    {
      multipleOf = Int(multipleOfDouble)
    }

    // Extract minimum
    var minimum: Double? = nil
    if
      let minimumValue = propertyObject["minimum"],
      case .number(let minimumDouble) = minimumValue
    {
      minimum = minimumDouble
    }

    // Extract maximum
    var maximum: Double? = nil
    if
      let maximumValue = propertyObject["maximum"],
      case .number(let maximumDouble) = maximumValue
    {
      maximum = maximumDouble
    }

    // Extract minItems
    var minItems: Int? = nil
    if
      let minItemsValue = propertyObject["minItems"],
      case .number(let minItemsDouble) = minItemsValue
    {
      minItems = Int(minItemsDouble)
    }

    // Extract maxItems
    var maxItems: Int? = nil
    if
      let maxItemsValue = propertyObject["maxItems"],
      case .number(let maxItemsDouble) = maxItemsValue
    {
      maxItems = Int(maxItemsDouble)
    }

    // Extract uniqueItems
    var uniqueItems: Bool? = nil
    if
      let uniqueItemsValue = propertyObject["uniqueItems"],
      case .bool(let uniqueItemsBool) = uniqueItemsValue
    {
      uniqueItems = uniqueItemsBool
    }

    return SwiftAnthropic.MessageParameter.Tool.JSONSchema.Property(
      type: jsonType,
      description: description,
      format: format,
      items: items,
      required: required,
      pattern: pattern,
      const: constValue,
      enumValues: enumValues,
      multipleOf: multipleOf,
      minimum: minimum,
      maximum: maximum,
      minItems: minItems,
      maxItems: maxItems,
      uniqueItems: uniqueItems)
  }

  /// Converts MCP items object to SwiftAnthropic Items format.
  ///
  /// This helper function transforms an items definition from MCP format to the
  /// corresponding Anthropic format, used primarily for array type properties.
  ///
  /// - Parameter itemsObject: Dictionary containing MCP items schema
  /// - Returns: An equivalent SwiftAnthropic Items object, or nil if conversion fails
  private func convertToAnthropicItems(from itemsObject: [String: MCPInterface.JSON.Value]) -> SwiftAnthropic.MessageParameter
    .Tool.JSONSchema.Items?
  {
    guard
      let typeValue = itemsObject["type"],
      case .string(let typeString) = typeValue,
      let jsonType = SwiftAnthropic.MessageParameter.Tool.JSONSchema.JSONType(rawValue: typeString)
    else {
      return nil
    }

    // Extract properties
    var properties: [String: SwiftAnthropic.MessageParameter.Tool.JSONSchema.Property]? = nil
    if
      let propertiesValue = itemsObject["properties"],
      case .object(let propertiesObject) = propertiesValue
    {
      properties = [:]
      for (key, value) in propertiesObject {
        if
          case .object(let propertyObject) = value,
          let property = convertToAnthropicProperty(from: propertyObject)
        {
          properties?[key] = property
        }
      }
    }

    // Extract pattern
    var pattern: String? = nil
    if
      let patternValue = itemsObject["pattern"],
      case .string(let patternString) = patternValue
    {
      pattern = patternString
    }

    // Extract const
    var constValue: String? = nil
    if
      let constVal = itemsObject["const"],
      case .string(let constString) = constVal
    {
      constValue = constString
    }

    // Extract enum values
    var enumValues: [String]? = nil
    if
      let enumValue = itemsObject["enum"],
      case .array(let enumArray) = enumValue
    {
      enumValues = []
      for item in enumArray {
        if case .string(let value) = item {
          enumValues?.append(value)
        }
      }
    }

    // Extract multipleOf
    var multipleOf: Int? = nil
    if
      let multipleOfValue = itemsObject["multipleOf"],
      case .number(let multipleOfDouble) = multipleOfValue
    {
      multipleOf = Int(multipleOfDouble)
    }

    // Extract minimum
    var minimum: Double? = nil
    if
      let minimumValue = itemsObject["minimum"],
      case .number(let minimumDouble) = minimumValue
    {
      minimum = minimumDouble
    }

    // Extract maximum
    var maximum: Double? = nil
    if
      let maximumValue = itemsObject["maximum"],
      case .number(let maximumDouble) = maximumValue
    {
      maximum = maximumDouble
    }

    // Extract minItems
    var minItems: Int? = nil
    if
      let minItemsValue = itemsObject["minItems"],
      case .number(let minItemsDouble) = minItemsValue
    {
      minItems = Int(minItemsDouble)
    }

    // Extract maxItems
    var maxItems: Int? = nil
    if
      let maxItemsValue = itemsObject["maxItems"],
      case .number(let maxItemsDouble) = maxItemsValue
    {
      maxItems = Int(maxItemsDouble)
    }

    // Extract uniqueItems
    var uniqueItems: Bool? = nil
    if
      let uniqueItemsValue = itemsObject["uniqueItems"],
      case .bool(let uniqueItemsBool) = uniqueItemsValue
    {
      uniqueItems = uniqueItemsBool
    }

    return SwiftAnthropic.MessageParameter.Tool.JSONSchema.Items(
      type: jsonType,
      properties: properties,
      pattern: pattern,
      const: constValue,
      enumValues: enumValues,
      multipleOf: multipleOf,
      minimum: minimum,
      maximum: maximum,
      minItems: minItems,
      maxItems: maxItems,
      uniqueItems: uniqueItems)
  }
}

/// Extension for extracting primitive values from MessageResponse.Content.DynamicContent.
/// This enables proper serialization of dynamic content to JSON for tool calls.
extension MessageResponse.Content.DynamicContent {
  /// Extracts the underlying primitive value from DynamicContent for JSON serialization.
  ///
  /// This method recursively unwraps dictionary and array values to ensure all
  /// nested dynamic content is properly converted to basic types that can be
  /// serialized to JSON.
  ///
  /// - Returns: An equivalent value using only basic Swift types (String, Int, Double, etc.)
  func extractValue() -> Any {
    switch self {
    case .string(let value):
      return value
    case .integer(let value):
      return value
    case .double(let value):
      return value
    case .dictionary(let value):
      return value.mapValues { $0.extractValue() }
    case .array(let value):
      return value.map { $0.extractValue() }
    case .bool(let value):
      return value
    case .null:
      return NSNull()
    }
  }
}
