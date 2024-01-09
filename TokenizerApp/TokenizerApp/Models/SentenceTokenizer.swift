//
//  SentenceTokenizer.swift
//  TokenizerApp
//
//  Created by Amaury Caballero on 9/1/24.
//

import Foundation

class SentenceTokenizer {
    private let tokens: [String: [String]]
    
    init(tokens: [String : [String]] = ["en": ["if", "and"], "es": ["si", "y"]]) {
        self.tokens = tokens
    }
    
    func tokenize(sentence: String, language: String = "en") -> [String] {
        return []
    }
}
