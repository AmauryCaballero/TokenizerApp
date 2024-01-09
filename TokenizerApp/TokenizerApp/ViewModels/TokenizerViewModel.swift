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
    private var currentLanguage: String = "en"
    
    
    init(tokenizer: SentenceTokenizer = SentenceTokenizer()) {
        self.tokenizer = tokenizer
    }
    
    func tokenize(sentence: String) {
        do {
            let tokenizedSentences = try tokenizer.tokenize(sentence: sentence, language: currentLanguage)
            updateView?(tokenizedSentences)
        } catch {
            updateView?(["Error: \(error.localizedDescription)"])
        }
    }

    // Add a method to update the current language
    func updateLanguage(to language: String) {
        currentLanguage = language
    }
}
