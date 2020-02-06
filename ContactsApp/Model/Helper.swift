//
//  Helper.swift
//  ContactsApp
//
//  Created by Fereizqo Sulaiman on 06/02/20.
//  Copyright © 2020 Fereizqo Sulaiman. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class Helper {
    
    var contacts: [Contact] = []
    
    func getContactData() {
        Alamofire.request("http://gojek-contacts-app.herokuapp.com/contacts.json", method: .get)
           .responseJSON(completionHandler: {
               (response) in
               
            // Check response is success or not
            guard response.result.isSuccess,
            // If response is success, get the value from response
            let value = response.result.value else {
                // If response is failed, show error message
                print("Problem when connecting server")
                return
            }

            if response.response?.statusCode == 200 {
                // If response success, do something here
                let s = JSON(value).arrayValue
                // let listData = JSON(value)["task"].arrayValue
               
                // Get required data
                for data in s {
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
                print("No data contacts")
            }
        })
    }
}
