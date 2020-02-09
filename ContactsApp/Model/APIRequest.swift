//
//  APIRequest.swift
//  ContactsApp
//
//  Created by Fereizqo Sulaiman on 09/02/20.
//  Copyright © 2020 Fereizqo Sulaiman. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class APIRequest {
    static let shared = APIRequest()
    private init() {}
    
    var detailContact: DetailContact?
    var contact: Contact?
    var contacts: [Contact] = []
    var statusCode: Int?
    
    enum method {
        case getContact
        case getDetailContact
        case put
        case post
    }
    
    func doAPIRequest(method: method, url: String, completionHandler: @escaping (Contact, NSError?) -> Void) {
        switch method {
        case .getContact:
            let _ = url
            print("get contact")
            getContactRequest(completion: completionHandler)
        case .getDetailContact:
            print("get detail contact")
        case .post:
            print("post")
        case .put:
            print("put")
        }
    }
    
    func getContacts(completionHandler: @escaping (Contact, NSError?) -> Void) {
        getContactRequest(completion: completionHandler)
    }
    
    func getContactRequest(completion: @escaping (Contact, NSError?) -> Void) {
        let url = "https://gojek-contacts-app.herokuapp.com/contacts.json"

        Alamofire.request(url, method: .get)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    let listData = JSON(value).arrayValue
                    for data in listData {
                        let id = JSON(data["id"]).intValue
                        let first_name = JSON(data["first_name"]).stringValue
                        let last_name = JSON(data["last_name"]).stringValue
                        let profile_pic = JSON(data["profile_pic"]).stringValue
                        let favorite = JSON(data["favorite"]).boolValue
                        let url = JSON(data["url"]).stringValue
                        
                        let contact = Contact(id: id, first_name: first_name, last_name: last_name, profile_pic: profile_pic, favorite: favorite, url: url)
                        
                        completion(contact, nil)
                    }
                case .failure(let error):
                    let contact = Contact(id: 0, first_name: "", last_name: "", profile_pic: "", favorite: false, url: "")
                    completion(contact, error as NSError)
                }
        }
    }
    
    func getDetailContactRequest(completion: @escaping (DetailContact, NSError?) -> Void) {
        let url = "https://gojek-contacts-app.herokuapp.com/contacts.json"

        Alamofire.request(url, method: .get)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    let listData = JSON(value).arrayValue
                    for data in listData {
                        
                        let id = data["id"].intValue
                        let first_name = data["first_name"].stringValue
                        let last_name = data["last_name"].stringValue
                        let email = data["email"].stringValue
                        let phone_number = data["phone_number"].stringValue
                        let profile_pic = data["profile_pic"].stringValue
                        let favorite = data["favorite"].boolValue
                        
                        let detailContact = DetailContact(id: id, first_name: first_name, last_name: last_name, email: email, phone_number: phone_number, profile_pic: profile_pic, favorite: favorite)

                        
                        completion(detailContact, nil)
                    }
                case .failure(let error):
                    let detailContact = DetailContact(id: 0, first_name: "", last_name: "", email: "", phone_number: "", profile_pic: "", favorite: false)
                    completion(detailContact, error as NSError)
                }
        }
    }
}
