//
//  Chatgpt Service.swift
//  EazyInstall
//
//  Created by Chika Ohaya on 10/9/23.
//



import Foundation
import OpenAI
import Network
// Define a protocol for your service
protocol ChatGPTServiceProtocol {
    func generateResponse(for prompt: String) async throws -> String
}

class ChatGPTService: ChatGPTServiceProtocol {
    
    private let openAI: OpenAI
    private var cache: [String: String] = [:]  // A dictionary to store cached responses
    private let persistentCache: PersistentCache  // For persistent caching
    private let networkMonitor: NetworkMonitor  // To monitor network conditions
    init(apiToken: String = "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") {
        let configuration = OpenAI.Configuration(token: apiToken)
        self.openAI = OpenAI(configuration: configuration)
        self.persistentCache = PersistentCache()
                self.networkMonitor = NetworkMonitor()
            }
            
            func generateResponse(for prompt: String) async throws -> String {
                print("generateResponse called with prompt: \(prompt)")

                // Check in-memory cache first
                if let cachedResponse = cache[prompt] {
                    return cachedResponse
                }

                // Check persistent cache
                if let cachedResponse = persistentCache.getResponse(for: prompt) {
                    return cachedResponse
                }

                // Handle network conditions
//                guard networkMonitor.isNetworkAvailable else {
//                    // Handle logic for no network or poor network conditions
//                    return "Network unavailable. Please try again later."
//                }

                print("Sending request to OpenAI API.")

                let query = ChatQuery(
                    model: .gpt4,
                    messages: [.init(role: .user, content: prompt)]
                )

                do {
                    let result = try await openAI.chats(query: query)
                    if let response = result.choices.first?.message.content {
                        print("Received response from OpenAI API: \(response)")
                        
                        // Store in both caches
                        cache[prompt] = response
                        persistentCache.storeResponse(response, for: prompt)
                        
                        return response
                    } else {
                        print("Received an empty response from OpenAI API.")
                        return ""
                    }
                } catch let error {
                    print("Error occurred: \(error.localizedDescription)")
                    // Implement retry logic here if needed
                    throw error
                }
            }
        }

class PersistentCache {
    private let userDefaults = UserDefaults.standard

    private func hashKey(for prompt: String) -> String {
         return String(prompt.hashValue)
     }

     func getResponse(for prompt: String) -> String? {
         let key = hashKey(for: prompt)
         return userDefaults.string(forKey: key)
     }

    func storeResponse(_ response: String, for prompt: String) {
        DispatchQueue.global(qos: .background).async {
            let key = self.hashKey(for: prompt)
            self.userDefaults.set(response, forKey: key)
        }
    }

}


class NetworkMonitor {
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")
    private var status: NWPath.Status = .requiresConnection
    private var debounceTimer: Timer?

    init() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.debounceStatusUpdate(path.status)
        }
        monitor.start(queue: queue)
    }

    private func debounceStatusUpdate(_ newStatus: NWPath.Status) {
        debounceTimer?.invalidate()
        debounceTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { [weak self] _ in
            self?.status = newStatus
        }
    }

    var isNetworkAvailable: Bool {
        return status == .satisfied
    }
}
