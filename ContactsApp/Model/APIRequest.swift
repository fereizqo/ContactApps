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
}
