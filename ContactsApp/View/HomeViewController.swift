//
//  HomeViewController.swift
//  ContactsApp
//
//  Created by Fereizqo Sulaiman on 06/02/20.
//  Copyright © 2020 Fereizqo Sulaiman. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class HomeViewController: UIViewController {

    @IBOutlet weak var homeTableView: UITableView!
    @IBOutlet weak var addBarButton: UIBarButtonItem!
    @IBOutlet weak var groupBarButton: UIBarButtonItem!
    
    var contacts: [Contact] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register xib cell
        let cellNib = UINib(nibName: "ContactTableViewCell", bundle: nil)
        homeTableView.register(cellNib, forCellReuseIdentifier: "contactCell")
        
        homeTableView.delegate = self
        homeTableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        getContactData()
    }
    
    @IBAction func addBarButtonTapped(_ sender: UIBarButtonItem) {
        let nc = UIStoryboard(name: "EditContactScreen", bundle: nil).instantiateViewController(withIdentifier: "editContactScreenNavController") as! UINavigationController
//        let vc = nc.viewControllers.first as! EditContactViewController
//        vc.garageView = self
        
        self.present(nc, animated: true, completion: nil)
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath) as! ContactTableViewCell
        cell.nameContactLabel.text = "\(contacts[indexPath.row].first_name) \(contacts[indexPath.row].last_name)"
        cell.favoriteContactImage.isHidden = !(contacts[indexPath.row].favorite)
        cell.photoContactImage.load(url: URL(fileURLWithPath: "\(contacts[indexPath.row].url)"))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nc = UIStoryboard(name: "DetailContactScreen", bundle: nil).instantiateViewController(withIdentifier: "detailContactScreenNavController") as! UINavigationController
        
        self.present(nc, animated: true, completion: nil)
    }
}

extension HomeViewController {
    func getContactData() {
        
        self.contacts.removeAll()
        self.homeTableView.reloadData()
        
        Alamofire.request("https://gojek-contacts-app.herokuapp.com/contacts.json", method: .get)
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
//                let listData = JSON(value).arrayValue.sorted(by: {$0["first_name"] <  $1["first_name"]})
                let listData = JSON(value).arrayValue
                // let listData = JSON(value)["task"].arrayValue
               
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
                
                // Reload tableview
                self.homeTableView.reloadData()
                
            } else {
                // If response error, do something here
                print("No data contacts")
            }
        })
    }
}
