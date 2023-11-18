//
//  CacheViewModel.swift
//  EazyInstall
//
//  Created by Chika Ohaya on 10/31/23.
//

import Foundation


class CacheViewModel: ObservableObject {
    private let maxCacheCount = 5
    private var cacheQueue: [URL] = []

    private var scannedDocumentDirectory: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    func cacheDocument(_ newText: String) {
        let newCacheURL = scannedDocumentDirectory.appendingPathComponent(UUID().uuidString + ".txt")
        do {
            try newText.write(to: newCacheURL, atomically: true, encoding: .utf8)
            cacheQueue.append(newCacheURL)

            // Cache eviction
            while cacheQueue.count > maxCacheCount {
                let oldestCache = cacheQueue.removeFirst()
                try? FileManager.default.removeItem(at: oldestCache)
            }
        } catch {
            print("Failed to save scanned document.")
        }
    }

    // ... You can add more caching related functions here
}
