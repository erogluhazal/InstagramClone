//
//  FollowersViewController.swift
//  InstagramClone
//
//  Created by Teknasyon-S on 7.12.2018.
//  Copyright © 2018 Hazal Eroglu. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage

class FollowersTableViewController: UITableViewController {

    var followers: [String] = []
    var userId: [String] = []
    var userEmail: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        getDataFromFirebase()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return followers.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return followers.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tempEmail = followers[indexPath.row]
        var id = ""
        for (index, email) in followers.enumerated() {
            if email == tempEmail {
                id = userId[index]
            }
        }
        
        let variable = Variables(imageUserId: id, userEmail: tempEmail)
        performSegue(withIdentifier: "toProfile", sender: variable)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myFollowers", for: indexPath) as! FollowersTableViewCell
        cell.userEmail.text = followers[indexPath.row]
        return cell
    }
    
    func getDataFromFirebase() {
        let databaseReference = Database.database().reference()
        let followersRef = databaseReference.child("users").child((Auth.auth().currentUser?.uid)!).child("followers")
        followersRef.observe(DataEventType.value) { (Snapshot) in
            self.followers = []
            self.userId = []
            if let followers = Snapshot.value as? NSDictionary {
                for (key, _) in followers {
                    if let follower = followers[key] as? NSDictionary {
                        if let email = follower["userEmail"] as? String {
                            let id = follower["userId"] as! String
                            //let id = follower["userId"] as? String
                            self.followers.append(email)
                            self.userId.append(id)
                            self.userEmail = email
                        }
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
