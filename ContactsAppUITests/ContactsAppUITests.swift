//
//  ContactsAppUITests.swift
//  ContactsAppUITests
//
//  Created by Fereizqo Sulaiman on 06/02/20.
//  Copyright © 2020 Fereizqo Sulaiman. All rights reserved.
//

import XCTest

class ContactsAppUITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testFoundText() {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        
        let a2A2StaticText = app.tables/*@START_MENU_TOKEN@*/.staticTexts["A2 A2"]/*[[".cells.staticTexts[\"A2 A2\"]",".staticTexts[\"A2 A2\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        let predicate = NSPredicate(format: "exist == true")
        let myExpectation = expectation(for: predicate, evaluatedWith: a2A2StaticText, handler: nil)
        
        let result = XCTWaiter().wait(for: [myExpectation], timeout: 5)
    }
    
//    func testTap() {
//        let app = XCUIApplication()
//        app.launch()
//
//        let a2A2StaticText = app.tables/*@START_MENU_TOKEN@*/.staticTexts["A2 A2"]/*[[".cells.staticTexts[\"A2 A2\"]",".staticTexts[\"A2 A2\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
//        waitForExpectations(timeout: 3, handler: nil)
//        a2A2StaticText.tap()
//
//        let favouriteButtonSelectedButton = app.buttons["favourite button"]
//        favouriteButtonSelectedButton.tap()
//        
//        let okButton = app.alerts["Success"].scrollViews.otherElements.buttons["Ok"]
//        okButton.tap()
//
//        let contactButton = app.navigationBars["ContactsApp.DetailContactView"].buttons["Contact"]
//        contactButton.tap()
//
//        a2A2StaticText.tap()
//        favouriteButtonSelectedButton.tap()
//        okButton.tap()
//    }

    func testLaunchPerformance() {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
            }
        }
    }
}
