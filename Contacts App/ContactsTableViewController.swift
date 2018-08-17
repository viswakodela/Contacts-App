//
//  ViewController.swift
//  Contacts App
//
//  Created by Viswa Kodela on 8/16/18.
//  Copyright © 2018 Viswa Kodela. All rights reserved.
//

import UIKit

class ContactsTableViewController: UITableViewController {
    
    let cellId = "cellId"
    var contacts = [Contacts(firstName: "Viswa", lastName: "Kodela", phonrNumber: "4389238665"),
                    Contacts(firstName: "Mouni", lastName: "Kodela", phonrNumber: "1234567891")]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        navigationItem.title = "Contacts"
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.rowHeight = 70
    }
}

extension ContactsTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        let contact = contacts[indexPath.row]
        cell.textLabel?.numberOfLines = -1
        
        let attributedtext = NSMutableAttributedString(string: contact.firstName, attributes: [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 18)])
        attributedtext.append(NSAttributedString(string: " " + contact.lastName, attributes: [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 18)]))
        attributedtext.append(NSAttributedString(string: "\n"+contact.phonrNumber, attributes: [NSAttributedStringKey.foregroundColor : UIColor.gray]))
        cell.textLabel?.attributedText = attributedtext
        
        return cell
    }
    
}

