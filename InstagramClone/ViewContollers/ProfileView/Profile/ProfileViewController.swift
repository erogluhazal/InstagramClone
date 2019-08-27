//
//  ProfileViewController.swift
//  InstagramClone
//
//  Created by Teknasyon-S on 3.12.2018.
//  Copyright © 2018 Hazal Eroglu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var postsCount: UIButton!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var followers: UIButton!
    @IBOutlet weak var following: UIButton!
    @IBOutlet weak var profileTitle: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userPostsCollectionView: UICollectionView!
    var variables: Variables?
    var signView: SignViewController?
    var userVariables: [UserVariables] = []
    var images: [String] = []
    var imagesId: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userEmail.text = Auth.auth().currentUser?.email
        profileTitle.setTitle(Auth.auth().currentUser?.email, for: .normal)
        profileImageView.layer.masksToBounds = true
        
        followerFunc()
        followingFunc()
        profileImage()
        getDataFromFirebase()
    }
    
    @IBAction func logoutClicked(_ sender: Any) {
        
        UserDefaults.standard.removeObject(forKey: "user")
        UserDefaults.standard.synchronize()
        
        let signIn = self.storyboard?.instantiateViewController(withIdentifier: "signIn") as! SignViewController
        let delegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        delegate.window?.rootViewController = signIn
        delegate.rememberUser()
        
        do {
            try Auth.auth().signOut()
        } catch {
            print(error)
        }
    }
    
    func profileImage() {
        let databaseReference = Database.database().reference()
        let profileImageRef = databaseReference.child("users").child((Auth.auth().currentUser?.uid)!).child("profileImage")
        profileImageRef.observe(.value) { (snapshot) in
            if let values = snapshot.value as? NSDictionary {
                let image = values["profileImage"] as? String
                // var url = NSURL.fileURL(withPath: image!)
                self.profileImageView.sd_setImage(with: URL(string: image!), completed: nil)
            }
        }
        //profileImageView.sd_setImage(with: URL(profileImageLink))
    }
    
    func followerFunc() {
        let databaseReference = Database.database().reference()
        var ref: DatabaseReference? = nil
        if let userId = Auth.auth().currentUser?.uid {
            ref = databaseReference.child("users").child(userId).child("followers")
        }
        guard ref != nil else { return }
        ref?.observe(.value) { (snapshot) in
            if let value = snapshot.value as? NSDictionary {
                self.followers.setTitle(String(value.count), for: .normal)
                self.followers.setTitle(String(value.count), for: .selected)
            } else {
                self.followers.setTitle("0", for: .normal)
            }
        }
    }
    
    func followingFunc() {
        let databaseReference = Database.database().reference()
        var ref: DatabaseReference? = nil
        if let userId = Auth.auth().currentUser?.uid {
            ref = databaseReference.child("users").child(userId).child("following")
        }
        guard ref != nil else { return }
        ref?.observe(.value) { (snapshot) in
            if let value = snapshot.value as? NSDictionary {
                self.following.setTitle(String(value.count), for: .normal)
                self.following.setTitle(String(value.count), for: .selected)
            } else {
                self.following.setTitle("0", for: .normal)
            }
        }
    }
    
    @IBAction func selectImage() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        pickerController.allowsEditing = true
        present(pickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let storage = Storage.storage()
        let storageReference = storage.reference()
        let profileImageFolder = storageReference.child("ProfileImages")
        profileImageView.image = info[.originalImage] as? UIImage
        if let data = profileImageView.image?.jpegData(compressionQuality: 0.5) {
            // uniq id :
            let uuid = NSUUID().uuidString
            let profileImageReference = profileImageFolder.child("\(uuid).jpg")
            profileImageReference.putData(data, metadata: nil) { (metaData, error) in
                if error != nil {
                    let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                    let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
                    alert.addAction(okButton)
                    self.present(alert, animated: true, completion: nil)
                } else {
                    profileImageReference.downloadURL(completion: { (url, error) in
                        if error == nil {
                            let imageURL = url?.absoluteString
                            let databaseReference = Database.database().reference()
                            let profileImage = ["profileImage": imageURL!] as [String: Any]
                            databaseReference.child("users").child((Auth.auth().currentUser?.uid)!).child("profileImage").setValue(profileImage)
                        }
                    })
                    // Veritabanına Yazmak
                }
            }
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func followersClicked(_ sender: Any) {
        performSegue(withIdentifier: "myFollowersTable", sender: nil)
    }
    @IBAction func followingClicked(_ sender: Any) {
        performSegue(withIdentifier: "myFollowingTable", sender: nil)
    }
    
}
