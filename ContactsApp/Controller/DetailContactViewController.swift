//
//  DetailContactViewController.swift
//  ContactsApp
//
//  Created by Fereizqo Sulaiman on 06/02/20.
//  Copyright © 2020 Fereizqo Sulaiman. All rights reserved.
//

import UIKit
import MessageUI
import Alamofire
import SwiftyJSON

class DetailContactViewController: UIViewController {

    @IBOutlet weak var editBarButton: UIBarButtonItem!
    @IBOutlet weak var photoContactImage: UIImageView!
    @IBOutlet weak var nameContactLabel: UILabel!
    @IBOutlet weak var detailContactTableView: UITableView!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var url: String?
    var detailContact: DetailContact?
    var labelDetail = ["-", "-"]
    var labelHeader = ["mobile", "email"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Load Detail Contact Data
        getDetailContactData()
        
        // Register xib cell
        let cellNib = UINib(nibName: "EditContactTableViewCell", bundle: nil)
        detailContactTableView.register(cellNib, forCellReuseIdentifier: "editContactCell")
        
        self.detailContactTableView.tableFooterView = UIView()
        detailContactTableView.delegate = self
        detailContactTableView.dataSource = self
    }
    
    @IBAction func messageButtonTapped(_ sender: UIButton) {
        if (MFMessageComposeViewController.canSendText()) {
            // Check detail contact has a value
            guard let detailContact = self.detailContact else { return }
            
            // Open message
            let message = MFMessageComposeViewController()
            message.body = "Message body"
            message.recipients = ["\(detailContact.phone_number)"]
            message.messageComposeDelegate = self
            self.present(message, animated: true, completion: nil)
        }
    }
    
    @IBAction func callButtonTapped(_ sender: UIButton) {
        // Check detail contact has a value
        guard let detailContact = self.detailContact else { return }
        
        // Open Call
        guard let number = URL(string: "tel://" + "\(detailContact.phone_number)") else { return }
        UIApplication.shared.open(number)
    }
    
    @IBAction func emailButtonTapped(_ sender: UIButton) {
        if (MFMailComposeViewController.canSendMail()) {
            // Check detail contact has a value
            guard let detailContact = self.detailContact else { return }
            
            // Open email
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["\(detailContact.email)"])
            mail.setMessageBody("<p>Sent from contact app</p>", isHTML: true)
            self.present(mail, animated: true, completion: nil)
        }
    }
    
    @IBAction func favoriteButtonTapped(_ sender: UIButton) {
        // Check detail contact has a value
        guard let detailContact = self.detailContact else { return }
        
        // Change fav pict when tapped
        if detailContact.favorite {
            favoriteButton.setImage(UIImage(named: "favourite_button"), for: .normal)
        } else {
            favoriteButton.setImage(UIImage(named: "favourite_button_selected"), for: .normal)
        }
        
        // Put request
        let url = "https://gojek-contacts-app.herokuapp.com/contacts/\(detailContact.id).json"
        let header = ["Content-Type": "application/json"]
        let parameter: Parameters = [
            "favorite": "\(!(detailContact.favorite))"
        ]
        
        Alamofire.request(url, method: .put, parameters: parameter, encoding: JSONEncoding.default, headers: header)
            .responseJSON { response in
                switch response.result {
                case .success(let data):
                    self.detailContact?.favorite = !(detailContact.favorite)
                    print("Ok: \(data)")
                case .failure(let error):
                    print("Error: \(error)")
                }
        }
    }
    
}


extension DetailContactViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return labelHeader.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "editContactCell", for: indexPath) as! EditContactTableViewCell
        cell.selectionStyle = .none
        cell.inputTextField.isEnabled = false
        cell.headerLabel.text = labelHeader[indexPath.row]
        cell.inputTextField.text = labelDetail[indexPath.row]
        return cell
    }
}

extension DetailContactViewController: MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate {
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension DetailContactViewController {
    func getDetailContactData() {
        guard let contactURL = url else { return }
        
        // Reset data
        self.detailContact = nil
        self.url = nil
        self.labelDetail.removeAll()
        self.labelHeader.removeAll()
        
        // Request API
        Alamofire.request(contactURL, method: .get)
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
                let json = JSON(value)
                
                // Get Required Data
                let id = json["id"].intValue
                let first_name = json["first_name"].stringValue
                let last_name = json["last_name"].stringValue
                let email = json["email"].stringValue
                let phone_number = json["phone_number"].stringValue
                let profile_pic = json["profile_pic"].stringValue
                let favorite = json["favorite"].boolValue
                
                self.detailContact = DetailContact(id: id, first_name: first_name, last_name: last_name, email: email, phone_number: phone_number, profile_pic: profile_pic, favorite: favorite)
                self.labelDetail.append(contentsOf: [phone_number,email])
                self.labelHeader.append(contentsOf: ["mobile","email"])
                
                // Reload Interface
                self.nameContactLabel.text = "\(first_name) \(last_name)"
                
                if favorite {
                    self.favoriteButton.setImage(UIImage(named: "favourite_button_selected"), for: .normal)
                } else {
                    self.favoriteButton.setImage(UIImage(named: "favourite_button"), for: .normal)
                }
                
                self.detailContactTableView.reloadData()
                
            } else {
                // If response error, do something here
                print("No data contacts")
            }
        })
    }
}
