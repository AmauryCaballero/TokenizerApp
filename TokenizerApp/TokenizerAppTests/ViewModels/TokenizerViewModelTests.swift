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
        
        viewModel.updateView = { sentences in
            XCTAssertEqual(sentences, ["Hi my name is Oxus", "I am here to start the project"])
            expectation.fulfill()
        }
        
        viewModel.tokenize(sentence: "Hi my name is Oxus and I am here to start the project", language: "en")
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testTokenizeHandlesError() {
        let expectation = XCTestExpectation(description: "updateView is called with an error message")
        
        viewModel.updateView = { sentences in
            XCTAssertTrue(sentences.contains { $0.starts(with: "Error:") })
            expectation.fulfill()
        }
        
        viewModel.tokenize(sentence: "Hi my name is Oxus and I am here to start the project", language: "fr")
        
        wait(for: [expectation], timeout: 1.0)
    }
}
