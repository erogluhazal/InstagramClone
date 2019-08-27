//
//  UsersProfileViewController+CollectionView.swift
//  InstagramClone
//
//  Created by Teknasyon-S on 17.12.2018.
//  Copyright © 2018 Hazal Eroglu. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

extension UsersProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "userPostCell", for: indexPath) as! UsersProfileCollectionViewCell
        cell.postView.sd_setImage(with: URL(string: images[indexPath.row]))
        postsCount.setTitle(String(images.count), for: .normal)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let imageViewController = storyboard.instantiateViewController(withIdentifier: "ImageViewController") as! ImageViewController
        
        let cell = collectionView.cellForItem(at: indexPath) as! UsersProfileCollectionViewCell
        imageViewController.img = cell.postView.image
        imageViewController.userId = variables?.imageUserId
        present(imageViewController, animated: true)
        
    }
    
    func getDataFromFirebase() {
        let databaseReference = Database.database().reference()
        let imageRef = databaseReference.child("users").child((variables?.imageUserId)!).child("post")
        imageRef.observe(DataEventType.value) { (Snapshot) in
            if let images = Snapshot.value as? NSDictionary {
                for (key, _) in images {
                    let image = images[key] as! NSDictionary
                    self.images.append(image["image"] as! String)
                }
                self.usersPostCollectionView.reloadData()
            }
        }
    }
}
