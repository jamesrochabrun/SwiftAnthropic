//
//  Endpoint.swift
//
//
//  Created by James Rochabrun on 1/28/24.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

// MARK: HTTPMethod

public enum HTTPMethod: String {
  case post = "POST"
  case get = "GET"
  case delete = "DELETE"
}

// MARK: Endpoint

protocol Endpoint {
  
  var base: String { get }
  var path: String { get }
}

// MARK: Endpoint+Requests

extension Endpoint {
  
  func urlComponents(
    queryItems: [URLQueryItem])
  -> URLComponents
  {
    var components = URLComponents(string: base)!
    components.path = components.path.appending(path)
    if !queryItems.isEmpty {
      components.queryItems = queryItems
    }
    return components
  }
  
  /*
   curl -X POST https://api.anthropic.com/v1/messages \
   --header "x-api-key: $ANTHROPIC_API_KEY" \
   --header "anthropic-version: 2023-06-01" \
   --header "anthropic-beta: messages-2023-12-15" \
   --header "content-type: application/json" \
   --data \
   '{
   "model": "claude-2.1",
   "max_tokens": 1024,
   "messages": [
   {"role": "user", "content": "Hello, Claude"}
   ]
   }'
   */
  func request(
    apiKey: String,
    version: String,
    method: HTTPMethod,
    params: Encodable? = nil,
    betaHeaders: [String]? = nil,
    queryItems: [URLQueryItem] = [])
  throws -> URLRequest
  {
    var request = URLRequest(url: urlComponents(queryItems: queryItems).url!)
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("\(apiKey)", forHTTPHeaderField: "x-api-key")
    request.addValue("\(version)", forHTTPHeaderField: "anthropic-version")
    if let betaHeaders {
      request.addValue("\(betaHeaders.joined(separator: ","))", forHTTPHeaderField: "anthropic-beta")
    }
    request.httpMethod = method.rawValue
    if let params {
      let encoder = JSONEncoder()
      encoder.keyEncodingStrategy = .convertToSnakeCase
      request.httpBody = try encoder.encode(params)
    }
    return request
  }

  /// Creates a multipart/form-data request for uploading skill files.
  ///
  /// This method is used for Skills API endpoints that require file uploads.
  func multipartRequest(
    apiKey: String,
    version: String,
    method: HTTPMethod,
    displayTitle: String?,
    files: [SkillFile],
    betaHeaders: [String]? = nil,
    queryItems: [URLQueryItem] = [])
  throws -> URLRequest
  {
    let boundary = "Boundary-\(UUID().uuidString)"
    var request = URLRequest(url: urlComponents(queryItems: queryItems).url!)
    request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
    request.addValue("\(apiKey)", forHTTPHeaderField: "x-api-key")
    request.addValue("\(version)", forHTTPHeaderField: "anthropic-version")
    if let betaHeaders {
      request.addValue("\(betaHeaders.joined(separator: ","))", forHTTPHeaderField: "anthropic-beta")
    }
    request.httpMethod = method.rawValue

    // Build multipart body
    var body = Data()

    // Add display_title if provided
    if let displayTitle = displayTitle {
      body.append("--\(boundary)\r\n".data(using: .utf8)!)
      body.append("Content-Disposition: form-data; name=\"display_title\"\r\n\r\n".data(using: .utf8)!)
      body.append("\(displayTitle)\r\n".data(using: .utf8)!)
    }

    // Add files
    for file in files {
      body.append("--\(boundary)\r\n".data(using: .utf8)!)

      // Format: files[]=@path/to/file;filename=skill_name/SKILL.md
      let contentDisposition = "Content-Disposition: form-data; name=\"files[]\"; filename=\"\(file.filename)\"\r\n"
      body.append(contentDisposition.data(using: .utf8)!)

      if let mimeType = file.mimeType {
        body.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
      } else {
        body.append("\r\n".data(using: .utf8)!)
      }

      body.append(file.data)
      body.append("\r\n".data(using: .utf8)!)
    }

    // Close boundary
    body.append("--\(boundary)--\r\n".data(using: .utf8)!)

    request.httpBody = body
    return request
  }
}
