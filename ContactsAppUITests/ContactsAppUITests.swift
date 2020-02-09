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

    func testExample() {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
    }
    
    func testTapRandom() {
        let app = XCUIApplication()
        let tablesQuery = app.tables
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["A1a A1aaa"]/*[[".cells.staticTexts[\"A1a A1aaa\"]",".staticTexts[\"A1a A1aaa\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.buttons["message button"].tap()
        app.navigationBars["ContactsApp.DetailContactView"].buttons["Contact"].tap()
        app.navigationBars["Contact"].buttons["plus"].tap()
        tablesQuery.cells.containing(.staticText, identifier:"First Name").textFields["Input here"].tap()
        app.navigationBars["ContactsApp.EditContactView"].buttons["Cancel"].tap()
        app.sheets["Alert"].scrollViews.otherElements.buttons["Discard"].tap()
    }
    
    func testTapFavorite() {
        let app = XCUIApplication()
        let a2A2StaticText = app.tables/*@START_MENU_TOKEN@*/.staticTexts["A2 A2"]/*[[".cells.staticTexts[\"A2 A2\"]",".staticTexts[\"A2 A2\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        a2A2StaticText.tap()
        
        let favouriteButtonSelectedButton = app.buttons["favourite button selected"]
        favouriteButtonSelectedButton.tap()
        
        let okButton = app.alerts["Success"].scrollViews.otherElements.buttons["Ok"]
        okButton.tap()
        
        let favouriteButtonButton = app.buttons["favourite button"]
        favouriteButtonButton.tap()
        okButton.tap()
        favouriteButtonSelectedButton.tap()
        okButton.tap()
        favouriteButtonButton.tap()
        okButton.tap()
        favouriteButtonSelectedButton.tap()
        okButton.tap()
        
        let contactButton = app.navigationBars["ContactsApp.DetailContactView"].buttons["Contact"]
        contactButton.tap()
        a2A2StaticText.tap()
        favouriteButtonButton.tap()
        okButton.tap()
        favouriteButtonSelectedButton.tap()
        okButton.tap()
        favouriteButtonButton.tap()
        okButton.tap()
        contactButton.tap()
        
    }

//    func testLaunchPerformance() {
//        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
//            // This measures how long it takes to launch your application.
//            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
//                XCUIApplication().launch()
//            }
//        }
//    }
}
