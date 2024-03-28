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
    private var service : AnthropicService = AnthropicServiceFactory.service(apiKey: "TODO friendly API key inclusion")

    func testSimpleFunctionCall() async throws {
        // TODO
        // this belongs in the package's test target, but i haven't been able to figure out how to get xcode to actually run that target from this (example) project
        let msg = MessageParameter(model: .claude2,
                                   messages: [MessageParameter.Message(role: .user, content: .text("What does the user think about an excerpt from your favorite myth or fable?"))],
                                   maxTokens: 4096,
                                   functions: [
                                    MessageParameter.Function(name: "consider_excerpt", description: "submits an excerpt to the user for reflection", parameters: [
                                        MessageParameter.Function.Parameter(name: "excerpt", type: .string, description: "the text that the user will reflect on")])],
                                   stopSequences: nil, temperature: 0.99, topK: 1, topP: 0)
        let response = try await service.createMessage(msg)
        XCTAssertEqual(response.content.first?.functionCalls().first?.0, "consider_excerpt")
        XCTAssertEqual(response.content.first?.functionCalls().first?.1.first?.0, "excerpt")
    }
}
