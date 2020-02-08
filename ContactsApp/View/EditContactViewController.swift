//
//  EditContactViewController.swift
//  ContactsApp
//
//  Created by Fereizqo Sulaiman on 06/02/20.
//  Copyright © 2020 Fereizqo Sulaiman. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class EditContactViewController: UIViewController {

    @IBOutlet weak var cancelBarButton: UIBarButtonItem!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var photoContactImage: UIImageView!
    @IBOutlet weak var formContactTableView: UITableView!
    
    let label = ["First Name","Last Name", "mobile", "email"]
    var form = ["","","",""]
    
    var detailContact: DetailContact?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Register xib cell
        let cellNib = UINib(nibName: "EditContactTableViewCell", bundle: nil)
        formContactTableView.register(cellNib, forCellReuseIdentifier: "editContactCell")
        
        // Set appearance
        formContactTableView.tableFooterView = UIView()
        
        // Checking edit or not
        editContact()
        
        formContactTableView.delegate = self
        formContactTableView.dataSource = self
    }
    
    func editContact() {
        guard let detailContact = self.detailContact else { return }
        form.removeAll()
        form.append(contentsOf: ["\(detailContact.first_name)",
            "\(detailContact.last_name)",
            "\(detailContact.phone_number)",
            "\(detailContact.email)"])
    }
    
    @IBAction func cancelBarButtonTapped(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneBarButtonTapped(_ sender: UIBarButtonItem) {
            editFormDone()
    }
    
}

extension EditContactViewController: UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        // Save input texfield text to form instance
        form[textField.tag] = textField.text ?? ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        let next = textField.tag + 1
//
//        if let nextTextField = textField.superview?.viewWithTag(next) as? UITextField {
//            nextTextField.becomeFirstResponder()
//        } else {
//            textField.becomeFirstResponder()
//        }
        
        textField.resignFirstResponder()
        
        return true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return label.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "editContactCell", for: indexPath) as! EditContactTableViewCell
        
        // Set cell appearance
        cell.selectionStyle = .none
        cell.inputTextField.autocorrectionType = .no
        cell.inputTextField.autocapitalizationType = .none
        cell.headerLabel.text = label[indexPath.row]
        
        // Tagged each textField
        let textField = cell.viewWithTag(1) as! UITextField
        textField.tag = indexPath.row
        textField.text = form[indexPath.row]
        
        textField.delegate = self
        
        return cell
    }
}

extension EditContactViewController {
    func editFormDone() {
        let header = ["Content-Type": "application/json"]
        
        // Detect whether it editing or adding contact
        if let detailContact = self.detailContact {
            // Editing contact, do Put Request
            let url = "https://gojek-contacts-app.herokuapp.com/contacts/\(detailContact.id).json"
            let parameter: Parameters = [
                "first_name": form[0],
                "last_name": form[1],
                "email": form[3],
                "phone_number" : form[2],
                "favorite": "\(detailContact.favorite)"
            ]
            Alamofire.request(url, method: .put, parameters: parameter, encoding: JSONEncoding.default, headers: header)
                .responseJSON { response in
                    // Check response is success or not
                    guard response.result.isSuccess,
                    // If response is success, get the value from response
                    let value = response.result.value else {
                        // If response is failed, show error message
                        print("Problem when connecting server")
                        return
                    }
                    // Check status response
                    switch response.response?.statusCode {
                    case 422:
                        let data = JSON(value)["errors"].arrayValue
                        var message = ""
                        for error in data {
                            message += "\(error.stringValue) \n"
                        }
                        let alert = Helper.makeAlert(title: "Alert", messages: "\(message)")
                        self.present(alert, animated: true, completion: nil)
                        break
                    case 200:
                        let alert = Helper.makeAlert(title: "Succes", messages: "Contact successfully updated")
                        self.present(alert, animated: true, completion: nil)
                        self.dismiss(animated: true, completion: nil)
                    case .none:
                        break
                    case .some(_):
                        break
                    }
            }
        } else {
            // Adding Contact, do Post Request
            let url = "https://gojek-contacts-app.herokuapp.com/contacts.json"
            let parameter: Parameters = [
                "first_name": form[0],
                "last_name": form[1],
                "email": form[2],
                "phone_number" : form[3],
                "favorite": "false"
            ]
            Alamofire.request(url, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: header)
                .responseJSON { response in
                    // Check response is success or not
                    guard response.result.isSuccess,
                    // If response is success, get the value from response
                    let value = response.result.value else {
                        // If response is failed, show error message
                        print("Problem when connecting server")
                        return
                    }
                    // Check status response
                    switch response.response?.statusCode {
                    case 422:
                        let data = JSON(value)["errors"].arrayValue
                        var message = ""
                        for error in data {
                            message += "\(error.stringValue) \n"
                        }
                        let alert = Helper.makeAlert(title: "Alert", messages: "\(message)")
                        self.present(alert, animated: true, completion: nil)
                        break
                    case 201:
                        let alert = Helper.makeAlert(title: "Succes", messages: "Contact successfully created")
                        self.present(alert, animated: true, completion: nil)
                        self.dismiss(animated: true, completion: nil)
                    case .none:
                        break
                    case .some(_):
                        break
                    }
            }
        }
    }
}
