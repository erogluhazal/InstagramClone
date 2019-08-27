//
//  UsersFollowingTableViewController.swift
//  InstagramClone
//
//  Created by Teknasyon-S on 18.12.2018.
//  Copyright © 2018 Hazal Eroglu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class UsersFollowingTableViewController: UITableViewController {

    var variables: Variables?
    var following: [String] = []
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

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return following.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "usersFollowing", for: indexPath) as! UsersFollowingTableViewCell
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
        let followingRef = databaseReference.child("users").child(variables!.imageUserId!).child("following")
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
            }
            self.tableView.reloadData()
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
