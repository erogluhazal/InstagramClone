//
//  ProfileViewController+CollectionView.swift
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

extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "postCell", for: indexPath) as! ProfileCollectionViewCell
        cell.imageView.sd_setImage(with: URL(string: images[indexPath.row]))
        postsCount.setTitle(String(images.count), for: .normal)
        return cell
    }
    
    func getDataFromFirebase() {
        let databaseReference = Database.database().reference()
        let imageRef = databaseReference.child("users").child((Auth.auth().currentUser?.uid)!).child("post")
        imageRef.observe(DataEventType.value) { (Snapshot) in
            if let images = Snapshot.value as? NSDictionary {
                self.imagesId = []
                self.images = []
                for (key, _) in images {
                    let image = images[key] as! NSDictionary
                    let imageId = key as! String
                    self.images.append(image["image"] as! String)
                    self.imagesId.append(imageId)
                }
                self.userPostsCollectionView.reloadData()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let imageViewController = storyboard.instantiateViewController(withIdentifier: "ImageViewController") as! ImageViewController
        
        let cell = collectionView.cellForItem(at: indexPath) as! ProfileCollectionViewCell
        imageViewController.img = cell.imageView.image
        imageViewController.postId = imagesId[indexPath.row]
        imageViewController.userId = Auth.auth().currentUser?.uid
        present(imageViewController, animated: true)
    }
}
