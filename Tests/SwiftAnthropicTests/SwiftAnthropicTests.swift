import XCTest
@testable import SwiftAnthropic

final class SwiftAnthropicTests: XCTestCase {
    func testEndpointConstruction() throws {
       let endpoint = AnthropicAPI(
         base: "https://api.example.org/my/path",
         apiPath: .messages
       )
       let comp = endpoint.urlComponents(
         queryItems: [URLQueryItem(name: "query", value: "value")]
       )
       XCTAssertEqual(
         "https://api.example.org/my/path/v1/messages?query=value",
         comp.url!.absoluteString
       )
    }

    func testRequestSetsUserAgentHeader() throws {
       let endpoint = AnthropicAPI(
         base: "https://api.example.org",
         apiPath: .messages
       )
       let request = try endpoint.request(
         apiKey: "test-key",
         version: "2023-06-01",
         method: .post
       )
       XCTAssertEqual(
         request.value(forHTTPHeaderField: "User-Agent"),
         "SwiftAnthropic"
       )
    }

    func testMultipartRequestSetsUserAgentHeader() throws {
       let endpoint = AnthropicAPI(
         base: "https://api.example.org",
         apiPath: .skills
       )
       let file = SkillFile(
         filename: "test/SKILL.md",
         data: "# Test".data(using: .utf8)!,
         mimeType: "text/markdown"
       )
       let request = try endpoint.multipartRequest(
         apiKey: "test-key",
         version: "2023-06-01",
         method: .post,
         displayTitle: "Test Skill",
         files: [file]
       )
       XCTAssertEqual(
         request.value(forHTTPHeaderField: "User-Agent"),
         "SwiftAnthropic"
       )
    }
}
