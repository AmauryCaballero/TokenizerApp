//
//  SplashViewControllerTests.swift
//  TokenizerAppUITests
//
//  Created by Amaury Caballero on 9/1/24.
//

import XCTest
import TokenizerApp

class SplashViewControllerTests: XCTestCase {
    private var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        continueAfterFailure = false

        app = XCUIApplication()
        app.launch()
    }

    override func tearDown() {
        app = nil
        super.tearDown()
    }
    
    func testSplashViewControllerAnimation() {
        let animationView = app.otherElements["SplashAnimationView"]

        XCTAssertTrue(animationView.exists, "The animation view should be present on the screen")
    }
    func testAutomaticNavigationAfterAnimation() {
        let animationView = app.otherElements["SplashAnimationView"]

        XCTAssertTrue(animationView.exists, "The animation view should be present on the screen")

        // Wait for the animation to finish
        let animationExpectation = expectation(for: NSPredicate(format: "exists == false"), evaluatedWith: animationView, handler: nil)
        
        // Adjust this timeout based on the expected animation duration
        wait(for: [animationExpectation], timeout: 20.0)
        
        let allElements = app.otherElements.allElementsBoundByAccessibilityElement


        for identifier in ["SentenceTextField", "LanguageButton", "TokenizeButton"] {
            let exists = allElements.contains { element in
                let debugDescription = element.debugDescription.debugDescription.description
                return debugDescription.contains(identifier)
            }
            XCTAssertTrue(exists, "\(identifier) should exist")
        }

    }
}
