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
    @IBOutlet weak var topView: UIView!
    
    let label = ["First Name","Last Name", "mobile", "email"]
    var form = ["","","",""]
    
    var detailContact: DetailContact?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Register xib cell
        let cellNib = UINib(nibName: "EditContactTableViewCell", bundle: nil)
        formContactTableView.register(cellNib, forCellReuseIdentifier: "editContactCell")
        
        // Checking edit or not
        editContact()
        
        formContactTableView.delegate = self
        formContactTableView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Set appearance
        formContactTableView.tableFooterView = UIView()
        topView.setGradient(colorTop: .white, colorBottom: Helper.primaryColor)
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
        let alert = UIAlertController(title: "Alert", message: "Are you sure want to discard?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Discard", style: .destructive, handler: { action in
            self.navigationController?.dismiss(animated: true, completion: nil)
            alert.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func doneBarButtonTapped(_ sender: UIBarButtonItem) {
        // Show spinner
        Spinner.shared.showSpinner(onView: view)
        // Do request
        doFillForm()
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
    func doFillForm() {
        // Parameter request
        var parameter: Parameters = [
            "first_name": form[0],
            "last_name": form[1],
            "email": form[3],
            "phone_number" : form[2],
            "favorite": "false"
        ]
        
        // Detect whether it editing or adding contact
        if let detailContact = self.detailContact {
            
            // Editing contact, do Put Request
            let url = "https://gojek-contacts-app.herokuapp.com/contacts/\(detailContact.id).json"
            parameter["favorite"] = "\(detailContact.favorite)"
            APIRequest.shared.updateContact(url: url, parameter: parameter) { result, statusCode, error  in
                // Remove spinner
                Spinner.shared.removeSpinner()
                // Result
                if error == nil {
                    switch statusCode {
                    case 200:
                        let alert = UIAlertController(title: "Success", message: "Updated a contact", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                            self.navigationController?.dismiss(animated: true, completion: nil)
                        }))
                        self.present(alert, animated: true, completion: nil)
                    default:
                        let alert = Helper.makeAlert(title: "Alert", messages: "\(result)")
                        self.present(alert, animated: true, completion: nil)
                    }
                    let alert = Helper.makeAlert(title: "Succes", messages: "\(result)")
                    self.present(alert, animated: true, completion: nil)
                } else {
                    let alert = Helper.makeAlert(title: "Alert", messages: "There is problem when connecting server")
                    self.present(alert, animated: true, completion: nil)
                }
            }
        } else {
            
            // Adding Contact, do Post Request
            let url = "https://gojek-contacts-app.herokuapp.com/contacts.json"
            APIRequest.shared.createContact(url: url, parameter: parameter) { result, statusCode, error  in
                // Remove spinner
                Spinner.shared.removeSpinner()
                // Result
                if error == nil {
                    switch statusCode {
                    case 201:
                        let alert = UIAlertController(title: "Success", message: "Created a contact", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                            self.navigationController?.dismiss(animated: true, completion: nil)
                        }))
                        self.present(alert, animated: true, completion: nil)
                    default:
                        let alert = Helper.makeAlert(title: "Alert", messages: "\(result)")
                        self.present(alert, animated: true, completion: nil)
                    }
                } else {
                    let alert = Helper.makeAlert(title: "Alert", messages: "There is problem when connecting server")
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
}
