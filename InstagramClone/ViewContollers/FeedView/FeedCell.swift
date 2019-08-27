//
//  FeedCell.swift
//  InstagramClone
//
//  Created by Teknasyon-S on 29.11.2018.
//  Copyright © 2018 Hazal Eroglu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class FeedCell: UITableViewCell {

    var variables: Variables!
    var userVariables: [UserVariables]?
    var feedCellVariables: FeedCellVaribles?
    var delegate: FeedCellDelegate?
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userEmailButton: UIButton!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userCommentLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likes: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()

        variables = Variables()
        feedCellVariables = FeedCellVaribles()
        profileImageView.layer.masksToBounds = true
        likeButton.setImage(UIImage(named: Shortcuts.Images.likedIcon), for: .selected)
        likeButton.setImage(UIImage(named: Shortcuts.Images.unlikedIcon), for: .normal)
        // Initialization code
  //      likes.setTitle(likesCount, for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configureCell() {
        likeButton.setImage(UIImage(named: Shortcuts.Images.unlikedIcon), for: .normal)
        let databaseReference = Database.database().reference()
        let ref = databaseReference.child("users").child(variables.imageUserId!).child("post").child((feedCellVariables?.imageId!)!).child("likes")
        ref.observe(.value) { (snapshot) in
            if let value = snapshot.value as? NSDictionary {
                self.likes.setTitle(String(value.count), for: .normal)
                for (key, _) in value {
                    if (key as! String) == Auth.auth().currentUser?.uid {
                        self.likeButton.setImage(UIImage(named: Shortcuts.Images.likedIcon), for: .selected)
                        self.likeButton.isSelected = true
                        break
                    }
                }
            } else {
                self.likes.setTitle("0", for: .normal)
            }
            
        }
    }
    
    func profileImage() {
        let databaseReference = Database.database().reference()
        if let userProfile = variables.imageUserId {
            let profileImageRef = databaseReference.child("users").child(userProfile).child("profileImage")
            profileImageRef.observe(.value) { (snapshot) in
                if let values = snapshot.value as? NSDictionary {
                    let image = values["profileImage"] as? String
                    self.profileImageView.sd_setImage(with: URL(string: image!), completed: nil)
                }
            }
        }
    }

    @IBAction func emailButtonClicked(_ sender: Any) {
        delegate?.emailClicked(userId: variables!.imageUserId!, userEmail: variables!.userEmail!)
    }
    
    @IBAction func likeButtonClicked(_ sender: Any) {
        likeButton.isSelected = !likeButton.isSelected
        let databaseReference = Database.database().reference()
        if likeButton.isSelected {
            databaseReference.child("users").child(variables.imageUserId!).child("post").child((feedCellVariables?.imageId!)!).child("likes").child((Auth.auth().currentUser?.uid)!).child("userId").setValue((Auth.auth().currentUser?.uid)!)
            databaseReference.child("users").child(variables.imageUserId!).child("post").child((feedCellVariables?.imageId!)!).child("likes").child((Auth.auth().currentUser?.uid)!).child("userName").setValue(Auth.auth().currentUser?.email)
        } else {
            databaseReference.child("users").child(variables.imageUserId!).child("post").child((feedCellVariables?.imageId!)!).child("likes").child((Auth.auth().currentUser?.uid)!).removeValue()
        }
    }
}

protocol FeedCellDelegate {
    func emailClicked(userId: String, userEmail: String)
}
