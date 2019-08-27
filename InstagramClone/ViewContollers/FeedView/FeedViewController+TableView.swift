//
//  FeedViewController+TabeView.swift
//  InstagramClone
//
//  Created by Teknasyon-S on 14.12.2018.
//  Copyright © 2018 Hazal Eroglu. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import SDWebImage

extension FeedViewController: UITableViewDelegate, UITableViewDataSource {
       
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userVariables.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        self.tableView.addSubview(self.refreshControl)
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedCell
        cell.userEmailButton.setTitle(userVariables[indexPath.row].userEmailArray, for: .normal)
        cell.userCommentLabel.text = userVariables[indexPath.row].userCommentArray
        cell.variables!.imageUserId = (userVariables.count) > 0 ? userVariables[indexPath.row].userIdArray : ""
        cell.feedCellVariables?.imageId = userVariables[indexPath.row].imageIdArray
        cell.userImageView.sd_setImage(with: URL(string: userVariables[indexPath.row].userImageArray ))
        cell.variables?.userEmail = userVariables[indexPath.row].userEmailArray
        cell.likeButton.isSelected = false
        cell.configureCell()
        cell.delegate = self
        //        cell.profileImageView!.sd_setImage(with: URL(), completed: nil)
        if userVariables[indexPath.row].profilePhotosArray.count > 0 {
            if userVariables[indexPath.row].profilePhotosArray != "empty" {
                cell.profileImageView.sd_setImage(with: URL(string: userVariables[indexPath.row].profilePhotosArray ))
            } else {
                cell.profileImageView.image = UIImage(named: "pp")
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 430
    }
    
    func getProfilePhotoFromFirebase(variable: UserVariables) {
        var variable = UserVariables()
        variable.profilePhotosArray = String()
        let databaseReference = Database.database().reference()
        databaseReference.child("users").observe(DataEventType.value) { (Snapshot) in
            let values = Snapshot.value as! NSDictionary
            for (key, _) in values {
                let user = values[key] as! NSDictionary
                if let profileImage = user["profileImage"] as? NSDictionary {
                    let imageURL = profileImage["profileImage"] as! String
                    variable.profilePhotosArray.append(imageURL)
                } else {
                    variable.profilePhotosArray.append("empty")
                }
            }
            self.userVariables.append(variable)
            self.tableView.reloadData()
        }
    }
    
    func getDataFromFirebase(completion: @escaping () -> Void) {
        let databaseReference = Database.database().reference()
        databaseReference.child("users").child(Auth.auth().currentUser!.uid).child("following").observe(DataEventType.value) { (Snapshot) in
            self.userVariables = []
            if let myFollowing = Snapshot.value as? NSDictionary {
                for (key, _) in myFollowing {
                    let myFollowingUser = myFollowing[key] as! NSDictionary
                    let myFollowingUserId = myFollowingUser["userId"] as! NSString
                    databaseReference.child("users").child(myFollowingUserId as String).observe(DataEventType.value) { (Snapshot) in
                        
                        let user = Snapshot.value as! NSDictionary
                        // for (key, _) in user {
                        if let post = user["post"] as? NSDictionary {
                            let postId = post.allKeys as! [String]
                            for id in postId {
                                var variable = UserVariables()
                                let singlePost = post[id] as! NSDictionary
                                if let profileImage = user["profileImage"] as? NSDictionary {
                                    let imageURL = profileImage["profileImage"] as! String
                                    variable.profilePhotosArray.append(imageURL)
                                } else {
                                    variable.profilePhotosArray.append("empty")
                                }
                                variable.imageIdArray = id
                                variable.userIdArray.append(key as! String)
                                variable.userCommentArray.append(singlePost["postText"] as! String)
                                variable.userEmailArray.append(singlePost["postedBy"] as! String)
                                variable.userImageArray.append(singlePost["image"] as! String)
                                self.userVariables.append(variable)
                                self.tableView.reloadData()
                                completion()
                            }
                        }
                    }
                }
                databaseReference.child("users").child((Auth.auth().currentUser?.uid)!).observe(DataEventType.value) { (Snapshot) in
                    var tempUserVariables: [UserVariables] = []
                    for element in self.userVariables {
                        if element.userIdArray != Auth.auth().currentUser!.uid {
                            tempUserVariables.append(element)
                        }
                    }
                    self.userVariables = tempUserVariables
                    let user = Snapshot.value as! NSDictionary
                    // for (key, _) in user {
                    if let post = user["post"] as? NSDictionary {
                        let postId = post.allKeys as! [String]
                        for id in postId {
                            var variable = UserVariables()
                            let singlePost = post[id] as! NSDictionary
                            if let profileImage = user["profileImage"] as? NSDictionary {
                                let imageURL = profileImage["profileImage"] as! String
                                variable.profilePhotosArray.append(imageURL)
                            } else {
                                variable.profilePhotosArray.append("empty")
                            }
                            variable.imageIdArray = id
                            variable.userIdArray.append((Auth.auth().currentUser?.uid)! as String)
                            variable.userCommentArray.append(singlePost["postText"] as! String)
                            variable.userEmailArray.append(singlePost["postedBy"] as! String)
                            variable.userImageArray.append(singlePost["image"] as! String)
                            
                            self.userVariables.append(variable)
                            self.tableView.reloadData()
                        }
                    }
                }
            } else {
                databaseReference.child("users").child((Auth.auth().currentUser?.uid)!).observe(DataEventType.value) { (Snapshot) in
                    var tempUserVariables: [UserVariables] = []
                    for element in self.userVariables {
                        if element.userIdArray != Auth.auth().currentUser!.uid {
                            tempUserVariables.append(element)
                        }
                    }
                    self.userVariables = tempUserVariables
                    let user = Snapshot.value as! NSDictionary
                    // for (key, _) in user {
                    if let post = user["post"] as? NSDictionary {
                        let postId = post.allKeys as! [String]
                        for id in postId {
                            var variable = UserVariables()
                            let singlePost = post[id] as! NSDictionary
                            if let profileImage = user["profileImage"] as? NSDictionary {
                                let imageURL = profileImage["profileImage"] as! String
                                variable.profilePhotosArray.append(imageURL)
                            } else {
                                variable.profilePhotosArray.append("empty")
                            }
                            variable.imageIdArray = id
                            variable.userIdArray.append((Auth.auth().currentUser?.uid)! as String)
                            variable.userCommentArray.append(singlePost["postText"] as! String)
                            variable.userEmailArray.append(singlePost["postedBy"] as! String)
                            variable.userImageArray.append(singlePost["image"] as! String)
                            
                            self.userVariables.append(variable)
                            self.tableView.reloadData()
                            completion()
                        }
                    }
                }
            }
            
        }
    }
    
    func emailClicked(userId: String, userEmail: String) {
        let variable = Variables(imageUserId: userId, userEmail: userEmail)
        performSegue(withIdentifier: "toProfile", sender: variable)
    }
}
