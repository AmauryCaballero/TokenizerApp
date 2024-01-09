//
//  TokenizerViewModel.swift
//  TokenizerApp
//
//  Created by Amaury Caballero on 9/1/24.
//

import Foundation

class TokenizerViewModel {
    
    private let tokenizer: SentenceTokenizer
    var updateView: (([String]) -> Void)?
    
    
    init(tokenizer: SentenceTokenizer = SentenceTokenizer()) {
        self.tokenizer = tokenizer
    }
    
    func tokenize(sentence: String, language: String) {
        do {
            let tokenizedSentences = try tokenizer.tokenize(sentence: sentence, language: language)
            updateView?(tokenizedSentences)
        } catch {
            updateView?(["Error: \(error.localizedDescription)"])
        }
    }
}
