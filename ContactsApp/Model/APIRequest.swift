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
    
    func getContactData() -> ([Contact], Int) {
        // Reset contact data
        Alamofire.request("https://gojek-contacts-app.herokuapp.com/contacts.json", method: .get)
           .responseJSON(completionHandler: {
               (response) in
               
            // Check response is success or not
            guard response.result.isSuccess,
            // If response is success, get the value from response
            let value = response.result.value else {
                // If response is failed, show error message
                print("There is problem when connecting server")
                return
            }
            if response.response?.statusCode == 200 {
                // If response success, do something here
                self.statusCode = response.response?.statusCode
                print("Status code inside: \(self.statusCode ?? 20)")
                let listData = JSON(value).arrayValue.sorted(by: {$0["first_name"] < $1["first_name"]})
                // Get required data
                for data in listData {
                    let id = JSON(data["id"]).intValue
                    let first_name = JSON(data["first_name"]).stringValue
                    let last_name = JSON(data["last_name"]).stringValue
                    let profile_pic = JSON(data["profile_pic"]).stringValue
                    let favorite = JSON(data["favorite"]).boolValue
                    let url = JSON(data["url"]).stringValue
                    
                    let contact = Contact(id: id, first_name: first_name, last_name: last_name, profile_pic: profile_pic, favorite: favorite, url: url)
                    self.contacts.append(contact)   
                }
            } else {
                // If response error, do something here
                self.statusCode = response.response?.statusCode ?? 0
            }
            print("Status code mid: \(self.statusCode ?? 20)")
        })
        print("Status code outside: \(self.statusCode ?? 20)")
        return (self.contacts,self.statusCode ?? 0)
    }
}
