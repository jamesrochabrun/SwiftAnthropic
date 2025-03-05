//
//  MCPTool+OpenAITool.swift
//  MCPClientChat
//
//  Created by James Rochabrun on 3/5/25.
//

import Foundation
import MCPClient
import MCPInterface
import SwiftOpenAI

extension MCPInterface.Tool {
   
   /**
    * Converts an MCP interface tool to SwiftOpenAI's tool format.
    *
    * This function transforms the tool's metadata and schema structure from
    * the MCP format to the format expected by the OpenAI API, ensuring
    * compatibility between the two systems.
    *
    * - Returns: A `SwiftOpenAI.Tool` representing the same
    *   functionality as the original MCP tool.
    */
   public func toOpenAITool() -> SwiftOpenAI.ChatCompletionParameters.Tool {
      // Convert the JSON to SwiftOpenAI.JSONSchema
      let openAIParameters: SwiftOpenAI.JSONSchema?
      
      switch self.inputSchema {
      case .object(let value):
         openAIParameters = convertToOpenAIJSONSchema(from: value)
      case .array(_):
         // Arrays are not directly supported in the schema root
         openAIParameters = nil
      }
      
      let chatFunction = SwiftOpenAI.ChatCompletionParameters.ChatFunction(
         name: self.name,
         strict: true, // Set strict to true for consistent behavior
         description: self.description,
         parameters: openAIParameters
      )
      
      return SwiftOpenAI.ChatCompletionParameters.Tool(
         type: "function", // Currently only "function" is supported
         function: chatFunction
      )
   }
   
   /**
    * Converts MCP JSON object to SwiftOpenAI JSONSchema format.
    *
    * This helper function transforms a JSON schema object from MCP format to the
    * corresponding OpenAI format, handling the root schema properties.
    *
    * - Parameter jsonObject: Dictionary containing MCP JSON schema properties
    * - Returns: An equivalent SwiftOpenAI JSONSchema object, or nil if conversion fails
    */
   private func convertToOpenAIJSONSchema(from jsonObject: [String: MCPInterface.JSON.Value]) -> SwiftOpenAI.JSONSchema? {
      // Extract type
      let type: JSONSchemaType?
      if let typeValue = jsonObject["type"] {
         switch typeValue {
         case .string(let typeString):
            switch typeString {
            case "string": type = .string
            case "number": type = .number
            case "integer": type = .integer
            case "boolean": type = .boolean
            case "object": type = .object
            case "array": type = .array
            case "null": type = .null
            default: type = nil
            }
         case .array(let typeArray):
            // Handle union types
            var types: [JSONSchemaType] = []
            for item in typeArray {
               if case .string(let typeString) = item {
                  switch typeString {
                  case "string": types.append(.string)
                  case "number": types.append(.number)
                  case "integer": types.append(.integer)
                  case "boolean": types.append(.boolean)
                  case "object": types.append(.object)
                  case "array": types.append(.array)
                  case "null": types.append(.null)
                  default: continue
                  }
               }
            }
            if !types.isEmpty {
               type = .union(types)
            } else {
               type = nil
            }
         default:
            type = nil
         }
      } else {
         type = nil
      }
      
      // Extract description
      var description: String? = nil
      if let descValue = jsonObject["description"],
         case .string(let descString) = descValue {
         description = descString
      }
      
      // Extract properties
      var properties: [String: SwiftOpenAI.JSONSchema]? = nil
      if let propertiesValue = jsonObject["properties"],
         case .object(let propertiesObject) = propertiesValue {
         properties = [:]
         for (key, value) in propertiesObject {
            if case .object(let propertyObject) = value,
               let property = convertToOpenAIJSONSchema(from: propertyObject) {
               properties?[key] = property
            }
         }
      }
      
      // Extract items for array types
      var items: SwiftOpenAI.JSONSchema? = nil
      if let itemsValue = jsonObject["items"] {
         switch itemsValue {
         case .object(let itemsObject):
            items = convertToOpenAIJSONSchema(from: itemsObject)
         case .array(let itemsArray):
            // Handle array of schemas for tuples
            if let firstItem = itemsArray.first,
               case .object(let firstItemObject) = firstItem {
               items = convertToOpenAIJSONSchema(from: firstItemObject)
            }
         default:
            break
         }
      }
      
      // Extract required fields
      var required: [String]? = nil
      if let requiredValue = jsonObject["required"],
         case .array(let requiredArray) = requiredValue {
         required = []
         for item in requiredArray {
            if case .string(let field) = item {
               required?.append(field)
            }
         }
      }
      
      // Fix for OpenAI's requirement: for strict schemas, include all property keys in required array
      // If we're dealing with an object type and have properties
      if type == .object && properties != nil {
         // Initialize the set of all property keys
         var allPropertyKeys = Set(properties!.keys)
         
         // If we already have some required fields, merge them with our property keys
         if let existingRequired = required {
            let requiredSet = Set(existingRequired)
            allPropertyKeys = allPropertyKeys.union(requiredSet)
         }
         
         // Use the complete set of properties as our required fields
         required = Array(allPropertyKeys)
      }
      
      // Extract additional properties
      var additionalProperties: Bool = false
      if let addPropsValue = jsonObject["additionalProperties"] {
         switch addPropsValue {
         case .bool(let addPropsBool):
            additionalProperties = addPropsBool
         case .object(_):
            // If additionalProperties is an object schema, treat it as true
            additionalProperties = true
         default:
            additionalProperties = false
         }
      }
      
      // Extract enum values
      var enumValues: [String]? = nil
      if let enumValue = jsonObject["enum"],
         case .array(let enumArray) = enumValue {
         enumValues = []
         for item in enumArray {
            switch item {
            case .string(let value):
               enumValues?.append(value)
            case .number(let value):
               enumValues?.append(String(value))
            case .bool(let value):
               enumValues?.append(value ? "true" : "false")
            default:
               continue
            }
         }
      }
      
      // Extract ref
      var ref: String? = nil
      if let refValue = jsonObject["$ref"],
         case .string(let refString) = refValue {
         ref = refString
      }
      
      // Create and return the JSON schema with only the supported parameters
      return SwiftOpenAI.JSONSchema(
         type: type,
         description: description,
         properties: properties,
         items: items,
         required: required,
         additionalProperties: additionalProperties,
         enum: enumValues,
         ref: ref
      )
   }
   
   /**
    * Extracts primitive value from JSON.Value for use in OpenAI schema properties.
    *
    * - Parameter value: The JSON.Value to extract from
    * - Returns: The primitive Swift type corresponding to the JSON value
    */
   private func extractPrimitiveValue(from value: MCPInterface.JSON.Value) -> Any? {
      switch value {
      case .string(let stringValue):
         return stringValue
      case .number(let numberValue):
         return numberValue
      case .bool(let boolValue):
         return boolValue
      case .null:
         return NSNull()
      case .array(let arrayValue):
         return arrayValue.compactMap { extractPrimitiveValue(from: $0) }
      case .object(let objectValue):
         var result: [String: Any] = [:]
         for (key, value) in objectValue {
            if let extractedValue = extractPrimitiveValue(from: value) {
               result[key] = extractedValue
            }
         }
         return result
      }
   }
}

/**
 * Extension for batch conversion of multiple MCP tools to OpenAI tools.
 */
extension Array where Element == MCPInterface.Tool {
   /**
    * Converts an array of MCP interface tools to an array of SwiftOpenAI tools.
    *
    * - Returns: An array of SwiftOpenAI.Tool objects
    */
   public func toOpenAITools() -> [SwiftOpenAI.ChatCompletionParameters.Tool] {
      return self.map { $0.toOpenAITool() }
   }
}
