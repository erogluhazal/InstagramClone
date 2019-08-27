//
//  FollowingViewController.swift
//  InstagramClone
//
//  Created by Teknasyon-S on 7.12.2018.
//  Copyright © 2018 Hazal Eroglu. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage

class FollowingTableViewController: UITableViewController {

    var following: [String] = []
    var userId: [String] = []
    var userEmail: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDataFromFirebase()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return following.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myFollowing", for: indexPath) as! FollowingTableViewCell
        cell.userEmail.text = following[indexPath.row]

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tempEmail = following[indexPath.row]
        var id = ""
        for (index, email) in following.enumerated() {
            if email == tempEmail {
                id = userId[index]
            }
        }
        
        let variable = Variables(imageUserId: id, userEmail: tempEmail)
        performSegue(withIdentifier: "toProfile", sender: variable)
    }
 
    func getDataFromFirebase() {
        let databaseReference = Database.database().reference()
        let followingRef = databaseReference.child("users").child((Auth.auth().currentUser?.uid)!).child("following")
        followingRef.observe(DataEventType.value) { (Snapshot) in
            self.following = []
            self.userId = []
            if let following = Snapshot.value as? NSDictionary {
                for (key, _) in following {
                    if let follow = following[key] as? NSDictionary {
                        let email = follow["userEmail"] as! String
                        let id = follow["userId"] as! String
                        //let id = follow["userId"] as? String
                        self.following.append(email)
                        self.userId.append(id)
                        self.userEmail = email
                    }
                }
                self.tableView.reloadData()
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
