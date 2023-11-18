//
//  ScannerViewModel.swift
//  EazyInstall
//
//  Created by Chika Ohaya on 10/9/23.
//

import Foundation


import SwiftUI

// Trie Node
class TrieNode {
    var children: [Character: TrieNode] = [:]
    var isEndOfWord: Bool = false
}

// Trie for efficient word retrieval
class Trie {
    let root = TrieNode()
    
    func insert(_ word: String) {
        var node = root
        for char in word {
            if node.children[char] == nil {
                node.children[char] = TrieNode()
            }
            node = node.children[char]!
        }
        node.isEndOfWord = true
    }
    
    func search(_ word: String) -> Bool {
        var node = root
        for char in word {
            guard let foundNode = node.children[char] else {
                return false
            }
            node = foundNode
        }
        return node.isEndOfWord
    }
}

// Protocol defining the strategy
protocol TextScanningStrategyProtocol {
    func extractKeywords(from text: String) -> [String]
}

// Strategy using Trie for keyword extraction
class TrieTextScanningStrategy: TextScanningStrategyProtocol {
    private var trie = Trie()
    private var keywords: [String]
    
    init(keywords: [String]) {
        self.keywords = keywords
        for keyword in keywords {
            trie.insert(keyword)
        }
    }
    
    func extractKeywords(from text: String) -> [String] {
        var foundKeywords: [String] = []
        let words = text.split(separator: " ")
        for word in words {
            if trie.search(String(word)) {
                foundKeywords.append(String(word))
            }
        }
        return foundKeywords
    }
}

// ViewModel
class ScannerViewModel: ObservableObject {
    @Published var recognizedText: String = ""
    @Published var keywords: [String] = []
    private var textRecognitionService: TextRecognitionServiceProtocol
    private var textScanningStrategy: TextScanningStrategyProtocol
    
    init(textRecognitionService: TextRecognitionServiceProtocol = TextRecognitionService(),
         textScanningStrategy: TextScanningStrategyProtocol = TrieTextScanningStrategy(keywords: ["install", "setup", "warning","Step","Instructions"])) {
        self.textRecognitionService = textRecognitionService
        self.textScanningStrategy = textScanningStrategy
    }
    
    func recognizeText(from image: UIImage) async {
            // Multi-pass scanning
            for _ in 1...3 {
                do {
                    let text = try await textRecognitionService.recognizeTextFromImage(image)
                    if let recognizedText = text {
                        self.recognizedText += recognizedText + "\n"  // Append recognized text with a newline separator
                    } else {
                        self.recognizedText += "No text recognized\n"
                    }
                } catch {
                    recognizedText = "An error occurred\n"
                }
            }
            
            // Spell correction goes here (using third-party libraries or APIs)
            
            keywords = textScanningStrategy.extractKeywords(from: self.recognizedText)
        }
    }
// Text Recognition Service and Protocol remain the same as in the previous example.
