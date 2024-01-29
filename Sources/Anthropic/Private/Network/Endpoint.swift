//
//  Endpoint.swift
//
//
//  Created by James Rochabrun on 1/28/24.
//

import Foundation

// MARK: HTTPMethod

enum HTTPMethod: String {
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

   private func urlComponents(
      queryItems: [URLQueryItem])
      -> URLComponents
   {
      var components = URLComponents(string: base)!
      components.path = path
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
      beta: String? = nil,
      queryItems: [URLQueryItem] = [])
      throws -> URLRequest
   {
      var request = URLRequest(url: urlComponents(queryItems: queryItems).url!)
      request.addValue("application/json", forHTTPHeaderField: "Content-Type")
      request.addValue("\(apiKey)", forHTTPHeaderField: "x-api-key")
      request.addValue("\(version)", forHTTPHeaderField: "anthropic-version")
      if let beta {
         request.addValue("\(beta)", forHTTPHeaderField: "anthropic-beta")
      }
      request.httpMethod = method.rawValue
      if let params {
         request.httpBody = try JSONEncoder().encode(params)
      }
      return request
   }
}
