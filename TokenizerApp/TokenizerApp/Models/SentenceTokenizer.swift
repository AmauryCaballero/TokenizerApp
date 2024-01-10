//
//  SentenceTokenizer.swift
//  TokenizerApp
//
//  Created by Amaury Caballero on 9/1/24.
//

import Foundation

enum TokenizerError: Error {
    case unsupportedLanguage
}

class SentenceTokenizer {
    private let tokens: [String: [String]]
    
    init(tokens: [String : [String]] = ["en": ["if","and"], "es": ["si","y"]]) {
        self.tokens = tokens
    }
    
    func tokenize(sentence: String, language: String = "en") throws -> [String] {
        guard let keywords = tokens[language]?.map({ $0.lowercased() }) else {
            throw TokenizerError.unsupportedLanguage
        }

        if sentence.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return []
        }

        var sentences = [String]()
        var currentSentence = ""
        
        let words = sentence.split(separator: " ", omittingEmptySubsequences: false)
        for word in words {
            if keywords.contains(word.lowercased()) {
                if !currentSentence.isEmpty {
                    sentences.append("- \(currentSentence.trimmingCharacters(in: .whitespaces))")
                }
                currentSentence = "\(word) "
            } else {
                currentSentence += "\(word) "
            }
        }

        if !currentSentence.isEmpty {
            sentences.append("- \(currentSentence.trimmingCharacters(in: .whitespaces))")
        }
        
        return sentences
    }
}
