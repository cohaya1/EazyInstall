//
//  Chatgpt Service.swift
//  EazyInstall
//
//  Created by Chika Ohaya on 10/9/23.
//



import Foundation
import OpenAI

// Define a protocol for your service
protocol ChatGPTServiceProtocol {
    func generateResponse(for prompt: String) async throws -> String
}

class ChatGPTService: ChatGPTServiceProtocol {
    
    private let openAI: OpenAI
    private var cache: [String: String] = [:]  // A dictionary to store cached responses
    
    init(apiToken: String = "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") {
        let configuration = OpenAI.Configuration(token: apiToken)
        self.openAI = OpenAI(configuration: configuration)
    }
    
    func generateResponse(for prompt: String) async throws -> String {
        
        print("generateResponse called with prompt: \(prompt)")

        // Check if the response is already in the cache
        if let cachedResponse = cache[prompt] {
            return cachedResponse
        }
        
        print("Sending request to OpenAI API.")

        
        let query = ChatQuery(
            model: .gpt4,
            messages: [.init(role: .user, content: prompt)]
        )
        
        do {
                    let result = try await openAI.chats(query: query)
                    if let response = result.choices.first?.message.content {
                        print("Received response from OpenAI API: \(response)")
                        
                        // Store the response in the cache
                        cache[prompt] = response
                        
                        return response
                    } else {
                        print("Received an empty response from OpenAI API.")
                        return ""
                    }
                } catch let error {
                    print("Error occurred: \(error.localizedDescription)")
                    throw error  // Re-throw the error to be handled by calling code
                }
            }
        }
