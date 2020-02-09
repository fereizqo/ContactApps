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
    @IBOutlet weak var topView: UIView!
    
    var url: String?
    var detailContact: DetailContact?
    var labelDetail = [" ", " "]
    var labelHeader = ["mobile", "email"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Load detail contact data, Put request
        Spinner.shared.showSpinner(onView: view)
        getDetailContactData()
        
        // Register xib cell
        let cellNib = UINib(nibName: "EditContactTableViewCell", bundle: nil)
        detailContactTableView.register(cellNib, forCellReuseIdentifier: "editContactCell")
        
        self.detailContactTableView.tableFooterView = UIView()
        detailContactTableView.delegate = self
        detailContactTableView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Set appearance
        nameContactLabel.sizeToFit()
        topView.setGradient(colorTop: .white, colorBottom: Helper.primaryColor)
    }
    
    func getDetailContactData() {
        guard let contactURL = url else { return }
        APIRequest.shared.getDetailContacts(url: contactURL) { result, error in
            if error == nil {
                // for better placeholder appearances
                if result.phone_number == "" {
                    result.phone_number = " "
                }
                if result.email == "" {
                    result.email = " "
                }
                
                // Reload Data and Interface
                self.labelDetail = [result.phone_number,result.email]
                self.nameContactLabel.text = "\(result.first_name) \(result.last_name)"
                
                if result.favorite {
                    self.favoriteButton.setImage(UIImage(named: "favourite_button_selected"), for: .normal)
                } else {
                    self.favoriteButton.setImage(UIImage(named: "favourite_button"), for: .normal)
                }
                self.detailContact = result
                
                self.detailContactTableView.reloadData()
                Spinner.shared.removeSpinner()
            } else {
                Spinner.shared.removeSpinner()
                let alert = Helper.makeAlert(title: "Alert", messages: "There is problem when connecting server")
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func editBarButtonTapped(_ sender: UIBarButtonItem) {
        guard let detailContact = self.detailContact else { return }
        print("move to edit")
        
        let nc = UIStoryboard(name: "EditContactScreen", bundle: nil).instantiateViewController(withIdentifier: "editContactScreenNavController") as! UINavigationController
        nc.modalPresentationStyle = .fullScreen
        nc.modalTransitionStyle = .crossDissolve
        let vc = nc.viewControllers.first as! EditContactViewController
        vc.detailContact = detailContact
        self.present(nc, animated: true, completion: nil)
        
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
        guard let detailContact = self.detailContact, let contactURL = url else { return }
        
        Spinner.shared.showSpinner(onView: view)
        
        // Change fav pict when tapped
        if detailContact.favorite {
            favoriteButton.setImage(UIImage(named: "favourite_button"), for: .normal)
        } else {
            favoriteButton.setImage(UIImage(named: "favourite_button_selected"), for: .normal)
        }
        
        // Update favorite, Put request
        let parameter: Parameters = [
            "favorite": "\(!(detailContact.favorite))"
        ]
        APIRequest.shared.updateContact(url: contactURL, parameter: parameter) { result, statusCode, error  in
            Spinner.shared.removeSpinner()
            if error == nil {
                switch statusCode {
                case 200:
                    self.detailContact?.favorite = !(detailContact.favorite)
                    
                    let alert = UIAlertController(title: "Success", message: "Favorite has been updated", preferredStyle: .alert)
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
