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
}
