// swiftlint:disable no_direct_standard_out_logs

//
//  GithubMCPClient.swift
//  MCPClientChat
//
//  Created by James Rochabrun on 3/3/25.
//

import Foundation
import MCPClient
import SwiftUI

final class GIthubMCPClient {
   
   private var client: MCPClient?
   private let clientInitialized = AsyncStream.makeStream(of: MCPClient?.self)
   
   init() {
      Task {
         do {
            self.client = try await MCPClient(
               info: .init(name: "GIthubMCPClient", version: "1.0.0"),
               transport: .stdioProcess(
                  "npx",
                  args: ["-y", "@modelcontextprotocol/server-github"],
                  verbose: true
               ),
               capabilities: .init()
            )
            clientInitialized.continuation.yield(self.client)
            clientInitialized.continuation.finish()
         } catch {
            print("Failed to initialize MCPClient: \(error)")
            clientInitialized.continuation.yield(nil)
            clientInitialized.continuation.finish()
         }
      }
   }

   // Modern async/await approach
   func getClientAsync() async throws -> MCPClient? {
      for await client in clientInitialized.stream {
         return client
      }
      return nil  // Stream completed without a client
   }
}
