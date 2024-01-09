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
        
        let keywords = tokens[language]
        
        var sentences = [sentence]
        for keyword in keywords! {
            sentences = sentences
                .flatMap { $0.components(separatedBy: " \(keyword) ") }
                .map { $0.trimmingCharacters(in: .whitespaces) }
        }

        return sentences.filter { !$0.isEmpty }}
}
