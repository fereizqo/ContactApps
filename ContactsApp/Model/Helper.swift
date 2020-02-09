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
    
    public static let primaryColor = UIColor(red: 80/255, green: 227/255, blue: 194/255, alpha: 0.3)
    
    public static func makeAlert(title: String, messages: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: messages, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        return alert
    }
    
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
                let listData = JSON(value).arrayValue
               
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
                print("No data contacts")
            }
        })
    }
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}

extension UIView {
    func setGradient(colorTop: UIColor, colorBottom: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorBottom.cgColor, colorTop.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.locations = [0, 1]
        gradientLayer.frame = frame

       layer.insertSublayer(gradientLayer, at: 0)
    }
}
