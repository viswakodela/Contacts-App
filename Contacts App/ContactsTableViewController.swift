//
//  ViewController.swift
//  Contacts App
//
//  Created by Viswa Kodela on 8/16/18.
//  Copyright © 2018 Viswa Kodela. All rights reserved.
//

import UIKit
import Contacts

class ContactsTableViewController: UITableViewController, UISearchBarDelegate {
    
    let cellId = "cellId"
    var contacts = [Contacts]()
    var filteredContacts = [Contacts]()
    
    let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationAndTableViewSetUp()
        retreiveContacts()
        searchController.searchBar.delegate = self
    }
    
    fileprivate func navigationAndTableViewSetUp() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        navigationItem.title = "Contacts"
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.rowHeight = 70
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.dimsBackgroundDuringPresentation = false
        tableView.keyboardDismissMode = .onDrag
        
    }
    
    //MARK:- SearBar Delegate Method
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty {
            filteredContacts = contacts
        }else {
            self.filteredContacts = contacts.filter({ (contact) -> Bool in
                return contact.firstName.lowercased().contains(searchText.lowercased())
            })
        }
        tableView.reloadData()
    }
    
    func retreiveContacts() {
        
        let contactsStore = CNContactStore()
        
        contactsStore.requestAccess(for: .contacts) { (granted, error) in
            if error != nil {
                print("Error retreiving contacts:", error ?? "Something went wrong")
            }
            if granted {
                print("Access Granted")
                
                let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey, CNContactImageDataKey]
                let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
               
                do {
                    
                    try contactsStore.enumerateContacts(with: request, usingBlock: { (contact, unsafePointer) in
//                        print(contact.givenName + " " + contact.familyName)
                        
                        if let phoneNumber = contact.phoneNumbers.first?.value.stringValue{
//                            let sortedContacts = self.contacts.sorted { $0.firstName < $1.firstName }
//                            self.contacts = sortedContacts
                            DispatchQueue.main.async {
                                
                                self.contacts.append(Contacts(firstName: contact.givenName, lastName: contact.familyName, phoneNumber: phoneNumber))
                                
                                let sortedcontacts = self.contacts.sorted(by: { (c1, c2) -> Bool in
                                    c1.firstName < c2.firstName
                                })
                                self.contacts = sortedcontacts
                                self.filteredContacts = self.contacts
                                self.tableView.reloadData()
                            }
                        }
                    })
                }catch {
                    print("Error enumerating the Contacts:", error)
                }
            }else {
                print("Acces Denied")
            }
        }
    }
    
}

//MARK:- TableView Methods

extension ContactsTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredContacts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        let contact = filteredContacts[indexPath.row]
        cell.textLabel?.numberOfLines = -1
        
        let attributedtext = NSMutableAttributedString(string: contact.firstName, attributes: [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 18)])
        attributedtext.append(NSAttributedString(string: " " + contact.lastName, attributes: [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 18)]))
        attributedtext.append(NSAttributedString(string: "\n"+contact.phoneNumber, attributes: [NSAttributedStringKey.foregroundColor : UIColor.gray]))
        cell.textLabel?.attributedText = attributedtext
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

