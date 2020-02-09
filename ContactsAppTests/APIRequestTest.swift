//
//  APIRequestTest.swift
//  ContactsAppTests
//
//  Created by Fereizqo Sulaiman on 09/02/20.
//  Copyright © 2020 Fereizqo Sulaiman. All rights reserved.
//

import XCTest
import Alamofire
@testable import ContactsApp

class APIRequestTest: XCTestCase {
    
    func testGetContacts() {
        let expect = XCTestExpectation(description: "Not nil")
        var contact: Contact?
        
        APIRequest.shared.getContacts { result, error in
            contact = result
            expect.fulfill()
        }
        
        wait(for: [expect], timeout: 5)
        XCTAssertNotNil(contact)
    }
    
    
    func testGetDetailContacts() {
        let expect = XCTestExpectation(description: "Not nil")
        var detailContact: DetailContact?
        let url = "http://gojek-contacts-app.herokuapp.com/contacts/16126.json"
        
        APIRequest.shared.getDetailContacts(url: url) { result, error in
            detailContact = result
            expect.fulfill()
        }
        
        wait(for: [expect], timeout: 5)
        XCTAssertNotNil(detailContact)
    }
    
    
    func testPutUpdateDetailContact() {
        let expect = XCTestExpectation(description: "It could do update")
        let url = "https://gojek-contacts-app.herokuapp.com/contacts/16126.json"
        let parameter: Parameters = [
            "favorite": "false"
        ]
        var statusCodes: Int?
        
        APIRequest.shared.updateContact(url: url, parameter: parameter) { result, statusCode, error in
            statusCodes = statusCode
            expect.fulfill()
        }
        
        wait(for: [expect], timeout: 8)
        XCTAssertTrue(statusCodes == 200)
    }
    
    func testPostCreateContact() {
        let expect = XCTestExpectation(description: "It fail to create")
        let url = "https://gojek-contacts-app.herokuapp.com/contacts.json"
        let parameter: Parameters = [
            "first_name": "TESTING"
        ]
        var statusCodes: Int?
        
        APIRequest.shared.createContact(url: url, parameter: parameter) { result, statusCode, error in
            statusCodes = statusCode
            expect.fulfill()
        }
        
        wait(for: [expect], timeout: 5)
        XCTAssertTrue(statusCodes == 422)
    }
    
    
    func testGetContacts1() {
        let expect = XCTestExpectation(description: "Not matched")
        let first_name = "Updateds"
        var name = ""
        
        APIRequest.shared.getContacts { result, error in
            if result.id == 16141 {
                name = result.first_name
            }
            expect.fulfill()
        }
        
        wait(for: [expect], timeout: 3)
        XCTAssertFalse(first_name == name)
    }
    
    func testGetContacts2() {
        let expect = XCTestExpectation(description: "Matched")
        let last_name = "bb"
        var name = ""
        
        APIRequest.shared.getContacts { result, error in
            if result.id == 16307 {
                name = result.last_name
            }
            expect.fulfill()
        }
        
        wait(for: [expect], timeout: 3)
        XCTAssertTrue(last_name == name)
    }
    
    func testGetDetailContacts1() {
        let url = "http://gojek-contacts-app.herokuapp.com/contacts/16126.json"
        APIRequest.shared.getDetailContacts(url: url) { result, error in
            XCTAssertFalse(result.id == 16126)
        }
    }
}
