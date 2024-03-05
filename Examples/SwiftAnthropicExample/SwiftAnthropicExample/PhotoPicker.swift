//
//  PhotoPicker.swift
//  SwiftAnthropicExample
//
//  Created by James Rochabrun on 3/4/24.
//

import PhotosUI
import SwiftUI

// MARK: PhotoPicker

struct PhotoPicker: View {
   
   @State private var selectedItems: [PhotosPickerItem] = []
   @Binding private var selectedImageURLS: [URL]
   @Binding private var selectedImages: [Image]
   
   init(
      selectedImageURLS: Binding<[URL]>,
      selectedImages: Binding<[Image]>)
   {
      _selectedImageURLS = selectedImageURLS
      _selectedImages = selectedImages
   }
   
   var body: some View {
      PhotosPicker(selection: $selectedItems, matching: .images) {
         Image(systemName: "photo")
      }
      .onChange(of: selectedItems) {
         Task {
            selectedImages.removeAll()
            for item in selectedItems {
               if let data = try? await item.loadTransferable(type: Data.self) {
                  let base64String = data.base64EncodedString()
                  let url = URL(string: "data:image/jpeg;base64,\(base64String)")!
                  selectedImageURLS.append(url)
                  #if canImport(UIKit)
                  if let uiImage = UIImage(data: data) {
                     let image = Image(uiImage: uiImage)
                     selectedImages.append(image)
                  }
                  #elseif canImport(AppKit)
                  if let uiImage = NSImage(data: data) {
                     let image = Image(nsImage: uiImage)
                     selectedImages.append(image)
                  }
                  #endif

               }
            }
         }
      }
   }
}

#Preview {
   PhotoPicker(selectedImageURLS: .constant([]), selectedImages: .constant([Image(systemName: "photo")]))
}
