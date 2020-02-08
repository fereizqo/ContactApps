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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Register xib cell
        let cellNib = UINib(nibName: "EditContactTableViewCell", bundle: nil)
        formContactTableView.register(cellNib, forCellReuseIdentifier: "editContactCell")
        
        self.formContactTableView.tableFooterView = UIView()
        
        formContactTableView.delegate = self
        formContactTableView.dataSource = self
    }
    
    @IBAction func cancelBarButtonTapped(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneBarButtonTapped(_ sender: UIBarButtonItem) {
        print("Form : \(form)")
        postContact()
        
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension EditContactViewController: UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
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
        
        cell.selectionStyle = .none
        cell.inputTextField.autocorrectionType = .no
        cell.inputTextField.autocapitalizationType = .none
        
        cell.headerLabel.text = label[indexPath.row]
        
        let textField = cell.viewWithTag(1) as! UITextField
        textField.delegate = self
        textField.tag = indexPath.row
        textField.text = form[indexPath.row]
        
        return cell
    }
}

extension EditContactViewController {
    func postContact() {
        let url = "https://gojek-contacts-app.herokuapp.com/contacts.json"
        let header = ["Content-Type": "application/json"]
        let parameter: Parameters = [
            "first_name": form[0],
            "last_name": form[1],
            "email": form[2],
            "phone_number" : form[3],
            "favorite": "false"
        ]
        
        Alamofire.request(url, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: header)
            .responseJSON { response in
                switch response.result {
                case .success(let data):
                    print("Ok: \(data)")
                case .failure(let error):
                    print("Error: \(error)")
                }
                
        }
        
    }
}
