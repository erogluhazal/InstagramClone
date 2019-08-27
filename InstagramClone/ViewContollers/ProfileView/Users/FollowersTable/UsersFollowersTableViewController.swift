//
//  UsersFollowersTableViewController.swift
//  InstagramClone
//
//  Created by Teknasyon-S on 18.12.2018.
//  Copyright © 2018 Hazal Eroglu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class UsersFollowersTableViewController: UITableViewController {

    var followers: [String] = []
    var variables: Variables?
    var userId: [String] = []
    var userEmail: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDataFromFirebase()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return followers.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "usersFollowers", for: indexPath) as! UsersFollowersTableViewCell
        cell.userEmail.text = followers[indexPath.row]

        return cell
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
    
    func getDataFromFirebase() {
        let databaseReference = Database.database().reference()
        let followersRef = databaseReference.child("users").child(variables!.imageUserId!).child("followers")
        followersRef.observe(DataEventType.value) { (Snapshot) in
            self.followers = []
            self.userId = []
            if let followers = Snapshot.value as? NSDictionary {
                for (key, _) in followers {
                    if let follower = followers[key] as? NSDictionary {
                        let email = follower["userEmail"] as! String
                        let id = follower["userId"] as! String
                        //let id = follow["userId"] as? String
                        self.followers.append(email)
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

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
