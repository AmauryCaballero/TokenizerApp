//
//  SentenceTokenizerTests.swift
//  TokenizerAppTests
//
//  Created by Amaury Caballero on 9/1/24.
//

import Foundation
import XCTest
@testable import TokenizerApp

class SentenceTokenizerTests: XCTestCase {
    var tokenizer: SentenceTokenizer!
    
    override func setUp() {
        super.setUp()
        tokenizer = SentenceTokenizer()
    }

    override func tearDown() {
        tokenizer = nil
        super.tearDown()
    }
    
    func testTokenizerSplitsEnglishSentence() throws {
        let sentence = "Hi my name is Oxus and I am here to start the project"
        let tokens = tokenizer.tokenize(sentence: sentence, language: "en")
        XCTAssertEqual(tokens, ["Hi my name is Oxus", "I am here to start the project"], "The tokenizer should split the sentence on 'and' for English.")
    }

    func testTokenizerSplitsSpanishSentence() throws {
        let sentence = "Hola mi nombre es Oxus y estoy aquí para empezar el proyecto"
        let tokens = tokenizer.tokenize(sentence: sentence, language: "es")
        XCTAssertEqual(tokens, ["Hola mi nombre es Oxus", "estoy aquí para empezar el proyecto"], "The tokenizer should split the sentence on 'y' for Spanish.")
    }
}
