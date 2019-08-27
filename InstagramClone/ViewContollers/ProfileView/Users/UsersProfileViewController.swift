//
//  UsersProfileViewController.swift
//  InstagramClone
//
//  Created by Teknasyon-S on 10.12.2018.
//  Copyright © 2018 Hazal Eroglu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage

class UsersProfileViewController: UIViewController {

    var images: [String] = []
    var variables: Variables?
    @IBOutlet weak var usersPostCollectionView: UICollectionView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var followers: UIButton!
    @IBOutlet weak var following: UIButton!
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var postsCount: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = variables?.userEmail
        if variables?.imageUserId == Auth.auth().currentUser?.uid {
            followButton.isHidden = true
        }
        
        followButton.setTitle("follow", for: .normal)
        followButton.setTitle("following", for: .selected)
        userEmail.text = variables?.userEmail
        profileImage()
        followersFunc()
        followingFunc()
        profileImageView.layer.masksToBounds = true
        getDataFromFirebase()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func followButtonClicked(_ sender: Any) {
        followButton.isSelected = !followButton.isSelected
        let databaseReference = Database.database().reference()
        let userEmail = variables?.userEmail
        if let imageUserId = variables?.imageUserId {
            if followButton.isSelected {
                databaseReference.child("users").child(imageUserId).child("followers").child((Auth.auth().currentUser?.uid)!)
                databaseReference.child("users").child(imageUserId).child("followers").child((Auth.auth().currentUser?.uid)!).child("userId").setValue((Auth.auth().currentUser?.uid)!)
                databaseReference.child("users").child(imageUserId).child("followers").child((Auth.auth().currentUser?.uid)!).child("userEmail").setValue((Auth.auth().currentUser?.email)!)
                
                databaseReference.child("users").child((Auth.auth().currentUser?.uid)!).child("following").child(imageUserId)
                databaseReference.child("users").child((Auth.auth().currentUser?.uid)!).child("following").child(imageUserId).child("userId").setValue(imageUserId)
                databaseReference.child("users").child((Auth.auth().currentUser?.uid)!).child("following").child(imageUserId).child("userEmail").setValue(userEmail)
                
            } else {
                databaseReference.child("users").child(imageUserId).child("followers").child((Auth.auth().currentUser?.uid)!).removeValue()
                databaseReference.child("users").child((Auth.auth().currentUser?.uid)!).child("following").child(imageUserId).removeValue()
            }
        }
        let timeText = "5"
        guard let time = TimeInterval(timeText) else { return }
        LocalPushManager.shared.sendLocalPush(in: time)
    }
    
    func profileImage() {
        let databaseReference = Database.database().reference()
        let profileImageRef = databaseReference.child("users").child((variables?.imageUserId)!).child("profileImage")
        profileImageRef.observe(.value) { (snapshot) in
            if let values = snapshot.value as? NSDictionary {
                let image = values["profileImage"] as? String
                // var url = NSURL.fileURL(withPath: image!)
                self.profileImageView.sd_setImage(with: URL(string: image!), completed: nil)
            }
        }
    }
    
    func followersFunc() {
        let databaseReference = Database.database().reference()
        var ref: DatabaseReference? = nil
        if let userImageId = variables?.imageUserId {
            ref = databaseReference.child("users").child(userImageId).child("followers")
        }
        guard ref != nil else { return }
        ref?.observe(.value) { (snapshot) in
        if let value = snapshot.value as? NSDictionary {
            self.followers.setTitle(String(value.count), for: .normal)
            self.followers.setTitle(String(value.count), for: .selected)
            for (key, _) in value {
                if key as? String == Auth.auth().currentUser?.uid {
                    self.followButton.isSelected = true
                    break
                }
            }
        } else {
            self.followers.setTitle("0", for: .normal)
                }
        }
    }
    
    func followingFunc() {
        let databaseReference = Database.database().reference()
        let userImageId = variables?.imageUserId
        var ref: DatabaseReference? = nil
        if let userImageId = variables?.imageUserId {
            ref = databaseReference.child("users").child(userImageId).child("following")
        }
        guard ref != nil else { return }
        ref?.observe(.value) { (snapshot) in
            if let value = snapshot.value as? NSDictionary {
                self.following.setTitle(String(value.count), for: .normal)
                self.following.setTitle(String(value.count), for: .selected)
                for (key, _) in value {
                    if (key as! String) == userImageId {
                        self.followButton.isSelected = true
                        break
                    }
                }
            } else {
                self.following.setTitle("0", for: .normal)
            }
        }
    }
    
    @IBAction func followerClicked(_ sender: Any) {
        performSegue(withIdentifier: "userFollowersTable", sender: nil)
    }
    
    @IBAction func followingClicked(_ sender: Any) {
        performSegue(withIdentifier: "userFollowingTable", sender: nil)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "userFollowersTable" {
            if let vc = segue.destination as? UsersFollowersTableViewController {
                vc.variables = variables
            }
        }
        if segue.identifier == "userFollowingTable" {
            if let vc = segue.destination as? UsersFollowingTableViewController {
                vc.variables = variables
            }
        }
    }
}
