//
//  Functions.swift
//  InstagramClone
//
//  Created by Teknasyon-S on 12.12.2018.
//  Copyright © 2018 Hazal Eroglu. All rights reserved.
//

import Foundation

struct Functions {
    
    func followerFunc() {
        let databaseReference = Database.database().reference()
        var ref: DatabaseReference? = nil
        if let userImageId = variables?.imageUserId {
            ref = databaseReference.child("users").child(userImageId).child("followers")
        }
        guard ref != nil else { return }
        ref?.observe(.value) { (snapshot) in
            if let value = snapshot.value as? NSDictionary {
                self.followers.setTitle(String(value.count), for: .normal)
                for (key, _) in value {
                    if key as! String == Auth.auth().currentUser?.uid {
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
        if let userId = Auth.auth().currentUser?.uid {
            ref = databaseReference.child("users").child(userId).child("followers")
        }
        guard ref != nil else { return }
        ref?.observe(.value) { (snapshot) in
            if let value = snapshot.value as? NSDictionary {
                self.following.setTitle(String(value.count), for: .normal)
                for (key, _) in value {
                    if key as! String == userImageId {
                        self.followButton.isSelected = true
                        break
                    }
                }
            } else {
                self.followers.setTitle("0", for: .normal)
            }
        }
    }
}
