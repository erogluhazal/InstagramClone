//
//  SearchViewController.swift
//  InstagramClone
//
//  Created by Teknasyon-S on 20.12.2018.
//  Copyright © 2018 Hazal Eroglu. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class SearchViewController: UIViewController {
    
    var usersEmail: [String] = []
    var emails = [String]()
    var searching = false
    var userId: [String] = []
    var userEmail: String = ""
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        getDataFromFirebase()
        emails = []
    }
    
    func getDataFromFirebase() {
        let databaseReference = Database.database().reference()
        let usersRef = databaseReference.child("users")
        
        usersRef.observe(DataEventType.value) { (Snapshot) in
            self.usersEmail = []
            self.userId = []
            self.emails = []
            if let users = Snapshot.value as? NSDictionary {
                for (key, _) in users {
                    if let user = users[key] as? NSDictionary {
                        if let email = user["email"] as? String {
                            self.usersEmail.append(email)
                            self.userEmail = email
                            let id = user["userId"] as! String
                            self.userId.append(id)
                        }
                    }
                }
                for email in self.usersEmail {
                    
                    self.emails.append(email)
                }
                self.searchTable.reloadData()
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toProfile" {
            if let vc = segue.destination as? UsersProfileViewController {
                vc.variables = sender as! Variables
            }
        }
    }
}
