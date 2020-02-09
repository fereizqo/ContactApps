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
    
    // MARK: - Get Request: Contact
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
    
    // MARK: - Get Request: Detail Contact
    
    func getDetailContacts(url: String, completionHandler: @escaping (DetailContact, NSError?) -> Void) {
        getDetailContactRequest(url: url, completion: completionHandler)
    }
    
    func getDetailContactRequest(url: String, completion: @escaping (DetailContact, NSError?) -> Void) {
        let url = url

        Alamofire.request(url, method: .get)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    let data = JSON(value)
                    
                    let id = data["id"].intValue
                    let first_name = data["first_name"].stringValue
                    let last_name = data["last_name"].stringValue
                    let email = data["email"].stringValue
                    let phone_number = data["phone_number"].stringValue
                    let profile_pic = data["profile_pic"].stringValue
                    let favorite = data["favorite"].boolValue
                    
                    let detailContact = DetailContact(id: id, first_name: first_name, last_name: last_name, email: email, phone_number: phone_number, profile_pic: profile_pic, favorite: favorite)
                    
                    completion(detailContact, nil)
                    
                case .failure(let error):
                    let detailContact = DetailContact(id: 0, first_name: "", last_name: "", email: "", phone_number: "", profile_pic: "", favorite: false)
                    completion(detailContact, error as NSError)
                }
        }
    }
    
    // MARK: - Put Request: Update Detail Contact
    
    func updateContact(url: String, parameter: Parameters, completionHandler: @escaping (String, NSError?) -> Void) {
        updateContactRequest(url: url, parameter: parameter, completion: completionHandler)
    }
    
    func updateContactRequest(url: String, parameter: Parameters, completion: @escaping (String, NSError?) -> Void) {
        let url = url
        let header = ["Content-Type": "application/json"]

        Alamofire.request(url, method: .put, parameters: parameter, encoding: JSONEncoding.default, headers: header)
            .responseJSON { response in
                switch response.result {
                case .success(_):
                    var message = ""
                    // Check response is success or not
                    guard response.result.isSuccess,
                    // If response is success, get the value from response
                    let value = response.result.value else { return }
                    // Check status response
                    switch response.response?.statusCode {
                    case 422:
                        let data = JSON(value)["errors"].arrayValue
                        for error in data {
                            message += "\(error.stringValue) \n"
                        }
                    case 200:
                        message = "Successfully updated"
                    default:
                        message = "Problem when connecting server"
                    }
                    
                    completion(message, nil)
                    
                case .failure(let error):
                    completion("", error as NSError)
                }
        }
    }
    
    // MARK: - Post Request: Create Contact
    
    func createContact(url: String, parameter: Parameters, completionHandler: @escaping (String, NSError?) -> Void) {
        createContactRequest(url: url, parameter: parameter, completion: completionHandler)
    }
    
    func createContactRequest(url: String, parameter: Parameters, completion: @escaping (String, NSError?) -> Void) {
        let url = url
        let header = ["Content-Type": "application/json"]
        
        Alamofire.request(url, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: header)
            .responseJSON { response in
                switch response.result {
                case .success(_):
                    var message = ""
                    // Check response is success or not
                    guard response.result.isSuccess,
                    // If response is success, get the value from response
                    let value = response.result.value else { return }
                    // Check status response
                    switch response.response?.statusCode {
                    case 422:
                        let data = JSON(value)["errors"].arrayValue
                        for error in data {
                            message += "\(error.stringValue) \n"
                        }
                    case 201:
                        message = "Successfully updated"
                    default:
                        message = "Problem when connecting server"
                    }
                    
                    completion(message, nil)
                    
                case .failure(let error):
                    completion("", error as NSError)
                }
        }
    }
    
    
}
