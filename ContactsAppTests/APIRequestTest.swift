//
//  APIRequestTest.swift
//  ContactsAppTests
//
//  Created by Fereizqo Sulaiman on 09/02/20.
//  Copyright © 2020 Fereizqo Sulaiman. All rights reserved.
//

import XCTest
@testable import ContactsApp

class APIRequestTest: XCTestCase {
    func testOnGetContacts1() {
        APIRequest.shared.getContacts { result, error in
            let first_name = "Updated"
            var name = ""
            if result.id == 16141 {
                name = result.first_name
            }
            XCTAssertTrue(first_name == name)
        }
    }
    
    func testOnGetContacts2() {
        
    }
}
