//
//  TokenizerViewModelTests.swift
//  TokenizerAppTests
//
//  Created by Amaury Caballero on 9/1/24.
//

import XCTest
@testable import TokenizerApp

class TokenizerViewModelTests: XCTestCase {
    var viewModel: TokenizerViewModel!
    var tokenizer: SentenceTokenizer!
    
    override func setUp() {
        super.setUp()
        tokenizer = SentenceTokenizer()
        viewModel = TokenizerViewModel(tokenizer: tokenizer)
    }
    
    override func tearDown() {
        viewModel = nil
        tokenizer = nil
        super.tearDown()
    }
    
    func testTokenizeCallsUpdateViewWithTokenizedSentences() {
        let expectation = XCTestExpectation(description: "updateView is called with tokenized sentences")
        
        do {
            try viewModel.updateLanguage(to: .English)
            viewModel.updateView = { sentences in
                XCTAssertEqual(sentences, ["- Hi my name is Oxus", "- and I am here to start the project"])
                expectation.fulfill()
            }
            
            viewModel.tokenize(sentence: "Hi my name is Oxus and I am here to start the project")
            
            wait(for: [expectation], timeout: 1.0)
        } catch {
            XCTFail("Should not throw an error when updating language")
        }
    }
    
    func testUpdateLanguageChangesLanguage() {
        let englishExpectation = XCTestExpectation(description: "English tokenization")
        let spanishExpectation = XCTestExpectation(description: "Spanish tokenization")

        do {
            // English test
            try viewModel.updateLanguage(to: .English)
            viewModel.updateView = { sentences in
                XCTAssertTrue(sentences.contains("- Hi my name is Oxus"))
                XCTAssertTrue(sentences.contains("- and I am here to start the project"))
                englishExpectation.fulfill()
            }
            viewModel.tokenize(sentence: "Hi my name is Oxus and I am here to start the project")

            // Spanish test
            try viewModel.updateLanguage(to: .Spanish)
            viewModel.updateView = { sentences in
                XCTAssertTrue(sentences.contains("- Hola mi nombre es Oxus"))
                XCTAssertTrue(sentences.contains("- y Estoy aquí para comenzar el proyecto"))
                spanishExpectation.fulfill()
            }
            viewModel.tokenize(sentence: "Hola mi nombre es Oxus y Estoy aquí para comenzar el proyecto")

            wait(for: [englishExpectation, spanishExpectation], timeout: 1.0)
        } catch {
            XCTFail("Should not throw an error when updating language")
        }
    }

    func testTokenizeHandlesError() {
        let expectation = XCTestExpectation(description: "updateView is called with an error message")
        
        XCTAssertThrowsError(try viewModel.updateLanguage(to: Languages(rawValue: "fr"))) { error in
            XCTAssertEqual(error as? TokenizerError, TokenizerError.unsupportedLanguage)
            expectation.fulfill()
        }
    }
}
