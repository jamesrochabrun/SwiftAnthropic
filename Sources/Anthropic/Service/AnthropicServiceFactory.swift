//
//  AnthropicServiceFactory.swift
//
//
//  Created by James Rochabrun on 1/28/24.
//

import Foundation


public final class AnthropicServiceFactory {
   
   /// Creates and returns an instance of `AnthropicService`.
   ///
   /// - Parameters:
   ///   - apiKey: The API key required for authentication.
   ///   - apiVersion: The Anthropic api version. Currently "2023-06-01". (Can be overriden)
   ///   - configuration: The URL session configuration to be used for network calls (default is `.default`).
   ///   - debugEnabled: If `true` service prints event on DEBUG builds, default to `false`.
   ///
   /// - Returns: A fully configured object conforming to `AnthropicService`.
   public static func service(
      apiKey: String,
      apiVersion: String = "2023-06-01",
      basePath: String = "https://api.anthropic.com",
      anthropicBeta: String?,
      configuration: URLSessionConfiguration = .default,
      debugEnabled: Bool = false)
      -> AnthropicService
   {
      DefaultAnthropicService(
         apiKey: apiKey,
         apiVersion: apiVersion, 
         basePath: basePath, 
         betaHeader: anthropicBeta,
         configuration: configuration,
         debugEnabled: debugEnabled)
   }

   /// Creates and returns an instance of `AnthropicService`.
   ///
   /// - Parameters:
   ///   - aiproxyPartialKey: The partial key provided in the 'API Keys' section of the AIProxy dashboard.
   ///                        Please see the integration guide for acquiring your key, at https://www.aiproxy.pro/docs
   ///
   ///   - aiproxyServiceURL: The service URL is displayed in the AIProxy dashboard when you submit your Anthropic key.
   ///
   ///   - aiproxyClientID: If your app already has client or user IDs that you want to annotate AIProxy requests
   ///                      with, you can pass a clientID here. If you do not have existing client or user IDs, leave
   ///                      the `clientID` argument out, and IDs will be generated automatically for you.
   ///
   ///   - apiVersion: The Anthropic api version. Currently "2023-06-01". (Can be overriden)
   ///   - debugEnabled: If `true` service prints event on DEBUG builds, default to `false`.
   ///
   /// - Returns: A conformer of `AnthropicService` that proxies all requests through api.aiproxy.pro
   public static func service(
      aiproxyPartialKey: String,
      aiproxyServiceURL: String,
      aiproxyClientID: String? = nil,
      apiVersion: String = "2023-06-01",
      anthropicBeta: String?,
      debugEnabled: Bool = false)
      -> AnthropicService
   {
      AIProxyService(
         partialKey: aiproxyPartialKey,
         serviceURL: aiproxyServiceURL,
         clientID: aiproxyClientID,
         apiVersion: apiVersion, 
         betaHeader: anthropicBeta,
         debugEnabled: debugEnabled)
   }

}
