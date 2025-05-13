//
//  MessageParameter+Web.swift
//  SwiftAnthropic
//
//  Created by James Rochabrun on 5/12/25.
//

import Foundation

public extension MessageParameter {
   
   /// Creates a web search tool with default configuration
   static func webSearch(
      name: String = "web_search",
      maxUses: Int? = nil
   ) -> Tool {
      let parameters = WebSearchParameters(maxUses: maxUses)
      return .webSearch(name: name, parameters: parameters)
   }
   
   /// Creates a web search tool with domain filtering
   static func webSearch(
      name: String = "web_search",
      maxUses: Int? = nil,
      allowedDomains: [String]? = nil,
      blockedDomains: [String]? = nil
   ) -> Tool {
      let parameters = WebSearchParameters(
         maxUses: maxUses,
         allowedDomains: allowedDomains,
         blockedDomains: blockedDomains
      )
      return .webSearch(name: name, parameters: parameters)
   }
   
   /// Creates a web search tool with user location for localized results
   static func webSearch(
      name: String = "web_search",
      maxUses: Int? = nil,
      userLocation: UserLocation
   ) -> Tool {
      let parameters = WebSearchParameters(
         maxUses: maxUses,
         userLocation: userLocation
      )
      return .webSearch(name: name, parameters: parameters)
   }
   
   /// Creates a web search tool with full configuration
   static func webSearch(
      name: String = "web_search",
      maxUses: Int? = nil,
      allowedDomains: [String]? = nil,
      blockedDomains: [String]? = nil,
      userLocation: UserLocation? = nil
   ) -> Tool {
      let parameters = WebSearchParameters(
         maxUses: maxUses,
         allowedDomains: allowedDomains,
         blockedDomains: blockedDomains,
         userLocation: userLocation
      )
      return .webSearch(name: name, parameters: parameters)
   }
   
   /// Creates a location for a US city
   static func usCity(
      city: String,
      region: String,
      timezone: String
   ) -> UserLocation {
      return UserLocation(
         type: .approximate,
         city: city,
         region: region,
         country: "US",
         timezone: timezone
      )
   }
}

public extension MessageParameter.UserLocation {
   
   /// Common US locations
   static let sanFrancisco = Self(
      type: .approximate,
      city: "San Francisco",
      region: "California",
      country: "US",
      timezone: "America/Los_Angeles"
   )
   
   static let newYork = Self(
      type: .approximate,
      city: "New York",
      region: "New York",
      country: "US",
      timezone: "America/New_York"
   )
   
   static let chicago = Self(
      type: .approximate,
      city: "Chicago",
      region: "Illinois",
      country: "US",
      timezone: "America/Chicago"
   )
}
