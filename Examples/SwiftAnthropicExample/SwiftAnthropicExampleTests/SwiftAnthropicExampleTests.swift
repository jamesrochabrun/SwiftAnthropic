//
//  SwiftAnthropicExampleTests.swift
//  SwiftAnthropicExampleTests
//
//  Created by James Rochabrun on 2/24/24.
//

import XCTest
@testable import SwiftAnthropicExample
import SwiftAnthropic

final class SwiftAnthropicExampleTests: XCTestCase {
    private var service : AnthropicService = AnthropicServiceFactory.service(apiKey: "TODO friendly key inclusion")

    func testSimpleFunctionCall() async throws {
        // TODO this belongs in the package's test target, but i haven't been able to figure out
        // how to get xcode to actually run that target from this (example) project
        let msg = MessageParameter(model: .claude2,
                                   messages: [MessageParameter.Message(role: .user, content: .text("What does the user think about an excerpt from your favorite myth or fable?"))],
                                   maxTokens: 4096,
                                   functions: [
                                    MessageParameter.Function(name: "consider_excerpt", description: "submits an excerpt to the user for reflection", parameters: [
                                        MessageParameter.Function.Parameter(name: "excerpt", type: .string, description: "the text that the user will reflect on")])],
                                   temperature: 0.99, topK: 1, topP: 0)
        
        let response = try await service.createMessage(msg)

        guard let (funcName, paramsJSONData) = try response.content.first?.functionCallsJSON().first else {
            return XCTFail("unexpected response")
        }

        XCTAssertEqual(funcName, "consider_excerpt")
        
        struct ConsiderExcerptResult: Decodable {
            let excerpt: String
        }

        let result = try JSONDecoder().decode(ConsiderExcerptResult.self, from: paramsJSONData)
        XCTAssertNotNil(result.excerpt)
    }
}
