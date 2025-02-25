//
//  OptionsListView.swift
//  SwiftAnthropicExample
//
//  Created by James Rochabrun on 2/24/24.
//

import Foundation
import SwiftAnthropic
import SwiftUI

struct OptionsListView: View {
   
   let service: AnthropicService
   
   @State private var selection: APIOption? = nil
   
   /// https://docs.anthropic.com/claude/reference/getting-started-with-the-api
   enum APIOption: String, CaseIterable, Identifiable {
      
      case message = "Message"
      case messageFunctionCall = "Function Call"
      case thinking = "Thinking Mode"

      var id: Self { self }
   }

   var body: some View {
      List(APIOption.allCases, id: \.self, selection: $selection) { option in
         Text(option.rawValue)
      }
      .sheet(item: $selection) { selection in
         VStack {
            Text(selection.rawValue)
               .font(.largeTitle)
               .padding()
            switch selection {
            case .message:
               MessageDemoView(observable: .init(service: service))
            case .messageFunctionCall:
               MessageFunctionCallingDemoView(observable: .init(service: service))
            case .thinking:
               ThinkingModeMessageDemoView(observable: .init(service: service))
                                           
            }
         }
      }
   }
}
