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
    
    func testTokenizerWithNoKeywords() throws {
        let sentence = "Hello world"
        let tokens = try tokenizer.tokenize(sentence: sentence, language: Languages.English)
        XCTAssertEqual(tokens, ["- Hello world"], "The tokenizer should return the sentence as is when no keywords are present.")
    }

    func testTokenizerWithSentenceStartingWithKeyword() throws {
        let sentence = "And then we left"
        let tokens = try tokenizer.tokenize(sentence: sentence, language: Languages.English)
        XCTAssertEqual(tokens, ["- And then we left"], "The tokenizer should handle sentences starting with a keyword correctly.")
    }

    func testTokenizerWithMixedCaseKeywords() throws {
        let sentence = "It is fun AND exciting"
        let tokens = try tokenizer.tokenize(sentence: sentence, language: Languages.English)
        XCTAssertEqual(tokens, ["- It is fun", "- AND exciting"], "The tokenizer should be case-insensitive for keywords.")
    }

    func testTokenizerWithMultipleKeywords() throws {
        let sentence = "This and that and those"
        let tokens = try tokenizer.tokenize(sentence: sentence, language: Languages.English)
        XCTAssertEqual(tokens, ["- This", "- and that", "- and those"], "The tokenizer should split correctly on multiple keywords.")
    }

    func testTokenizerWithSimilarButNonKeyword() throws {
        let sentence = "Wander around"
        let tokens = try tokenizer.tokenize(sentence: sentence, language: Languages.English)
        XCTAssertEqual(tokens, ["- Wander around"], "The tokenizer should not split on words similar to keywords but not actual keywords.")
    }

    func testTokenizerWithEmptyAndWhitespaceOnlySentences() throws {
        let emptySentence = ""
        let whitespaceSentence = "   "
        let emptyTokens = try tokenizer.tokenize(sentence: emptySentence, language: Languages.English)
        let whitespaceTokens = try tokenizer.tokenize(sentence: whitespaceSentence, language: Languages.English)
        XCTAssertEqual(emptyTokens, [], "The tokenizer should handle empty sentences correctly.")
        XCTAssertEqual(whitespaceTokens, [], "The tokenizer should handle whitespace-only sentences correctly.")
    }

    
    func testTokenizerSplitsEnglishSentence() throws {
        let sentence = "Hi my name is Oxus and I am here to start the project"
        let tokens = try tokenizer.tokenize(sentence: sentence, language: Languages.English)
        XCTAssertEqual(tokens, ["- Hi my name is Oxus", "- and I am here to start the project"], "The tokenizer should split the sentence on 'and' for English.")
    }

    func testTokenizerSplitsSpanishSentence() throws {
        let sentence = "Hola mi nombre es Oxus y estoy aquí para empezar el proyecto"
        let tokens = try tokenizer.tokenize(sentence: sentence, language: Languages.Spanish)
        XCTAssertEqual(tokens, ["- Hola mi nombre es Oxus", "- y estoy aquí para empezar el proyecto"], "The tokenizer should split the sentence on 'y' for Spanish.")
    }
    
    func testTokenizerWithEnglishIf() throws {
        let sentence = "If it rains we will not go outside"
        let tokens = try tokenizer.tokenize(sentence: sentence, language: Languages.English)
        XCTAssertEqual(tokens, ["- If it rains we will not go outside"], "The tokenizer should recognize 'if' in English.")
    }
    
    func testTokenizerWithSpanishSi() throws {
        let sentence = "Si llueve no saldremos"
        let tokens = try tokenizer.tokenize(sentence: sentence, language: Languages.Spanish)
        XCTAssertEqual(tokens, ["- Si llueve no saldremos"], "The tokenizer should recognize 'si' in Spanish.")
    }
    
    func testTokenizerThrowsForUnsupportedLanguage() {
        let sentence = "This is a test"
        XCTAssertThrowsError(try Languages(rawValue: "fr")) { error in
            XCTAssertEqual(error as? TokenizerError, TokenizerError.unsupportedLanguage, "The tokenizer should throw an unsupportedLanguage error for French.")
        }
    }
}
