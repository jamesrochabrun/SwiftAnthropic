//
//  MessageDemoView.swift
//  SwiftAnthropicExample
//
//  Created by James Rochabrun on 2/24/24.
//

import SwiftUI
import PhotosUI
import SwiftAnthropic
import UniformTypeIdentifiers

@MainActor
struct MessageDemoView: View {
   
   let observable: MessageDemoObservable
   @State private var selectedSegment: ChatConfig = .messageStream
   @State private var prompt = ""
   
   @State private var selectedItems: [PhotosPickerItem] = []
   @State private var selectedImages: [Image] = []
   @State private var selectedImagesEncoded: [String] = []
   @State private var showingDocumentPicker = false
   
   enum ChatConfig {
      case message
      case messageStream
   }
   
   var body: some View {
      ScrollView {
         VStack {
            picker
            Text(observable.errorMessage)
               .foregroundColor(.red)
            if let inputTokensCount = observable.inputTokensCount {
               Text("Tokens: \(inputTokensCount)")
            }
            messageView
         }
         .padding()
      }
      .overlay(
         Group {
            if observable.isLoading {
               ProgressView()
            } else {
               EmptyView()
            }
         }
      )
      .safeAreaInset(edge: .bottom) {
         VStack(spacing: 0) {
            selectedImagesView
            if observable.selectedPDF != nil {
               HStack {
                  Image(systemName: "doc.fill")
                  Text("PDF Selected")
                  Button(action: { observable.selectedPDF = nil }) {
                     Image(systemName: "xmark.circle.fill")
                  }
               }
               .padding()
            }
            textArea
         }
      }
      .fileImporter(
         isPresented: $showingDocumentPicker,
         allowedContentTypes: [UTType.pdf],
         allowsMultipleSelection: false
      ) { result in
         switch result {
         case .success(let urls):
            guard let url = urls.first else { return }
            
            do {
               let pdfData = try Data(contentsOf: url)
               // Check size limit (32MB)
               guard pdfData.count <= 32_000_000 else {
                  observable.errorMessage = "PDF exceeds size limit (32MB)"
                  return
               }
               observable.selectedPDF = pdfData
            } catch {
               observable.errorMessage = "Error loading PDF: \(error.localizedDescription)"
            }
         case .failure(let error):
            observable.errorMessage = error.localizedDescription
         }
      }
   }
   
   var textArea: some View {
      HStack(spacing: 4) {
         TextField("Enter prompt", text: $prompt, axis: .vertical)
            .textFieldStyle(.roundedBorder)
            .padding()
         
         Button(action: { showingDocumentPicker = true }) {
            Image(systemName: "doc.badge.plus")
         }
         .buttonStyle(.bordered)
         
         photoPicker
         
         Button {
            Task {
               if observable.selectedPDF != nil {
                  try await observable.analyzePDF(prompt: prompt, selectedSegment: selectedSegment)
               } else {
                  let images: [MessageParameter.Message.Content.ContentObject] = selectedImagesEncoded.map {
                     .image(.init(type: .base64, mediaType: .jpeg, data: $0))
                  }
                  let text: [MessageParameter.Message.Content.ContentObject] = [.text(prompt)]
                  let finalInput = images + text
                  
                  let messages = [MessageParameter.Message(role: .user, content: .list(finalInput))]
                  
                  prompt = ""
                  let parameters = MessageParameter(
                     model: .claude35Sonnet,
                     messages: messages,
                     maxTokens: 1024
                  )
                  
                  // Input Tokens count
                  let messageTokenCountParameter = MessageTokenCountParameter(model: .claude35Sonnet, messages: messages)
                  try await observable.countTokens(parameters: messageTokenCountParameter)
                  
                  switch selectedSegment {
                  case .message:
                     try await observable.createMessage(parameters: parameters)
                  case .messageStream:
                     try await observable.streamMessage(parameters: parameters)
                  }
               }
            }
         } label: {
            Image(systemName: "paperplane")
         }
         .buttonStyle(.bordered)
      }
      .padding()
   }
   
   var picker: some View {
      Picker("Options", selection: $selectedSegment) {
         Text("Message").tag(ChatConfig.message)
         Text("Message Stream").tag(ChatConfig.messageStream)
      }
      .pickerStyle(SegmentedPickerStyle())
      .padding()
   }
   
   var messageView: some View {
      VStack(spacing: 24) {
         HStack {
            Button("Cancel") {
               observable.cancelStream()
            }
            Button("Clear Message") {
               observable.clearMessage()
               selectedImages.removeAll()
               selectedImagesEncoded.removeAll()
               selectedItems.removeAll()
               prompt = ""
            }
         }
         Text(observable.message)
      }
      .buttonStyle(.bordered)
   }
   
   var photoPicker: some View {
      PhotosPicker(selection: $selectedItems, matching: .images) {
         Image(systemName: "photo")
      }
      .onChange(of: selectedItems) {
         Task {
            selectedImages.removeAll()
            selectedImagesEncoded.removeAll()
            for item in selectedItems {
               if let data = try? await item.loadTransferable(type: Data.self) {
                  if let uiImage = UIImage(data: data), let resizedImageData = uiImage.jpegData(compressionQuality: 0.7) {
                     // Make sure the resized image is below the size limit
                     // This is needed as Claude allows a max of 5Mb size per image.
                     if resizedImageData.count < 5_242_880 { // 5 MB in bytes
                        let base64String = resizedImageData.base64EncodedString()
                        selectedImagesEncoded.append(base64String)
                        let image = Image(uiImage: UIImage(data: resizedImageData)!)
                        selectedImages.append(image)
                     } else {
                        observable.errorMessage = "Image exceeds 5MB size limit after compression"
                     }
                  }
               }
            }
         }
      }
   }
   
   var selectedImagesView: some View {
      HStack(spacing: 0) {
         ForEach(0..<selectedImages.count, id: \.self) { i in
            selectedImages[i]
               .resizable()
               .frame(width: 60, height: 60)
               .clipShape(RoundedRectangle(cornerRadius: 12))
               .padding(4)
         }
      }
   }
}


let videoTranscription = """
Hello, my name is Srividya Karumuri and I'm a GPU Compiler Engineer at Apple. Today I'm here to share some tips that can improve the performance of your Metal shaders.

The new Apple Family 9 GPU in M3 and A17 Pro have some new advancements that you could apply to your application. I have some recommendations for Apple Family 9 GPUs. In addition to guidance tips and tricks that apply to all Apple GPU generations.

You can improve your shader's performance by reducing their runtime with features in the Metal shading language, increasing parallelism by improving resource utilization from the shader, and making the most of the ray tracing acceleration hardware in the Apple Family 9 GPUs.

Metal has several features that can minimize the shader's runtime including, function constants, which can efficiently specialize a shader, function groups which can optimize shaders using indirect function calls.

The Metal function constants features specializes the shader efficiently and removes the code that isn't reachable at runtime. For example, uber shaders typically benefit from function constants.

An uber shader is often complex because it can handle many different possibilities at runtime, such as rendering different material types in a 3D application.

Developers sometimes make uber shaders that read material parameters from a buffer and then a material shader chooses different control parts at runtime based on the buffer's contents.

This approach lets the shader render a new material effect without recompiling because the only changes are parameters in the buffer.

For example, this uber shader in a pipeline renders a glossy material because a Metal buffer in the draw command has an is_glossy parameter that's equal to true. The same shader can also render a matte material when the buffer's is_glossy parameter is equal to false.

The render pipeline is the same for both material effects because the behavior change comes from what's in the buffer.

This responsive approach is great during development, however, the shader has to account for several possibilities and read from additional buffers which may affect an app's performance. Another approach is to specialize the shader at compile time instead of at runtime. By building the shader variance offline with preprocessor macros.

This is an uber shader specialized using macros. Each specialized shader has its own render pipeline and only has the code it needs for rendering a specific material effect.

This approach means you have to compile all the possible variant combinations offline. For example, a glossy variant could be the combination of enabling both is_glossy and use_shadows macros, by disabling the remaining macros.

Similarly, a matte function variant could be a combination of the use_shadows and has_reflections macros.

And a glossy reflections variant enables the is_glossy and has_reflections macros and so on.

Implementing an uber shader with macros can mean compiling a large number of variants, such as one variant for each possible macro combination. Some of which your app may never use.

Even if you compile them offline ahead of time, each variant adds up which can significantly increase the size of your Metal library. It can also increase compile time because each shade of variant has to be compiled starting from Metal source.

Function constants can provide another way to specialize the shaders. Compared to using macros, it can reduce both compile time and the size of the Metal library. With function constants, you compile an uber shader one time from source to an intermediate Metal function. From that function, you only create the variance your app needs based on function constants you define.

Function constants give you the flexibility to both create multiple specialized variants on the go as needed and reuse an intermediate Metal function for all remaining possibilities.

With this approach, you can save time and space by creating only the shader variance and render pipelines you need.

You can create these specialized variance by declaring function constants in your Metal function code and then defining each of their values as you create Metal functions.

You can also use function constants to initialize program scope variables that you declare in the constant address space.

You can enable different code parts in the shader with these function constants instead of reading values from Metal buffers.

With function constants, Metal can fold these as constant Booleans as it compiles the shader's specialization variant, as well as other optimizations, such as eliminating unreachable code parts.

And that can remove unused control flow.

By specializing shader with function constants, you don't need to query material parameters from buffers anymore. This approach reduces the shaders runtime by simplifying its control flow and removing unused code parts. I encourage you to watch, "Optimize GPU renders with Metal," which goes over the details on how to set function constant values at runtime. It also goes over how to mitigate the runtime compilation overhead with a synchronous compilation.

You can also reduce your shaders runtime by adding the function group's attribute for indirect function calls.

An indirect function is a function the shader calls without directly invoking by its name, such as with function pointers or visible function tables. A shader can call an indirect function through static or dynamic linking, indirect function calls make the code extensible and give your app more options for flexibility. However, indirect function calls can prevent Metal from fully optimizing the shader, especially around the call site.

For statically linked functions, you can use the Metal function group's feature, which lets Metal optimize the shader with indirect function calls.

This shader invokes three different indirect functions including calls through function pointers for lighting, and a material. Metal can't optimize across these function pointer call sites because it has no visibility which functions the shader is calling. However, when you know that the function pointers can only point to one of the specific group of functions, you can use the function group's attribute. For example, the only functions the shader could call are all the linked functions in the shaders pipeline state, and you may know that the lighting function can only invoke the area, spot or sphere functions. In that case, you can group these functions into your lighting function group. Similarly, if the material function pointer can only invoke the wood, glass or metal functions, then you can group them into your material function group. You can give Metal a hint on how to optimize an indirect call by adding the function group's attribute at the call site.

You define the function groups by assigning a dictionary to a linked functions group's property. Each dictionary entry is a string key, which is the name of the function group, and the value is an area of functions that belong to that group. Note that this approach only helps for functions that you statically link, functions you compile to a binary library will not benefit from this.

Check out these two videos to learn more about the Metal function pointers and the various compilation workflows.

In summary, two ways to reduce a shader's runtime are function constants, which can create a specialized variant of the shader efficiently, and function groups that can optimize the shader where it invokes indirect functions.

Having looked at some Metal features that can reduce the shader's execution time, let's see some ways to improve the resource utilization leading to increased parallelism.

Increasing the thread occupancy is very important to improve latency hiding in shader execution. Thread occupancy really depends on the amount of available resources, be it registers or memory. So optimized usage of data from the shader can increase thread occupancy. Apple Family 9 GPUs have new advancements related to occupancy management. For more details, please check out, "Explore GPU advancements in M3 and A17 Pro." And to learn how to triage the lower thread occupancy bottlenecks, please check out, "Discover new Metal profiling tools for M3 and A17 Pro." The address space of memory objects and the data type used in ALU operations can impact the resource utilization.

Choosing the right address space for a memory object is very important for better memory utilization and to improve the thread occupancy.

In Metal shading language, address spaces are designed to support different access patterns and to specify the region of memory from where memory objects are allocated.

Picking the right address space will directly impact the performance of shaders. We are going to focus our attention on constant device and threadgroup address spaces. Constant address space allows you to create memory objects that are read only.

These accesses are optimized for data that is constant across all thread software dispatch or draw.

If the size of the object is fixed, and if the object is read many times by different threads, then create those objects in constant address space.

You can create read/write buffers in device address space. If the data being accessed is varying across the threads or if the size of the buffer is not fixed, then you can create such buffers in device address space.

Check out, "Optimize Metal Performance for Apple silicon Macs," for more details on constant and device address space recommendations with examples.

Threadgroup address space is for read/write memory objects too. Threads in the threadgroup can work together by sharing data in the threadgroup memory.

They're often faster in most cases.

In some use cases, threadgroup memory is used as a software-managed cache of device or constant buffers. For example, blocks of device memory are copied into threadgroup memory to operate with. It can be faster in some cases.

With the new advancements in Apple Family 9 GPUs shader code memory, the trade-offs on when to use threadgroup memory might be different from prior GPUs.

In your shader, if the use of threadgroup memory is primarily to use as a software-managed cache of device or constant buffers, then it may be more performant to read directly from those buffers instead of copying to threadgroup memory.

With Apple Family 9 GPUs dynamic shader core memory and flexible on-chip memory features, threadgroup device constant memory types are using the same cache hierarchy, so if your working set size fits in the cache, then both the buffer and threadgroup memory access might have similar performance characteristics. In those cases, instead of creating copies of memory in threadgroup and device or constant address space, shader can just operate with the device or constant buffers and avoid the latencies involved with copying to threadgroup memory.

Additional guidance on whether keeping the data just in device or constant buffers is beneficial or not, can be evaluated by profiling the workload using Metal debugger in Xcode.

Similar to address-based selection, data type can impact the performance too. For instance, 16-bit data types can help reduce the register and memory footprint.

Using 16-bit data types such as half and short over float and int when possible allows better performance. Conversions are free, so don't worry about converting between types such as between half and float. Bfloat is a 16-bit truncated version of float best suited for accelerating machine learning applications.

It allows wide range of values at a lower precision Bfloat data type has been supported since Metal 3.1. If your application has precision requirements that match with what is supported by bfloat, it is highly recommended to use this data type.

Using 16-bit data types rather than 32-bit data types results in shader using fewer registers. If that data is stored in memory, it can also help reduce the memory footprint and improve bandwidth. As a result, it can lead to better thread occupancy. Using 16-bit data types also improves the energy efficiency.

When writing expressions that are meant to be evaluated at half decision, be sure to use 'h' suffix on any literals. Otherwise, the entire expression will be evaluated at a float precision and that will lose the benefits of using smaller types.

In some shaders, it can result in better instruction mix by using half type, such as having a mix of float, half and int type instructions. This can result in better utilization of ALU pipelines in Apple Family 9 GPU, and it can improve the instruction throughput.

To summarize, improve resource utilization by choosing the right address space based on the memory usage pattern. Choosing 16-bit data types can help reduce the register and memory footprint and in some cases it can result in better utilization of the ALU parallelism in Apple Family 9 GPUs. For ray tracing shaders too, it is important to reduce shader execution time and improve resource utilization in order to improve the performance.

To render with Metal ray tracing, the first step is to define your scene geometry and build an acceleration structure to allow efficient intersection.

Intersection is performed from a GPU function that creates a ray. This GPU function makes an intersector object to perform intersection. The result returned from intersection will have all the information you may need to either shade the pixel or process it further.

The intersector component of this process is hardware accelerated on Apple Family 9 GPUs.

The hardware intersector is responsible for traversing the acceleration structure, invoking intersection functions and updating the state of the traversal based upon the result of intersection. The intersector is the fundamental API for Metal ray tracing. Using intersection functions, ray payload, intersection tags and the intersection in optimal way can improve the ray tracing performance.

Custom intersection functions are a powerful way to define how rays hit surfaces, but use custom intersection functions only when necessary.

Custom intersection functions are important for implementing features like alpha testing. Alpha testing is used to add more geometric detail to the scene, like in the chains and leaves from this image. Alpha testing is implemented by using a custom intersection function.

The logic inside custom intersection functions is responsible for accepting or rejecting intersections as the ray traverses the acceleration structure.

In this case, the custom intersection function logic will reject the first intersection, but it will accept the second intersection since an opaque surface has been intersected.

Custom intersection functions can enable additional logic to be executed on the shader course. Use it only when necessary. The opaque triangle intersectors are the fastest path.

If you need custom intersection functions, note that the hardware will be sorting and grouping by intersection function. Having a lot of intersection functions will make it harder to find matches and group, so avoid duplicate intersection functions to help in grouping optimally.

And take advantage of the Metal intersection function table indexing mechanism to create simple tables with one entry per function.

To run the intersection test, the hardware intersection creates SIMDgroup for multiple rays and then each ray is tested against multiple primitives in parallel.

Since the custom intersection functions are running in parallel, they will need to be serialized if they perform any operation that has side effects. This includes memory writes to the payload or other device memory. Similarly, any operations that introduce divergence such as indirect function calls will also reduce the parallelism of the intersection function execution. It's best to perform these operations as late as possible in the intersection function to allow maximum parallelism until that point.

In this example, ray payload is updated first and then some work unrelated to the payload update is performed.

This will cause all the code after payload update to be run serially. Instead, you can modify the intersection function to have all the work unrelated to the payload update to be done first and then update the payload. This will maximize the intersection function parallelism.

Returning to the hardware intersector model, this flow chart explains the process, but it is overlooking one vital element.

During intersection, ray trace scratch space is used to store the state of the traversal and return results to the GPU function calling intersect.

The intersector API supports a payload for each ray. The larger the payload structure is the more impact it will have on ray tracing performance.

When it comes to ray payload, the intersection result may have most of the data you need and it is best to avoid using any ray payload. If you need a payload, avoid a global uber payload structure. Instead, specialize the structure for each intersect call.

Minimize the size of the structure with packed data types and remove any fields that are not needed. Optimizing ray payload usage will result in more rays being processed. For example, consider a basic payload with the intersection position, a flag to indicate a hit, and a color. In memory, the fields would be laid out like this.

The position member would be at the start and due to its size and alignment, the hit flag would be 16 bytes from the start, but then the RGB member is at a byte offset of 32, making an overall struct size of 48 bytes.

By changing the flow three values to their packed equivalence, there is less space lost to alignment. The hit flag can be removed since it is not needed when using the Metal ray tracing API, you can just check the type of intersection in the intersection result. This is easy to use and more performant, especially for visibility rays like shadows and occlusion. Similarly, the position can be computer-based on the ray's origin, direction and the intersection distance from the result.

And then to reduce the size further, the RGB color can be packed to four bytes in the intersection function using the packing methods in Metal shading language.

In this example, ray data payload structure started off with the size of 48 bytes and reduced to four bytes. By using such methods, you can optimize your array payload to improve the rate tracing performance.

Like ray payload, intersection tags also affect ray tracing performance in a similar way.

Another contributor to ray tracing scratch usage is the intersection tags on the intersector. These tags are the additional state for the traversal to track. The world space data tag in this declaration means that the object to world and world to object matrices have to be stored for each ray. This adds to the retracing scratch usage and will impact occupancy during the intersect call.

The other important thing to note with the tags is that they need to match between the intersector and the intersection functions that it calls.

Intersector is better than intersection query because of how the intersection query API impacts the ray tracing performance.

Looking at the hardware intersector model, it is a great fit for the intersector in the shading language. An intersection query defines an object that does not use custom intersection functions. The intersection code is executed in the original GPU function and the hardware intersector needs to wait until the code completes before continuing the traversal.

If you choose to use intersection query, the hardware has no custom intersection functions to sort and cannot group the execution. It also needs to use more ray tracing scratch memory to allow it to return to the GPU function.

Intersection query is the alternative model for ray intersection to support portability from other shading languages. Since intersector aligns with the hardware implementation, prefer intersector over intersection query.

If you do need to use intersection query, use as few query objects as possible. If multiple intersection queries are necessary, try to reuse the query object, but change the properties. This enables reuse of the ray tracing scratch for one query. For example, if you have an intersection query object IQ1 for doing some ray tracing work, and then if you need to do more ray tracing work with the opaque opacity set, then instead of creating new intersection query object, simply use the intersection params to reset the existing intersection query object with opaque opacity.

This way you can reuse the ray tracing scratch memory.

When using multiple intersection queries, avoid switching between them and overlapping their traversal. This avoids expensive swaps between the in-progress hardware traversals.

For example, in your ray tracing work, instead of switching from IQ1 to IQ2 and then back to IQ1. Continue with IQ1 and complete the ray tracing work with it before switching to IQ2. To summarize ray tracing best practices, use custom intersection function only when necessary. Optimize ray payload.

Minimize the number of intersection tags.

Use intersector over intersection query. To learn more about ray tracing with Metal, please watch, "Your guide to Metal ray tracing." And to learn how to use new ray tracing counters from Metal debugger in Xcode, check out, "Discover new Metal profiling tools for M3 and A17 Pro." To recap, in order to improve performance of your Metal shaders, you can reduce shader execution time by using Metal features like function constants and function groups. Using such features can enable more optimization opportunities in Metal, improve thread occupancy with better resource utilization to increase parallelism.

Apply the best practices for intersection function, ray payload, intersection tags, and the intersector to make the best use of the hardware accelerated ray tracing. Thank you very much.
"""


