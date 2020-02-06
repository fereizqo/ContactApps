//
//  Contact.swift
//  ContactsApp
//
//  Created by Fereizqo Sulaiman on 06/02/20.
//  Copyright © 2020 Fereizqo Sulaiman. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class Contact {
    var id: Int
    var first_name: String
    var last_name: String
    let profile_pic: String
    let favorite: Bool
    let url: String
    
    init(id: Int, first_name: String, last_name: String, profile_pic: String, favorite: Bool, url: String) {
        self.id = id
        self.first_name = first_name
        self.last_name = last_name
        self.profile_pic = profile_pic
        self.favorite = favorite
        self.url = url
    }
}

