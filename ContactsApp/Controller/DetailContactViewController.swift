//
//  DetailContactViewController.swift
//  ContactsApp
//
//  Created by Fereizqo Sulaiman on 06/02/20.
//  Copyright © 2020 Fereizqo Sulaiman. All rights reserved.
//

import UIKit

class DetailContactViewController: UIViewController {

    @IBOutlet weak var editBarButton: UIBarButtonItem!
    @IBOutlet weak var photoContactImage: UIImageView!
    @IBOutlet weak var nameContactLabel: UILabel!
    @IBOutlet weak var detailContactTableView: UITableView!
    
    let label = ["mobile", "email"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Register xib cell
        let cellNib = UINib(nibName: "EditContactTableViewCell", bundle: nil)
        detailContactTableView.register(cellNib, forCellReuseIdentifier: "editContactCell")
        
        detailContactTableView.delegate = self
        detailContactTableView.dataSource = self
    }
    
    @IBAction func messageButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func callButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func emailButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func favoriteButtonTapped(_ sender: UIButton) {
    }
    
}


extension DetailContactViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return label.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "editContactCell", for: indexPath) as! EditContactTableViewCell
        cell.headerLabel.text = label[indexPath.row]
        return cell
    }
}
