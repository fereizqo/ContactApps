//
//  HomeViewController.swift
//  ContactsApp
//
//  Created by Fereizqo Sulaiman on 06/02/20.
//  Copyright © 2020 Fereizqo Sulaiman. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var homeTableView: UITableView!
    @IBOutlet weak var addBarButton: UIBarButtonItem!
    @IBOutlet weak var groupBarButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Register xib cell
        let cellNib = UINib(nibName: "ContactTableViewCell", bundle: nil)
        homeTableView.register(cellNib, forCellReuseIdentifier: "contactCell")
        
        homeTableView.delegate = self
        homeTableView.dataSource = self
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
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath) as! ContactTableViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nc = UIStoryboard(name: "DetailContactScreen", bundle: nil).instantiateViewController(withIdentifier: "detailContactScreenNavController") as! UINavigationController
        
        self.present(nc, animated: true, completion: nil)
    }
    
}
