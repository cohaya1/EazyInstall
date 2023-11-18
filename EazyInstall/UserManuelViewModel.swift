//
//  UserManuelViewModel.swift
//  EazyInstall
//
//  Created by Chika Ohaya on 10/28/23.
//

import Foundation
import SwiftUI

enum UserManualError: Error, Identifiable {
    var id: String { localizedDescription }
    case generationFailed(String)
    case other(Error)
}

@MainActor
class UserManualViewModel: ObservableObject {
    
    @Published var userManual: String = ""
    @Published var isLoading: Bool = false
    @Published var error: UserManualError?
    
    private let chatGPTService: ChatGPTServiceProtocol
    
    init(chatGPTService: ChatGPTServiceProtocol = ChatGPTService()) {
        self.chatGPTService = chatGPTService
    }
    enum UserType {
        case general
        case child
        case constructionWorker
        case nonEnglishSpeaker(language: String) // User who prefers another language
        case lowLiteracy // Users who might have difficulty with complex language
        case specificCulture(culture: String) // For cultural contextualization
        case combined(types: [UserType]) // New case for combined user types

    }
    
    private func generatePrompt(forUserType userType: UserType, withText scannedText: String) -> String {
        // This function handles individual prompt generation
        switch userType {
        case .general:
            return "Create an Easy to understand user manual for the following task based on the provided information: \(scannedText)"
        case .child:
            return "Transform this instruction manual into simple steps that a 5-year-old can effortlessly understand and follow: \(scannedText)"
        case .constructionWorker:
            return "Create a concise and clear set of steps from this instruction manual. Ensure it's tailored for construction workers, promoting easy collaboration and optimal results: \(scannedText)"
        case .nonEnglishSpeaker(let language):
            return "Translate this instruction manual into \(language) to make it easily understandable"
        case .lowLiteracy:
            return "Rewrite this instructions or steps using simple language and short sentences"
        case .specificCulture(let culture):
            return "Adapt this instruction manual to be culturally relevant for \(culture) audience, ensuring relatable context and terminology"
        case .combined(let types):
                return types.map { generatePrompt(forUserType: $0, withText: scannedText) }.joined(separator: " Additionally, ")
            }
    }
    func generateCombinedManual(forUserTypes userTypes: [UserType], withText scannedText: String) async {
        await generateUserManual(forUserType: .combined(types: userTypes), withText: scannedText)
        }
    func generateTranslatedManual(forLanguage language: String, withText scannedText: String) async {
        await generateUserManual(forUserType: .nonEnglishSpeaker(language: language), withText: scannedText)
      }
      
      func generateLowLiteracyManual(withText scannedText: String) async {
          await generateUserManual(forUserType: .lowLiteracy, withText: scannedText)
      }
      
      func generateCulturalManual(forCulture culture: String, withText scannedText: String) async {
          await generateUserManual(forUserType: .specificCulture(culture: culture), withText: scannedText)
      }
    func generateUserManual(forUserType userType: UserType, withText scannedText: String) async {
        logGenerationStart(for: scannedText)
        let prompt = generatePrompt(forUserType: userType, withText: scannedText)
        await performGeneration(withPrompt: prompt)
    }
    
    private func logGenerationStart(for scannedText: String) {
        print("Generating user manual for text: \(scannedText)")
    }
    
    private func performGeneration(withPrompt prompt: String) async {
        isLoading = true
        error = nil
        print("Prompt: \(prompt)")
        
        do {
            let response = try await chatGPTService.generateResponse(for: prompt)
            print("Response received: \(response)")
            if response.isEmpty {
                self.error = .generationFailed("The generation of the user manual failed.")
                print("Error: \(self.error?.localizedDescription ?? "Unknown error")")
            } else {
                userManual = response
                print("User manual updated")
            }
        } catch let catchedError {
            self.error = .other(catchedError)
            print("Error: \(catchedError.localizedDescription)")
        }
        isLoading = false
        print("Is Loading: \(isLoading)")
    }
}

