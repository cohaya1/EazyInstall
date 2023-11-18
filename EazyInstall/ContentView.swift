//
//  ContentView.swift
//  EazyInstall
//
//  Created by Chika Ohaya on 10/9/23.
//

import SwiftUI
import VisionKit
import Vision

struct ScanningView: UIViewControllerRepresentable {
    @EnvironmentObject var scannerViewModel: ScannerViewModel
    
    class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate {
        var parent: ScanningView
        
        init(parent: ScanningView) {
            self.parent = parent
        }
        
        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
            for pageNumber in 0..<scan.pageCount {
                let image = scan.imageOfPage(at: pageNumber)
                Task {
                    await parent.scannerViewModel.recognizeText(from: image)
                }
            }
            controller.dismiss(animated: true)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> VNDocumentCameraViewController {
        let documentCameraViewController = VNDocumentCameraViewController()
        documentCameraViewController.delegate = context.coordinator
        return documentCameraViewController
    }
    
    func updateUIViewController(_ uiViewController: VNDocumentCameraViewController, context: Context) {}
}

struct AnimatedBackgroundView: View {
    @State private var scale = 1.0
    var imageName: String

    let timer = Timer.publish(every: 10, on: .main, in: .common).autoconnect()

    var body: some View {
        GeometryReader { geometry in
            Image(imageName)
                .resizable()
                .scaledToFill()
                .scaleEffect(scale)
                .frame(width: geometry.size.width, height: geometry.size.height)
                .clipped()
                .overlay(
                    LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0.3), Color.white.opacity(0.7)]), startPoint: .top, endPoint: .bottom)
                )
               // .edgesIgnoringSafeArea(.bottom)
                .onReceive(timer) { _ in
                    withAnimation(.easeInOut(duration: 10)) {
                        // Slowly zoom in and out the background image
                        scale = scale == 1.0 ? 1.05 : 1.0
                    }
                }
                .onDisappear {
                    timer.upstream.connect().cancel()
                }
        }
    }
}

struct ContentView: View {
    @StateObject private var scannerViewModel = ScannerViewModel()
    @StateObject private var userManualViewModel = UserManualViewModel()
    @State private var isScanning = false
    @StateObject private var cacheViewModel = CacheViewModel()
    @State private var originalRecognizedText: String = ""
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    var body: some View {
            NavigationView {
                ZStack {
                    AnimatedBackgroundView(imageName: "background2") // Background

                    ScrollView {
                        VStack(spacing: 20) {
                            MoreInfo(recognizedText: $originalRecognizedText, userManualViewModel: userManualViewModel)

                            if userManualViewModel.isLoading && userManualViewModel.userManual.isEmpty {
                                ProgressView()
                            }

                            Directions(userManualText: $userManualViewModel.userManual, recognizedText: $scannerViewModel.recognizedText)
                                .padding(.top, 10)

                            List(scannerViewModel.keywords, id: \.self) { keyword in
                                Text(keyword)
                            }
                        }
                        .padding(.horizontal, horizontalSizeClass == .compact ? 10 : 20) // Adjust padding based on size class
                    }
                    .frame(maxWidth: .infinity) // Ensure the ScrollView takes the full width

                    VStack {
                        Spacer()
                        Button(action: {
                            isScanning = true
                        }) {
                            Scan()
                        }
                        .sheet(isPresented: $isScanning) {
                            ScanningView()
                                .environmentObject(scannerViewModel)
                        }
                        .onChange(of: scannerViewModel.recognizedText) { newText in
                            if !newText.isEmpty {
                                originalRecognizedText = newText
                                cacheViewModel.cacheDocument(newText)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                    .edgesIgnoringSafeArea(.bottom) // To ensure it's above any home indicator
                }
            }
            .navigationViewStyle(StackNavigationViewStyle()) // Better for adapting to different screen sizes
        }
    }


import SwiftUI

struct MoreInfo: View {
    
    @Binding var recognizedText: String
    @ObservedObject var userManualViewModel: UserManualViewModel
    @State private var selectedLanguage: String = ""
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) { // Adjust spacing as needed
                // Button for generating a low literacy manual
              
                Button(action: {
                    Task {
                        await userManualViewModel.generateLowLiteracyManual(withText: recognizedText)
                    }
                }) {
                    Text("High School")
                        .font(Font.custom("Roboto", size: 12))
                        .foregroundColor(Color(red: 1, green: 0.25, blue: 0.25))
                }
                .buttonStyle(FloatingButtonStyle())
                
                // Text field for entering language
                TextField("Language", text: $selectedLanguage)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 85, height: 30)
                    .autocapitalization(.none)
                    .disabled(recognizedText.isEmpty) // Disable if there is no text
                
                // Button for generating translated manual
                Button(action: {
                    Task {
                        await userManualViewModel.generateTranslatedManual(forLanguage: selectedLanguage, withText: recognizedText)
                    }
                }) {
                    Text("Change Language")
                        .font(Font.custom("Roboto", size: 12))
                        .foregroundColor(Color(red: 1, green: 0.25, blue: 0.25))
                }
                .buttonStyle(FloatingButtonStyle())
                .disabled(selectedLanguage.isEmpty || recognizedText.isEmpty) // Disable if no language or text
                
                // Button for generating a general user manual
                Button(action: {
                    Task {
                        await userManualViewModel.generateUserManual(forUserType: .general, withText: recognizedText)
                    }
                }) {
                    Text("Easy")
                        .font(Font.custom("Roboto", size: 12))
                        .foregroundColor(Color(red: 1, green: 0.25, blue: 0.25))
                }
                .buttonStyle(FloatingButtonStyle())
                
                // Additional elements and buttons can be added here with their respective actions
                // ...
                
            }
            .frame(height: 38)
            // Apply padding or adjust frame width as necessary to control the ScrollView size
        }
    }
}

struct FloatingButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(10)
            .background(Color.white)
            .clipShape(Capsule()) // Creates an oval shape for the button
            .overlay(
                Capsule()
                    .stroke(Color(red: 1, green: 0.25, blue: 0.25), lineWidth: 1)
            )
            .shadow(color: .gray, radius: 2, x: 0, y: 2)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

// Remember to add your own UserManualViewModel class or struct here


// Remember to add your own UserManualViewModel class or struct here

struct Scan: View {
  var body: some View {
    ZStack() {
        Image("cross")
      Ellipse()
        .foregroundColor(.clear)
        .frame(width: 29, height: 28)
        .overlay(
          Ellipse()
            .inset(by: 0.50)
            .stroke(Color(red: 0.37, green: 0.37, blue: 0.38), lineWidth: 0.50)
        )
        .offset(x: 0, y: 0)
        .shadow(
          color: Color(red: 1, green: 1, blue: 1, opacity: 0.40), radius: 10
        )
      HStack(spacing: 0) {

      }
      .frame(width: 13.46, height: 13)
      .offset(x: 0.12, y: 0.12)
    }
    .frame(width: 29, height: 28);
  }
}
struct Directions: View {
    @State private var appear = false
    @Binding var userManualText: String
    @Binding var recognizedText: String
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
        @Environment(\.verticalSizeClass) var verticalSizeClass
    var body: some View {
        ZStack {
            // Rectangle background
            // Rectangle background with dynamic sizing
                       let width = horizontalSizeClass == .regular ? 500 : 341.67
                       let height = verticalSizeClass == .regular ? 700 : 588 as CGFloat

            Rectangle()
                .fill(LinearGradient(gradient: Gradient(colors: [Color.white.opacity(0.7), Color.white.opacity(0.5)]), startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width: width, height: height)
                .cornerRadius(20)
                .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(LinearGradient(gradient: Gradient(colors: [Color.white, Color.white.opacity(0)]), startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 1)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .shadow(color: Color.black.opacity(appear ? 0.2 : 0), radius: 10, x: 5, y: 5)
                        .blur(radius: appear ? 4 : 0)
                )
                .scaleEffect(appear ? 1 : 0.95)
                .opacity(appear ? 1 : 0)
                .animation(.easeOut(duration: 0.8), value: appear)
                .onAppear {
                    self.appear = true
                }

            // Scrollable text
                     ScrollView {
                         if !userManualText.isEmpty {
                             Text(userManualText)
                                 .foregroundColor(.white)
                                 .padding()
                                 .frame(maxWidth: width, alignment: .leading)
                         } else if !recognizedText.isEmpty {
                             VStack(alignment: .leading, spacing: 12) {
                                 ForEach(recognizedText.split(separator: "\n"), id: \.self) { paragraph in
                                     Text(paragraph)
                                         .foregroundColor(.white)
                                         .fixedSize(horizontal: false, vertical: true)
                                 }
                             }
                             .padding()
                             .frame(maxWidth: width, alignment: .leading)
                         }
                     }
                     .frame(width: width, height: height)
                     .cornerRadius(20)
                 }
             }
         }





struct ManualOptionsView: View {
    @Binding var recognizedText: String
    @ObservedObject var userManualViewModel: UserManualViewModel
    @State private var selectedLanguage: String = ""
  
    var body: some View {
        VStack(spacing: 20) {
            Button(action: {
                Task {
                    await userManualViewModel.generateUserManual(forUserType:.general, withText: recognizedText)
                }
            }) {
                Text("Generate Easy to Read Manual")
            }
            
            Button(action: {
                Task {
                    await userManualViewModel.generateCombinedManual(forUserTypes: [.general, .child], withText: recognizedText)
                }
            }) {
                Text("Generate Combined Manual")
            }
            
            HStack {
                            TextField("Enter language", text: $selectedLanguage)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .autocapitalization(.none)
                            
                            Button(action: {
                                Task {
                                    await userManualViewModel.generateTranslatedManual(forLanguage: selectedLanguage, withText: recognizedText)
                                }
                            }) {
                                Text("Generate Translated Manual")
                            }
                            .disabled(selectedLanguage.isEmpty || recognizedText.isEmpty)
                        }

            
            Button(action: {
                Task {
                    await userManualViewModel.generateLowLiteracyManual(withText: recognizedText)
                }
            }) {
                Text("Generate Low Literacy Manual")
            }
            
            Button(action: {
                Task {
                    await userManualViewModel.generateCulturalManual(forCulture: "Japanese", withText: recognizedText)
                }
            }) {
                Text("Generate Manual for Japanese Culture")
            }
        }
        .disabled(recognizedText.isEmpty)  // Disable the buttons if there is no scanned text
    }
}



#Preview {
    ContentView()
        .previewDevice("iPad Pro (12.9-inch) (5th generation)")

}
