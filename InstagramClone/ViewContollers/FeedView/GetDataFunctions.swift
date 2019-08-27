//
//  GetDataFunctions.swift
//  InstagramClone
//
//  Created by Teknasyon-S on 14.12.2018.
//  Copyright © 2018 Hazal Eroglu. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseDatabase

struct GetDataFunctions {
    
    func getProfilePhotoFromFirebase() {
        profilePhotosArray = [String]()
        let databaseReference = Database.database().reference()
        databaseReference.child("users").observe(DataEventType.value) { (Snapshot) in
            let values = Snapshot.value as! NSDictionary
            for (key, _) in values {
                let user = values[key] as! NSDictionary
                if let profileImage = user["profileImage"] as? NSDictionary {
                    let imageURL = profileImage["profileImage"] as! String
                    self.profilePhotosArray.append(imageURL)
                } else {
                    self.profilePhotosArray.append("empty")
                }
            }
            self.tableView.reloadData()
        }
    }
    
    func getDataFromFirebase() {
        
        userEmailArray = [String]()
        userCommentArray = [String]()
        userImageArray = [String]()
        userPostLike = [String]()
        userIdArray = [String]()
        imageIdArray = [String]()
        let databaseReference = Database.database().reference()
        databaseReference.child("users").observe(DataEventType.childAdded) { (Snapshot) in
            //            print("children: \(Snapshot.children)")
            //            print("value: \(Snapshot.value)")
            let key = Snapshot.key
            let values = Snapshot.value! as! NSDictionary
            let post = values["post"] as! NSDictionary
            let postId = post.allKeys as! [String]
            for id in postId {
                let singlePost = post[id] as! NSDictionary
                
                self.imageIdArray.append(id as! String)
                self.userIdArray.append(key)
                self.userCommentArray.append(singlePost["postText"] as! String)
                self.userEmailArray.append(singlePost["postedBy"] as! String)
                self.userImageArray.append(singlePost["image"] as! String)
            }
            self.getProfilePhotoFromFirebase()
        }
    }

    func emailClicked(userId: String, userEmail: String) {
        let variable = Variables(imageUserId: userId, userEmail: userEmail)
        performSegue(withIdentifier: "toProfile", sender: variable)
    }
    
}
