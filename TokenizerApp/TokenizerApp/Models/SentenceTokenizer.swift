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
    
    init(tokens: [String : [String]] = ["en": ["if", "and"], "es": ["si", "y"]]) {
        self.tokens = tokens
    }
    
    func tokenize(sentence: String, language: String = "en") throws -> [String] {
        
        guard let keywords = tokens[language] else {
            throw TokenizerError.unsupportedLanguage
        }
        
        var sentences = [sentence]
        for keyword in keywords {
            sentences = sentences
                .flatMap { $0.components(separatedBy: " \(keyword) ") }
                .map { $0.trimmingCharacters(in: .whitespaces) }
        }
        
        return sentences.filter { !$0.isEmpty }
    }
}
