//
//  ErrorResponse.swift
//
//
//  Created by James Rochabrun on 1/28/24.
//

import Foundation

/*
 HTTP errors
 Our API follows a predictable HTTP error code format:

 400 - Invalid request: there was an issue with the format or content of your request.
 401 - Unauthorized: there's an issue with your API key.
 403 - Forbidden: your API key does not have permission to use the specified resource.
 404 - Not found: the requested resource was not found.
 429 - Your account has hit a rate limit.
 500 - An unexpected error has occurred internal to Anthropic's systems.
 529 - Anthropic's API is temporarily overloaded.
 When receiving a streaming response via SSE, it's possible that an error can occur after returning a 200 response, in which case error handling wouldn't follow these standard mechanisms.

 Error shapes
 Errors are always returned as JSON, with a top-level error object that always includes a type and message value. For example:

```JSON

 {
   "type": "error",
   "error": {
     "type": "not_found_error",
     "message": "The requested resource could not be found."
   }
 }
 ```
 
 In accordance with our versioning policy, we may expand the values within these objects, and it is possible that the type values will grow over time.

 Rate limits
 Our rate limits are currently measured in number of concurrent requests across your organization, and will default to 1 while you’re evaluating the API. This means that your organization can make at most 1 request at a time to our API.

 If you exceed the rate limit you will get a 429 error. Once you’re ready to go live we’ll discuss the appropriate rate limit with you.
 */

struct ErrorResponse: Decodable {
   
   let type: String
   let error: Error
   
   struct Error: Decodable {
      
      let type: String
      
      let message: String
   }
}

