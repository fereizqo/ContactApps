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
        
        // Get contact with loading spinner
        Spinner.shared.showSpinner(onView: view)
        getAllContacts()
    }
    
    func getAllContacts() {
        APIRequest.shared.getContacts { result, error  in
            if error == nil {
                self.contacts.append(result)
                self.homeTableView.reloadData()
                Spinner.shared.removeSpinner()
            } else {
                let alert = Helper.makeAlert(title: "Alert", messages: "There is problem when connecting server")
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func addBarButtonTapped(_ sender: UIBarButtonItem) {
        // Go to edit contact screen
        let nc = UIStoryboard(name: "EditContactScreen", bundle: nil).instantiateViewController(withIdentifier: "editContactScreenNavController") as! UINavigationController
        nc.modalPresentationStyle = .fullScreen
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
        // Animate after select
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Go to detail contact screen
        let nc = UIStoryboard(name: "DetailContactScreen", bundle: nil).instantiateViewController(withIdentifier: "detailContactScreenNavController") as! UINavigationController
        let vc = nc.viewControllers.first as! DetailContactViewController
        vc.url = "\(contacts[indexPath.row].url)"
        nc.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
