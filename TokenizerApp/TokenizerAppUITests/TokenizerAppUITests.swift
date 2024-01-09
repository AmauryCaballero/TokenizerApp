//
//  TokenizerAppUITests.swift
//  TokenizerAppUITests
//
//  Created by Amaury Caballero on 8/1/24.
//

import XCTest

final class TokenizerAppUITests: XCTestCase {

    func testTokenizerViewControllerUI() {
        let app = XCUIApplication()
        app.launch()
        
        let textField = app.textFields["SentenceTextField"]
        let tokenizeButton = app.buttons["TokenizeButton"]
        let sentencesLabel = app.staticTexts["SentencesLabel"]
        
        textField.tap()
        textField.typeText("Hi my name is Oxus and I am here to start the project")
        tokenizeButton.tap()
        
        // Verify that sentencesLabel updates correctly
        XCTAssertTrue(sentencesLabel.label.contains("Hi my name is Oxus"))
        XCTAssertTrue(sentencesLabel.label.contains("I am here to start the project"))
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
