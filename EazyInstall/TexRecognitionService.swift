//
//  TexRecognitionService.swift
//  EazyInstall
//
//  Created by Chika Ohaya on 10/9/23.
//

import Vision
import UIKit

enum TextRecognitionError: Error {
    case imageConversionFailed
    case textRecognitionFailed
    case textProcessingFailed
}

protocol TextRecognitionServiceProtocol {
    func recognizeTextFromImage(_ image: UIImage) async throws -> String?
}

class TextRecognitionService: TextRecognitionServiceProtocol {
    
    func recognizeTextFromImage(_ image: UIImage) async throws -> String? {
        return try await withCheckedThrowingContinuation { continuation in
            guard let cgImage = image.cgImage else {
                continuation.resume(throwing: TextRecognitionError.imageConversionFailed)
                return
            }
            
            let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            let request = VNRecognizeTextRequest { request, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                guard let observations = request.results as? [VNRecognizedTextObservation] else {
                    continuation.resume(throwing: TextRecognitionError.textRecognitionFailed)
                    return
                }
                let recognizedText = observations.compactMap { observation in
                    observation.topCandidates(1).first?.string
                }.joined(separator: "\n")

                // Call the C function for post-processing
                if let processedTextC = processText(recognizedText) {
                    let processedText = String(cString: processedTextC)
                    free(processedTextC) // Free the memory allocated by the C function
                    continuation.resume(returning: processedText)
                } else {
                    continuation.resume(throwing: TextRecognitionError.textProcessingFailed)
                }
            }
            
            // Use either .accurate or .fast - .accurate is more accurate but slower
            request.recognitionLevel = .accurate
            
            do {
                try requestHandler.perform([request])
            } catch {
                continuation.resume(throwing: TextRecognitionError.textRecognitionFailed)
            }
        }
    }
}

