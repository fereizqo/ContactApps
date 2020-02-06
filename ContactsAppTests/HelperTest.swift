//
//  HelperTest.swift
//  ContactsAppTests
//
//  Created by Fereizqo Sulaiman on 06/02/20.
//  Copyright © 2020 Fereizqo Sulaiman. All rights reserved.
//

import XCTest
@testable import ContactsApp

class HelperTest: XCTestCase {
    let helper = Helper()
    
    func testGetContactData() {
        let result = helper.getContactData()
        XCTAssertNotNil(result)
    }
}
