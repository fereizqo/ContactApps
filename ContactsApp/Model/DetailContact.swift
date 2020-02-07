//
//  DetailContact.swift
//  ContactsApp
//
//  Created by Fereizqo Sulaiman on 07/02/20.
//  Copyright © 2020 Fereizqo Sulaiman. All rights reserved.
//

import Foundation

class DetailContact {
    let id: Int
    let first_name: String
    let last_name: String
    let email: String
    let phone_number: String
    let profile_pic: String
    var favorite: Bool
    
    init(id: Int, first_name: String, last_name: String, email: String, phone_number: String, profile_pic: String, favorite: Bool) {
        self.id = id
        self.first_name = first_name
        self.last_name = last_name
        self.email = email
        self.phone_number = phone_number
        self.profile_pic = profile_pic
        self.favorite = favorite
    }
}
