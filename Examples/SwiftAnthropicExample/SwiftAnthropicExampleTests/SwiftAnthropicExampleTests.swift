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

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSimpleFunctionCall() async throws {
        let msg = MessageParameter(model: .claude2, 
                                   messages: [MessageParameter.Message(role: .user, content: .text("What does the user think about a quote from your favorite art, literature, philosophy, or even a meaningful reflection of your own? Include an attribution, even if you are the author."))],
                                   maxTokens: 4096,
                                   functions: [
                                    MessageParameter.Function(name: "evaluate_quote", description: "submits a quote to the user for evaluation", parameters: [
                                        MessageParameter.Function.Parameter(name: "quote", type: .string, description: "the quote that the user will share their thoughts and feelings on")])],
                                   stopSequences: ["</function_calls>"], temperature: 0.99, topK: 1, topP: 0)
        let response = try await service.createMessage(msg)
        XCTAssertEqual(response.content.first?.functionCalls().first?.0, "evaluate_quote")
        XCTAssertEqual(response.content.first?.functionCalls().first?.1.first?.0, "quote")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
